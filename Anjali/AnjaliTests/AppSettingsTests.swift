import XCTest
@testable import Anjali

@MainActor
final class AppSettingsTests: XCTestCase {
    private var suiteName: String!
    private var defaults: UserDefaults!

    override func setUp() {
        super.setUp()
        suiteName = "AppSettingsTests.\(UUID().uuidString)"
        defaults = UserDefaults(suiteName: suiteName)
    }

    override func tearDown() {
        defaults.removePersistentDomain(forName: suiteName)
        defaults = nil
        suiteName = nil
        super.tearDown()
    }

    func testPreferencesSurviveSettingsRecreation() {
        let first = AppSettings(defaults: defaults)
        first.hasCompletedOnboarding = true
        first.scriptPreference = .devanagari
        first.preferredPrayerMode = .silent
        first.ishtaDevata = .ganesha
        first.favoriteMoments = [.dawn, .sleep]
        first.enabledReminders = [.dawn, .sunset]
        first.setReminderTime(ReminderTime(hour: 7, minute: 15), for: .dawn)

        let relaunched = AppSettings(defaults: defaults)
        XCTAssertTrue(relaunched.hasCompletedOnboarding)
        XCTAssertEqual(relaunched.scriptPreference, .devanagari)
        XCTAssertEqual(relaunched.preferredPrayerMode, .silent)
        XCTAssertEqual(relaunched.ishtaDevata, .ganesha)
        XCTAssertEqual(Set(relaunched.favoriteMoments), [.dawn, .sleep])
        XCTAssertEqual(relaunched.enabledReminders, [.dawn, .sunset])
        XCTAssertEqual(relaunched.reminderTime(for: .dawn), ReminderTime(hour: 7, minute: 15))
        XCTAssertEqual(relaunched.reminderTime(for: .sleep), .init(hour: 21, minute: 30))
    }

    func testInvalidStoredValuesFallBackSafely() {
        defaults.set("unknown-script", forKey: AppSettings.Key.scriptPreference)
        defaults.set("unknown-mode", forKey: AppSettings.Key.preferredPrayerMode)
        defaults.set("unknown-deity", forKey: AppSettings.Key.ishtaDevata)

        let settings = AppSettings(defaults: defaults)
        XCTAssertEqual(settings.scriptPreference, .both)
        XCTAssertEqual(settings.preferredPrayerMode, .chant)
        XCTAssertNil(settings.ishtaDevata)
    }
}
