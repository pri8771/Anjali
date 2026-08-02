import Foundation
import SwiftUI
import Combine

/// User preferences, persisted in `UserDefaults`. Exposed as an
/// `ObservableObject` so both SwiftUI views and the Today computation can read
/// a single source of truth. Lists/optionals are stored as raw-value strings.
@MainActor
final class AppSettings: ObservableObject {

    enum Key {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let scriptPreference = "scriptPreference"
        static let preferredPrayerMode = "preferredPrayerMode"
        static let ishtaDevata = "ishtaDevata"
        static let favoriteMoments = "favoriteMoments"
        static let enabledReminders = "enabledReminders"

        static func reminderHour(_ slot: ReminderSlot) -> String {
            "reminderTime.\(slot.rawValue).hour"
        }

        static func reminderMinute(_ slot: ReminderSlot) -> String {
            "reminderTime.\(slot.rawValue).minute"
        }
    }

    private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    @Published private var changeToken = 0
    private func bump() { changeToken += 1 }

    var hasCompletedOnboarding: Bool {
        get { defaults.bool(forKey: Key.hasCompletedOnboarding) }
        set { defaults.set(newValue, forKey: Key.hasCompletedOnboarding); bump() }
    }

    var scriptPreference: ScriptPreference {
        get {
            guard let raw = defaults.string(forKey: Key.scriptPreference),
                  let value = ScriptPreference(rawValue: raw) else { return .both }
            return value
        }
        set { defaults.set(newValue.rawValue, forKey: Key.scriptPreference); bump() }
    }

    /// The mode the user prefers to experience prayers in. Chant is the safe
    /// default because it remains meaningful without an approved recording.
    var preferredPrayerMode: PlayMode {
        get {
            guard let raw = defaults.string(forKey: Key.preferredPrayerMode),
                  let value = PlayMode(rawValue: raw) else { return .chant }
            return value
        }
        set { defaults.set(newValue.rawValue, forKey: Key.preferredPrayerMode); bump() }
    }

    var ishtaDevata: Deity? {
        get {
            guard let raw = defaults.string(forKey: Key.ishtaDevata) else { return nil }
            return Deity(rawValue: raw)
        }
        set {
            if let newValue {
                defaults.set(newValue.rawValue, forKey: Key.ishtaDevata)
            } else {
                defaults.removeObject(forKey: Key.ishtaDevata)
            }
            bump()
        }
    }

    var favoriteMoments: [Moment] {
        get {
            let raw = defaults.stringArray(forKey: Key.favoriteMoments) ?? []
            return raw.compactMap(Moment.init(rawValue:))
        }
        set {
            defaults.set(newValue.map(\.rawValue), forKey: Key.favoriteMoments)
            bump()
        }
    }

    var enabledReminders: Set<ReminderSlot> {
        get {
            let raw = defaults.stringArray(forKey: Key.enabledReminders) ?? []
            return Set(raw.compactMap(ReminderSlot.init(rawValue:)))
        }
        set {
            defaults.set(newValue.map(\.rawValue), forKey: Key.enabledReminders)
            bump()
        }
    }

    func reminderTime(for slot: ReminderSlot) -> ReminderTime {
        let hourKey = Key.reminderHour(slot)
        let minuteKey = Key.reminderMinute(slot)
        guard defaults.object(forKey: hourKey) != nil,
              defaults.object(forKey: minuteKey) != nil else {
            return slot.defaultTime
        }
        return ReminderTime(
            hour: defaults.integer(forKey: hourKey),
            minute: defaults.integer(forKey: minuteKey)
        )
    }

    func setReminderTime(_ time: ReminderTime, for slot: ReminderSlot) {
        defaults.set(time.hour, forKey: Key.reminderHour(slot))
        defaults.set(time.minute, forKey: Key.reminderMinute(slot))
        bump()
    }

    func toggleFavoriteMoment(_ moment: Moment) {
        var current = favoriteMoments
        if let index = current.firstIndex(of: moment) {
            current.remove(at: index)
        } else {
            current.append(moment)
        }
        favoriteMoments = current
    }
}
