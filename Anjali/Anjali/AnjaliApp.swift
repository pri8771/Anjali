import SwiftUI
import SwiftData
import UserNotifications

@main
struct AnjaliApp: App {
    @StateObject private var library: PrayerLibrary
    @StateObject private var settings: AppSettings
    @StateObject private var coordinator: AppCoordinator
    @StateObject private var persistenceHealth: PersistenceHealth

    private let modelContainer: ModelContainer
    private let notificationDelegate = NotificationDelegate()

    init() {
        #if DEBUG
        let shouldResetUITestState = ProcessInfo.processInfo.arguments.contains("-uiTestReset")
        if shouldResetUITestState {
            Self.resetUserDefaultsForUITesting()
        }
        #else
        let shouldResetUITestState = false
        #endif

        let library = PrayerLibrary()
        let settings = AppSettings()
        _library = StateObject(wrappedValue: library)
        _settings = StateObject(wrappedValue: settings)
        _coordinator = StateObject(wrappedValue: AppCoordinator(library: library))

        // SwiftData for user-generated state only. Fall back to an in-memory
        // store if the on-disk store cannot be created, so the app still runs.
        // PersistenceHealth makes that degraded state visible to the user.
        let schema = Schema([PrayerCompletion.self, FavoritePrayer.self])
        if let container = try? ModelContainer(for: schema) {
            modelContainer = container
            _persistenceHealth = StateObject(wrappedValue: PersistenceHealth(isPersistent: true))
        } else {
            // swiftlint:disable:next force_try
            modelContainer = try! ModelContainer(
                for: schema,
                configurations: ModelConfiguration(isStoredInMemoryOnly: true)
            )
            _persistenceHealth = StateObject(wrappedValue: PersistenceHealth(isPersistent: false))
        }

        #if DEBUG
        if shouldResetUITestState {
            Self.resetSwiftDataForUITesting(in: modelContainer)
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(library)
                .environmentObject(settings)
                .environmentObject(coordinator)
                .environmentObject(persistenceHealth)
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

    #if DEBUG
    /// Debug-only testability hook: `AnjaliUITests` passes
    /// `-uiTestReset` so every run starts from a clean, deterministic
    /// first-launch state, regardless of what a previous run left behind.
    ///
    /// Deliberately wipes the persisted domain directly rather than
    /// overriding individual keys via `-key value` launch arguments: those
    /// are registered in `NSArgumentDomain`, which outranks the app's own
    /// `UserDefaults` writes for the lifetime of the process — so a value
    /// like `hasCompletedOnboarding` forced to `NO` that way can never be
    /// flipped back to `YES` by the app itself (e.g. after the user finishes
    /// onboarding), silently breaking any flow that both reads and writes
    /// the same default.
    private static func resetUserDefaultsForUITesting() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }

    private static func resetSwiftDataForUITesting(in container: ModelContainer) {
        let context = ModelContext(container)
        do {
            try context.delete(model: PrayerCompletion.self)
            try context.delete(model: FavoritePrayer.self)
            try context.save()
        } catch {
            assertionFailure("Could not reset SwiftData for UI tests: \(error)")
        }
    }
    #endif
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
