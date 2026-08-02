import Foundation
import UserNotifications

/// A local wall-clock time for a repeating reminder.
struct ReminderTime: Equatable, Hashable {
    let hour: Int
    let minute: Int

    init(hour: Int, minute: Int) {
        self.hour = min(23, max(0, hour))
        self.minute = min(59, max(0, minute))
    }
}

/// The three daily reminders, with stable identifiers so re-scheduling
/// replaces rather than duplicates.
enum ReminderSlot: String, CaseIterable, Identifiable {
    case dawn = "reminder.dawn"
    case sunset = "reminder.sunset"
    case sleep = "reminder.sleep"

    var id: String { rawValue }

    var title: String {
        switch self {
        case .dawn: return "Begin with light"
        case .sunset: return "Return with gratitude"
        case .sleep: return "Rest in peace"
        }
    }

    var body: String {
        switch self {
        case .dawn: return "A sacred pause to start the day."
        case .sunset: return "A moment to give thanks."
        case .sleep: return "Let the day settle before sleep."
        }
    }

    /// Default trigger time (local) for this reminder.
    var defaultHour: Int {
        switch self {
        case .dawn: return 6
        case .sunset: return 18
        case .sleep: return 21
        }
    }

    var defaultMinute: Int { 30 }

    var defaultTime: ReminderTime {
        ReminderTime(hour: defaultHour, minute: defaultMinute)
    }

    /// The moment a tap should deep-link into.
    var deepLink: DeepLink {
        switch self {
        case .dawn: return .moment(.dawn)
        case .sunset: return .moment(.sunset)
        case .sleep: return .moment(.sleep)
        }
    }
}

/// Thin wrapper over `UNUserNotificationCenter` for local-only daily reminders.
@MainActor
final class NotificationManager: ObservableObject {
    static let shared = NotificationManager()

    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    /// Ask permission. Returns whether the user granted alerts.
    func requestAuthorization() async -> Bool {
        do {
            return try await center.requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    func authorizationStatus() async -> UNAuthorizationStatus {
        await center.notificationSettings().authorizationStatus
    }

    /// Reminder slots that currently have a pending system request. This lets
    /// the app repair stale local preferences after permission or requests are
    /// changed outside Anjali.
    func pendingSlots() async -> Set<ReminderSlot> {
        let identifiers = Set(
            await center.pendingNotificationRequests().map(\.identifier)
        )
        return Set(ReminderSlot.allCases.filter { identifiers.contains($0.rawValue) })
    }

    /// Schedule a single daily reminder at a chosen local time. Uses the
    /// slot's stable identifier so a successful change atomically replaces
    /// the previous request instead of creating a duplicate.
    func schedule(_ slot: ReminderSlot, at time: ReminderTime? = nil) async throws {
        let content = UNMutableNotificationContent()
        content.title = slot.title
        content.body = slot.body
        content.sound = .default
        if let urlString = slot.deepLink.url?.absoluteString {
            content.userInfo = ["deepLink": urlString]
        }

        let resolvedTime = time ?? slot.defaultTime
        var components = DateComponents()
        components.hour = resolvedTime.hour
        components.minute = resolvedTime.minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(
            identifier: slot.rawValue,
            content: content,
            trigger: trigger
        )
        try await center.add(request)
    }

    func cancel(_ slot: ReminderSlot) {
        center.removePendingNotificationRequests(withIdentifiers: [slot.rawValue])
    }

    /// Reconcile scheduled reminders with the set the user has enabled.
    func sync(
        enabledSlots: Set<ReminderSlot>,
        times: [ReminderSlot: ReminderTime] = [:]
    ) async throws {
        let existingIDs = Set(
            await center.pendingNotificationRequests().map(\.identifier)
        )
        var addedIDs: [String] = []

        do {
            for slot in ReminderSlot.allCases where enabledSlots.contains(slot) {
                try await schedule(slot, at: times[slot])
                if !existingIDs.contains(slot.rawValue) {
                    addedIDs.append(slot.rawValue)
                }
            }
        } catch {
            // Keep persisted settings and notification-center state aligned if
            // a multi-reminder opt-in only schedules partially.
            center.removePendingNotificationRequests(withIdentifiers: addedIDs)
            throw error
        }

        for slot in ReminderSlot.allCases where !enabledSlots.contains(slot) {
                cancel(slot)
        }
    }
}
