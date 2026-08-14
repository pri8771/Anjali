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
        // The debug-only UI-test hook wipes UserDefaults and SwiftData rather
        // than overriding a single preference via `-key value`.
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
        let beginSilentButton = app.buttons["Begin silent prayer"]
        XCTAssertTrue(beginSilentButton.waitForExistence(timeout: 10), "Silent player did not appear")
        beginSilentButton.tap()

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

    /// Reproduces the reported Om Namo Narayanaya path. With no approved human
    /// recording in the bundle, the player must not promise Listen or open a
    /// blank pseudo-audio session. It must show both prayer scripts, explain
    /// self-led Chant, and provide visible running feedback.
    func testTextOnlyPrayerOffersClearSelfLedChant() throws {
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

        // Today → Find tab.
        // iPadOS floating tab bars expose a nested duplicate accessibility
        // node for each item; firstMatch is stable on both iPhone and iPad.
        let findTab = app.buttons["Find"].firstMatch
        XCTAssertTrue(findTab.waitForExistence(timeout: 15))
        findTab.tap()

        // Switch the browse picker from "Moment" to "Deity", then drill into
        // Vishnu and choose the prayer from the user's report.
        let deitySegment = app.buttons["Deity"]
        XCTAssertTrue(deitySegment.waitForExistence(timeout: 10))
        deitySegment.tap()

        let vishnuRow = app.buttons["Vishnu"]
        XCTAssertTrue(vishnuRow.waitForExistence(timeout: 10))
        vishnuRow.tap()

        let narayanaPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Om Namo Narayanaya")
        let narayanaRow = app.buttons.containing(narayanaPredicate).firstMatch
        XCTAssertTrue(narayanaRow.waitForExistence(timeout: 10), "Om Namo Narayanaya was not found under Vishnu")
        narayanaRow.tap()

        XCTAssertTrue(app.buttons["Chant mode"].waitForExistence(timeout: 10))
        XCTAssertFalse(app.buttons["Listen mode"].exists, "Listen must not appear without exact approved audio")
        XCTAssertTrue(app.staticTexts["ॐ नमो नारायणाय"].exists, "Devanagari prayer text is missing")
        XCTAssertTrue(app.staticTexts["Oṃ Namo Nārāyaṇāya"].exists, "Transliteration is missing")
        XCTAssertTrue(
            app.staticTexts["Recite aloud at your own pace. No recording plays in this mode."].exists,
            "Chant mode does not explain its no-audio behavior"
        )

        let beginButton = app.buttons["Begin chanting"]
        XCTAssertTrue(beginButton.waitForExistence(timeout: 10), "Chant control did not appear")
        beginButton.tap()
        XCTAssertTrue(
            app.buttons["Complete prayer"].waitForExistence(timeout: 5),
            "A started chant must offer explicit completion instead of pause"
        )
    }

    /// A saved prayer must survive process termination and relaunch. The first
    /// launch resets both UserDefaults and SwiftData; the second intentionally
    /// does not, so this exercises the production persistence path.
    func testSavedPrayerPersistsAcrossRelaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()

        app.buttons["Continue"].tap()
        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 10))
        enterButton.tap()

        let findTab = app.buttons["Find"].firstMatch
        XCTAssertTrue(findTab.waitForExistence(timeout: 15))
        findTab.tap()
        app.buttons["Deity"].tap()
        let vishnuRow = app.buttons["Vishnu"]
        XCTAssertTrue(vishnuRow.waitForExistence(timeout: 10))
        vishnuRow.tap()

        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "Shantakaram")
        let prayerRow = app.buttons.containing(predicate).firstMatch
        XCTAssertTrue(prayerRow.waitForExistence(timeout: 10))
        prayerRow.tap()

        let silentMode = app.buttons["Silent mode"]
        XCTAssertTrue(silentMode.waitForExistence(timeout: 10))
        silentMode.tap()
        let beginSilentButton = app.buttons["Begin silent prayer"]
        XCTAssertTrue(beginSilentButton.waitForExistence(timeout: 10))
        beginSilentButton.tap()
        let completeButton = app.buttons["Complete prayer"]
        XCTAssertTrue(completeButton.waitForExistence(timeout: 10))
        completeButton.tap()

        let saveButton = app.buttons["Save this prayer"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 10))
        saveButton.tap()

        let meTab = app.buttons["Me"].firstMatch
        XCTAssertTrue(meTab.waitForExistence(timeout: 10))
        meTab.tap()
        let savedPrayer = app.descendants(matching: .any)["savedPrayer.vishnu-shantakaram"]
        XCTAssertTrue(
            reveal(savedPrayer, in: app),
            "Saved prayer was not present after a successful save"
        )

        app.terminate()
        app.launchArguments = []
        app.launch()
        let relaunchedMeTab = app.buttons["Me"].firstMatch
        XCTAssertTrue(relaunchedMeTab.waitForExistence(timeout: 10))
        relaunchedMeTab.tap()
        XCTAssertTrue(
            reveal(
                app.descendants(matching: .any)["savedPrayer.vishnu-shantakaram"],
                in: app
            ),
            "Saved prayer did not survive relaunch"
        )
    }

    /// Ensures the primary first-run path remains reachable at the largest
    /// accessibility text size instead of clipping its actions off-screen.
    func testPrimaryPathAtLargestAccessibilityText() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "-uiTestReset",
            "-UIPreferredContentSizeCategoryName",
            "UICTContentSizeCategoryAccessibilityExtraExtraExtraLarge"
        ]
        app.launch()

        let continueButton = app.buttons["Continue"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 10))
        continueButton.tap()

        let enterButton = app.buttons["Enter"]
        XCTAssertTrue(enterButton.waitForExistence(timeout: 10))
        enterButton.tap()

        XCTAssertTrue(
            app.buttons["Begin in silent mode"].waitForExistence(timeout: 15),
            "Today action was not reachable at the largest accessibility text size"
        )
    }

    private func reveal(_ element: XCUIElement, in app: XCUIApplication) -> Bool {
        for _ in 0..<6 {
            if element.waitForExistence(timeout: 1) {
                return true
            }
            app.swipeUp()
        }
        return element.exists
    }
}
