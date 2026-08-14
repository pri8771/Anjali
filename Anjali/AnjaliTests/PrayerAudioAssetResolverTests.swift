import XCTest
@testable import Anjali

final class PrayerAudioAssetResolverTests: XCTestCase {
    private var resourceRoot: URL!

    override func setUpWithError() throws {
        resourceRoot = FileManager.default.temporaryDirectory
            .appendingPathComponent("PrayerAudioAssetResolverTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(
            at: resourceRoot.appendingPathComponent("Audio", isDirectory: true),
            withIntermediateDirectories: true
        )
        try FileManager.default.createDirectory(
            at: resourceRoot.appendingPathComponent("PilotAudio", isDirectory: true),
            withIntermediateDirectories: true
        )
    }

    override func tearDownWithError() throws {
        if let resourceRoot {
            try? FileManager.default.removeItem(at: resourceRoot)
        }
        resourceRoot = nil
    }

    func testDebugPreviewResolvesExactPrayerIDWhenCatalogAudioIsNull() throws {
        try addAudio(id: "ganesha-gam", fileExtension: "mp3")
        let url = resolver(policy: .debugPreview).resolve(
            prayer: prayer(id: "ganesha-gam", audioAssetName: nil)
        )

        XCTAssertEqual(url?.lastPathComponent, "ganesha-gam.mp3")
    }

    func testReleaseDoesNotResolveNullCatalogPreviewAudio() throws {
        try addAudio(id: "ganesha-gam", fileExtension: "m4a")
        let url = resolver(policy: .release).resolve(
            prayer: prayer(id: "ganesha-gam", audioAssetName: nil)
        )

        XCTAssertNil(url)
    }

    func testReleaseResolvesOnlyExactCatalogIDInApprovedFormat() throws {
        try addAudio(id: "ganesha-gam", fileExtension: "m4a")
        let exactURL = resolver(policy: .release).resolve(
            prayer: prayer(id: "ganesha-gam", audioAssetName: "ganesha-gam")
        )
        let aliasedURL = resolver(policy: .release).resolve(
            prayer: prayer(id: "ganesha-gam", audioAssetName: "ganesha-shri")
        )

        XCTAssertEqual(exactURL?.lastPathComponent, "ganesha-gam.m4a")
        XCTAssertNil(aliasedURL)
    }

    func testReleaseAllowsDocumentedPilotMP3Audio() throws {
        try addAudio(id: "ganesha-gam", fileExtension: "mp3")
        let url = resolver(policy: .release).resolve(
            prayer: prayer(id: "ganesha-gam", audioAssetName: "ganesha-gam")
        )

        XCTAssertEqual(url?.lastPathComponent, "ganesha-gam.mp3")
    }

    func testPilotVariantsResolveWithoutReplacingTheExactPrayerAsset() throws {
        try addVariant(id: "ganesha-gam", variant: .traditional)
        try addVariant(id: "ganesha-gam", variant: .energy)

        let prayer = prayer(id: "ganesha-gam", audioAssetName: "ganesha-gam")
        let resolver = resolver(policy: .release)

        XCTAssertEqual(
            resolver.availableVariants(for: prayer),
            [.traditional, .energy]
        )
        XCTAssertEqual(
            resolver.resolve(prayer: prayer, variant: .energy)?.lastPathComponent,
            "ganesha-gam__v02-energy-edm.mp3"
        )
    }

    func testVishnuPrayerNeverFallsBackToDifferentVishnuRecording() throws {
        try addAudio(id: "vishnu-narayana", fileExtension: "mp3")
        let url = resolver(policy: .debugPreview).resolve(
            prayer: prayer(id: "vishnu-shantakaram", audioAssetName: nil)
        )

        XCTAssertNil(url)
    }

    func testHanumanPrayerNeverFallsBackToDifferentHanumanRecording() throws {
        try addAudio(id: "hanuman-namah", fileExtension: "m4a")
        let url = resolver(policy: .debugPreview).resolve(
            prayer: prayer(id: "hanuman-manojavam", audioAssetName: nil)
        )

        XCTAssertNil(url)
    }

    func testMissingExactAssetFailsClosed() {
        let url = resolver(policy: .debugPreview).resolve(
            prayer: prayer(id: "shanti-triple", audioAssetName: nil)
        )

        XCTAssertNil(url)
    }

    func testDuplicateExtensionsFailClosed() throws {
        try addAudio(id: "ganesha-gam", fileExtension: "m4a")
        try addAudio(id: "ganesha-gam", fileExtension: "mp3")
        let url = resolver(policy: .debugPreview).resolve(
            prayer: prayer(id: "ganesha-gam", audioAssetName: nil)
        )

        XCTAssertNil(url)
    }

    func testPackagedRootMatchResolvesButNestedMatchDoesNot() throws {
        let nested = resourceRoot
            .appendingPathComponent("Other", isDirectory: true)
            .appendingPathComponent("Nested", isDirectory: true)
        try FileManager.default.createDirectory(at: nested, withIntermediateDirectories: true)
        try Data().write(to: nested.appendingPathComponent("ganesha-gam.mp3"))
        try Data().write(to: resourceRoot.appendingPathComponent("ganesha-gam.m4a"))

        let url = resolver(policy: .release).resolve(
            prayer: prayer(id: "ganesha-gam", audioAssetName: "ganesha-gam")
        )

        XCTAssertEqual(url?.lastPathComponent, "ganesha-gam.m4a")
    }

    private func resolver(policy: PrayerAudioAssetPolicy) -> PrayerAudioAssetResolver {
        PrayerAudioAssetResolver(resourceRoot: resourceRoot, policy: policy)
    }

    private func addAudio(id: String, fileExtension: String) throws {
        let url = resourceRoot
            .appendingPathComponent("Audio", isDirectory: true)
            .appendingPathComponent(id)
            .appendingPathExtension(fileExtension)
        try Data([0]).write(to: url)
    }

    private func addVariant(id: String, variant: PrayerAudioVariant) throws {
        let suffix: String
        switch variant {
        case .traditional: suffix = "v01-traditional"
        case .energy: suffix = "v02-energy-edm"
        case .deep: suffix = "v03-deep-indian-hip-hop"
        }
        let url = resourceRoot
            .appendingPathComponent("PilotAudio", isDirectory: true)
            .appendingPathComponent("\(id)__\(suffix).mp3")
        try Data([0]).write(to: url)
    }

    private func prayer(id: String, audioAssetName: String?) -> Prayer {
        Prayer(
            id: id,
            title: id,
            deity: nil,
            moments: [.dawn],
            intentions: [.peace],
            timeContexts: [.dawn],
            durationSeconds: 15,
            availableModes: [.listen, .chant, .silent],
            primaryText: PrayerText(devanagari: "ॐ"),
            transliteration: "Oṃ",
            meaning: "Meaning",
            sourceTitle: "Source",
            audioAssetName: audioAssetName,
            isReviewed: true,
            needsReview: false,
            isFeatured: false,
            sortOrder: 0,
            rotationPolicy: .rotateOften
        )
    }
}
