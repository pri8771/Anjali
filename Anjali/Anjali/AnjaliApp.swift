import SwiftUI
import SwiftData
import UserNotifications

@main
struct AnjaliApp: App {
    @StateObject private var library: PrayerLibrary
    @StateObject private var settings: AppSettings
    @StateObject private var coordinator: AppCoordinator

    private let modelContainer: ModelContainer
    private let notificationDelegate = NotificationDelegate()

    init() {
        Self.resetStateIfRequestedForUITesting()

        let library = PrayerLibrary()
        let settings = AppSettings()
        _library = StateObject(wrappedValue: library)
        _settings = StateObject(wrappedValue: settings)
        _coordinator = StateObject(wrappedValue: AppCoordinator(library: library))

        // SwiftData for user-generated state only. Fall back to an in-memory
        // store if the on-disk store cannot be created, so the app still runs.
        let schema = Schema([PrayerCompletion.self, FavoritePrayer.self])
        if let container = try? ModelContainer(for: schema) {
            modelContainer = container
        } else {
            // swiftlint:disable:next force_try
            modelContainer = try! ModelContainer(
                for: schema,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(library)
                .environmentObject(settings)
                .environmentObject(coordinator)
                .onAppear {
                    notificationDelegate.coordinator = coordinator
                    UNUserNotificationCenter.current().delegate = notificationDelegate
                }
                .onOpenURL { url in
                    coordinator.handle(url: url)
                }
        }
        .modelContainer(modelContainer)
    }

    /// Testability hook, not a user-facing feature: `AnjaliUITests` passes
    /// `-uiTestReset` so every run starts from a clean, deterministic
    /// first-launch state (onboarding not yet completed, no saved
    /// preferences), regardless of what a previous run on the same simulator
    /// left behind.
    ///
    /// Deliberately wipes the persisted domain directly rather than
    /// overriding individual keys via `-key value` launch arguments: those
    /// are registered in `NSArgumentDomain`, which outranks the app's own
    /// `UserDefaults` writes for the lifetime of the process — so a value
    /// like `hasCompletedOnboarding` forced to `NO` that way can never be
    /// flipped back to `YES` by the app itself (e.g. after the user finishes
    /// onboarding), silently breaking any flow that both reads and writes
    /// the same default.
    private static func resetStateIfRequestedForUITesting() {
        guard ProcessInfo.processInfo.arguments.contains("-uiTestReset") else { return }
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}

/// Routes notification taps into the coordinator's deep-link handling.
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    weak var coordinator: AppCoordinator?

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        Task { @MainActor in
            coordinator?.handleNotificationUserInfo(userInfo)
        }
        completionHandler()
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
