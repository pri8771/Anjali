import Foundation

/// Controls whether repository-only preview audio may be resolved.
enum PrayerAudioAssetPolicy: Equatable {
    case debugPreview
    case release

    static var currentBuild: Self {
        // DEBUG alone must never expose unapproved sacred audio. Engineers
        // may opt into an isolated QA scheme with this explicit condition;
        // normal Debug, device, Release, and TestFlight builds use the
        // approved-catalog policy.
        #if DEBUG && ENABLE_UNAPPROVED_AUDIO_PREVIEW
        return .debugPreview
        #else
        return .release
        #endif
    }
}

enum PrayerAudioVariant: String, CaseIterable, Identifiable {
    case traditional
    case energy
    case deep

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .traditional: return "Traditional"
        case .energy: return "EDM"
        case .deep: return "Hip-Hop"
        }
    }

    fileprivate var fileSuffix: String {
        switch self {
        case .traditional: return "v01-traditional"
        case .energy: return "v02-energy-edm"
        case .deep: return "v03-deep-indian-hip-hop"
        }
    }
}

/// Resolves a prayer's audio without aliases, recursive searches, or
/// cross-prayer fallbacks. A valid asset basename always equals `Prayer.id`.
struct PrayerAudioAssetResolver {
    private static let supportedExtensions = ["m4a", "mp3", "caf", "wav", "aac"]

    private let resourceRoot: URL?
    private let policy: PrayerAudioAssetPolicy
    private let fileManager: FileManager

    init(
        resourceRoot: URL? = Bundle.main.resourceURL,
        policy: PrayerAudioAssetPolicy = .currentBuild,
        fileManager: FileManager = .default
    ) {
        self.resourceRoot = resourceRoot
        self.policy = policy
        self.fileManager = fileManager
    }

    func resolve(prayer: Prayer) -> URL? {
        resolve(prayer: prayer, variant: .traditional)
    }

    func resolve(prayer: Prayer, variant: PrayerAudioVariant) -> URL? {
        guard let resourceRoot else { return nil }

        let assetName: String
        switch policy {
        case .debugPreview:
            assetName = prayer.audioAssetName ?? prayer.id
        case .release:
            guard let catalogName = prayer.audioAssetName else { return nil }
            assetName = catalogName
        }

        // Catalog aliases and names containing extensions are intentionally
        // rejected. The displayed prayer and the recording must share an ID.
        guard assetName == prayer.id else { return nil }

        // PilotAudio is a deliberate, self-contained TestFlight candidate set.
        // Audio keeps supporting injected unit-test fixtures and future approved
        // recordings. Searching both locations still fails closed if an ID is
        // duplicated, so a stale fixture can never silently win.
        // Xcode's synchronized resource folder is flattened in the final
        // `.app`, while injected tests retain their Audio directory. Check the
        // packaged root first, then the source-style locations; candidates are
        // still counted together and duplicates fail closed.
        let audioDirectories = [
            resourceRoot,
            resourceRoot.appendingPathComponent("PilotAudio", isDirectory: true),
            resourceRoot.appendingPathComponent("Audio", isDirectory: true)
        ]

        let variantCandidates = variantFileCandidates(
            prayerID: prayer.id,
            variant: variant,
            audioDirectories: audioDirectories
        )
        if variantCandidates.count == 1, let candidate = variantCandidates.first {
            return candidate
        }
        guard variant == .traditional else { return nil }

        let candidates = exactFileCandidates(prayerID: prayer.id, audioDirectories: audioDirectories)

        // Ambiguous duplicate formats fail closed instead of depending on
        // extension ordering.
        guard candidates.count == 1, let candidate = candidates.first else { return nil }

        // The baseline pilot primarily uses AAC/M4A. Suno variant exports are
        // retained as MP3 for this bounded pilot; public-release review must
        // replace them with approved M4A human recordings.
        if policy == .release,
           !["m4a", "mp3"].contains(candidate.pathExtension.lowercased()) {
            return nil
        }
        return candidate
    }

    func availableVariants(for prayer: Prayer) -> [PrayerAudioVariant] {
        PrayerAudioVariant.allCases.filter { resolve(prayer: prayer, variant: $0) != nil }
    }

    private func variantFileCandidates(
        prayerID: String,
        variant: PrayerAudioVariant,
        audioDirectories: [URL]
    ) -> [URL] {
        audioDirectories.flatMap { directory in
            let url = directory
                .appendingPathComponent("\(prayerID)__\(variant.fileSuffix)")
                .appendingPathExtension("mp3")
            var isDirectory: ObjCBool = false
            guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory),
                  !isDirectory.boolValue else { return [URL]() }
            return [url]
        }
    }

    private func exactFileCandidates(prayerID: String, audioDirectories: [URL]) -> [URL] {
        audioDirectories.flatMap { audioDirectory in
            Self.supportedExtensions.compactMap { fileExtension -> URL? in
                let url = audioDirectory
                    .appendingPathComponent(prayerID)
                    .appendingPathExtension(fileExtension)
                var isDirectory: ObjCBool = false
                guard fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory),
                      !isDirectory.boolValue else { return nil }
                return url
            }
        }
    }
}
