import XCTest
@testable import Anjali

@MainActor
final class PlayerControllerTests: XCTestCase {
    func testSelfLedPrayerCannotCompleteBeforeBegin() {
        let controller = PlayerController(prayer: prayer(), mode: .silent)

        controller.completeNow()

        XCTAssertFalse(controller.hasStarted)
        XCTAssertFalse(controller.isFinished)
        XCTAssertEqual(controller.progress, 0)
    }

    func testChantStartsPausesAndCompletesOnlyExplicitly() {
        let controller = PlayerController(prayer: prayer(), mode: .chant)

        controller.start()
        XCTAssertTrue(controller.hasStarted)
        XCTAssertTrue(controller.isRunning)
        XCTAssertFalse(controller.isFinished)
        XCTAssertFalse(controller.audioUnavailable)

        controller.pause()
        XCTAssertTrue(controller.hasStarted)
        XCTAssertFalse(controller.isRunning)
        XCTAssertFalse(controller.isFinished)

        controller.completeNow()
        XCTAssertTrue(controller.isFinished)
        XCTAssertFalse(controller.isRunning)
        XCTAssertEqual(controller.progress, 1)
    }

    func testSilentDoesNotPretendAudioIsRequired() {
        let controller = PlayerController(prayer: prayer(), mode: .silent)

        controller.start()

        XCTAssertTrue(controller.isRunning)
        XCTAssertTrue(controller.hasStarted)
        XCTAssertFalse(controller.audioUnavailable)
        controller.stop()
    }

    func testMissingListenAssetFailsWithoutStartingPretendTimer() {
        let root = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString, isDirectory: true)
        let resolver = PrayerAudioAssetResolver(
            resourceRoot: root,
            policy: .debugPreview
        )
        let controller = PlayerController(
            prayer: prayer(),
            mode: .listen,
            audioAssetResolver: resolver
        )

        controller.start()

        XCTAssertTrue(controller.audioUnavailable)
        XCTAssertFalse(controller.hasStarted)
        XCTAssertFalse(controller.isRunning)
        XCTAssertFalse(controller.isFinished)
        XCTAssertEqual(controller.progress, 0)
    }

    func testChangingModeResetsSessionState() {
        let controller = PlayerController(prayer: prayer(), mode: .chant)
        controller.start()
        controller.pause()

        controller.setMode(.silent)

        XCTAssertFalse(controller.hasStarted)
        XCTAssertFalse(controller.isRunning)
        XCTAssertFalse(controller.isFinished)
        XCTAssertFalse(controller.audioUnavailable)
        XCTAssertEqual(controller.progress, 0)
    }

    private func prayer() -> Prayer {
        Prayer(
            id: "test-prayer",
            title: "Test prayer",
            deity: nil,
            moments: [.dawn],
            intentions: [.peace],
            timeContexts: [.dawn],
            durationSeconds: 20,
            availableModes: [.listen, .chant, .silent],
            primaryText: PrayerText(devanagari: "ॐ"),
            transliteration: "Oṃ",
            meaning: "Meaning",
            sourceTitle: "Source",
            audioAssetName: nil,
            isReviewed: true,
            needsReview: false,
            isFeatured: false,
            sortOrder: 0,
            rotationPolicy: .rotateOften
        )
    }
}
