import XCTest

/// End-to-end coverage for the "full loop" the project docs call out as
/// unverified since audio + icon landed: first-run onboarding, reaching
/// Today, starting a prayer, and reaching the completion state.
///
/// This is deliberately the *only* UI test target/file today — it exists to
/// close the "zero UI tests" gap, not to be a full regression suite. Keep
/// additions here scoped to the primary user journey; deeper feature
/// coverage belongs in `AnjaliTests` (the deterministic-engine unit tests)
/// wherever it's feasible without driving the simulator.
final class AnjaliFullLoopUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    /// Launch → onboarding (first run, guaranteed by `-uiTestReset` wiping
    /// any persisted state from a prior run on this simulator) → Today →
    /// start a prayer in Silent mode (deterministic; no audio hardware/timing
    /// dependency) → tap "Complete" → land on the completion screen.
    func testFullLoop_onboardingThroughCompletion() throws {
        let app = XCUIApplication()
        // See `AnjaliApp.resetStateIfRequestedForUITesting()`: this wipes the
        // persisted UserDefaults domain at launch, rather than overriding a
        // single key via `-key value` (which would fight with the app's own
        // write of `hasCompletedOnboarding = true` when onboarding finishes).
        app.launchArguments = ["-uiTestReset"]
        app.launch()

        // MARK: Onboarding — screen 1 (welcome)
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 10), "Onboarding welcome screen did not appear")
        continueButton.tap()

        // MARK: Onboarding — screen 2 (preferences) → Enter
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 10), "Onboarding preferences screen did not appear")
        enterButton.tap()

        // MARK: Today
        // "Begin in silent mode" is the accessibility label on the card's
        // Silent action (PrayerCardView). Silent mode is guaranteed playable
        // for every prayer (Prayer.playableModes always includes .silent),
        // so this is present regardless of which prayer Today selects.
        let silentButton = app.buttons["Begin in silent mode"]
        XCTAssertTrue(silentButton.waitForExistence(timeout: 15), "Today screen did not surface a prayer")
        silentButton.tap()

        // MARK: Prayer player (Silent layout)
        let completeButton = app.buttons["Complete prayer"]
        XCTAssertTrue(completeButton.waitForExistence(timeout: 10), "Silent player did not appear")
        completeButton.tap()

        // MARK: Completion state
        let doneButton = app.buttons["Done"]
        XCTAssertTrue(doneButton.waitForExistence(timeout: 10), "Completion screen did not appear")
        XCTAssertTrue(app.staticTexts["May this action be steady."].exists)

        // Close back out to Today, confirming the loop returns cleanly.
        doneButton.tap()
        XCTAssertTrue(silentButton.waitForExistence(timeout: 10), "Did not return to Today after completion")
    }

    /// Covers the 2 of 22 prayers that ship with no bundled audio
    /// (`vishnu-shantakaram` / "Shantakaram Bhujagashayanam" and
    /// `hanuman-manojavam` / "Manojavam Marutatulyavegam" — see
    /// `Anjali/Resources/prayers.json`, `audioAssetName: null`). Both still
    /// list "listen" as an available mode, so opening either one in its
    /// default (Listen) mode is the real-world path a user hits.
    ///
    /// `PlayerController.prepareAudio()` is expected to fail closed: no
    /// asset found → `audioUnavailable = true` → the timer still drives
    /// progress from wall-clock time instead of audio playback time, and the
    /// UI surfaces "Audio isn't available — follow along in silence."
    /// instead of crashing or hanging. This test drives the real bundled
    /// prayer content (not a fixture) through Moments → Deity → Vishnu to
    /// confirm that on a real device/simulator, not just by reading the code.
    func testMissingAudioPrayerFallsBackGracefully() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()

        // Fast-path through onboarding.
        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 10))
        continueButton.tap()
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 10))
        enterButton.tap()

        // Today → Moments tab.
        let momentsTab = app.buttons["Moments"]
        XCTAssertTrue(momentsTab.waitForExistence(timeout: 15))
        momentsTab.tap()

        // Switch the browse picker from "Moment" to "Deity", then drill into
        // Vishnu, whose catalog includes the audio-less Shantakaram prayer.
        let deitySegment = app.buttons["Deity"]
        XCTAssertTrue(deitySegment.waitForExistence(timeout: 10))
        deitySegment.tap()

        let vishnuRow = app.buttons["Vishnu"]
        XCTAssertTrue(vishnuRow.waitForExistence(timeout: 10))
        vishnuRow.tap()

        let shantakaramPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Shantakaram")
        let shantakaramRow = app.buttons.containing(shantakaramPredicate).firstMatch
        XCTAssertTrue(shantakaramRow.waitForExistence(timeout: 10), "Shantakaram prayer row not found under Vishnu")
        shantakaramRow.tap()

        // Opens in Listen mode by default (Prayer.playableModes.first for
        // this prayer's availableModes ["listen", "chant", "silent"]).
        // Starting playback should hit the no-audio path immediately.
        let beginButton = app.buttons["Begin prayer"]
        XCTAssertTrue(beginButton.waitForExistence(timeout: 10), "Prayer player did not appear")
        beginButton.tap()

        // Graceful degradation: an explicit, non-crashing fallback message,
        // and the timer keeps running (Begin flips to Pause) driven by
        // wall-clock time rather than a (nonexistent) audio track.
        XCTAssertTrue(
            app.staticTexts["Audio isn't available — follow along in silence."].waitForExistence(timeout: 5),
            "Missing-audio fallback message did not appear — Listen mode may be failing open instead of degrading"
        )
        let pauseButton = app.buttons["Pause"]
        XCTAssertTrue(pauseButton.waitForExistence(timeout: 5), "Playback did not start despite missing audio")
    }
}
