import Foundation
import AVFoundation
import Combine

/// Drives a single prayer session: tracks elapsed time and progress, and plays
/// an approved bundled recording in Listen mode. If playback cannot begin,
/// Listen fails visibly and never becomes a pretend timed-text session.
@MainActor
final class PlayerController: ObservableObject {
    @Published private(set) var progress: Double = 0   // 0...1
    @Published private(set) var isRunning = false
    @Published private(set) var isFinished = false
    @Published private(set) var hasStarted = false
    @Published private(set) var elapsed: TimeInterval = 0
    /// True when Listen was requested but no audio could be loaded.
    @Published private(set) var audioUnavailable = false

    private let prayer: Prayer
    private let audioAssetResolver: PrayerAudioAssetResolver
    private var audioVariant: PrayerAudioVariant
    private var mode: PlayMode
    private var audioPlayer: AVAudioPlayer?
    private var timer: AnyCancellable?

    private var duration: TimeInterval { max(1, TimeInterval(prayer.durationSeconds)) }
    var remaining: TimeInterval { max(0, duration - elapsed) }

    init(
        prayer: Prayer,
        mode: PlayMode,
        audioAssetResolver: PrayerAudioAssetResolver = PrayerAudioAssetResolver(),
        audioVariant: PrayerAudioVariant = .traditional
    ) {
        self.prayer = prayer
        self.mode = mode
        self.audioAssetResolver = audioAssetResolver
        self.audioVariant = audioVariant
    }

    /// Change mode mid-session (resets progress).
    func setMode(_ newMode: PlayMode) {
        guard newMode != mode else { return }
        stop()
        mode = newMode
        reset()
    }

    func setAudioVariant(_ newVariant: PrayerAudioVariant) {
        guard newVariant != audioVariant else { return }
        stop()
        audioVariant = newVariant
        reset()
    }

    func reset() {
        progress = 0
        elapsed = 0
        isFinished = false
        hasStarted = false
        audioUnavailable = false
    }

    func start() {
        guard !isRunning else { return }
        if isFinished { reset() }

        if mode == .listen {
            guard prepareAudio(), audioPlayer?.play() == true else {
                isRunning = false
                audioUnavailable = true
                return
            }
        }

        hasStarted = true
        isRunning = true
        startTimer()
    }

    func pause() {
        isRunning = false
        audioPlayer?.pause()
        timer?.cancel()
        timer = nil
    }

    func stop() {
        pause()
        audioPlayer?.stop()
        audioPlayer = nil
    }

    /// Mark a self-led session complete after the user has explicitly begun.
    func completeNow() {
        guard hasStarted, !isFinished else { return }
        finish()
    }

    private func startTimer() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.tick()
            }
    }

    private func tick() {
        guard isRunning else { return }
        // Prefer real audio time when available; otherwise advance by wall time.
        if mode == .listen, let player = audioPlayer, player.duration > 0 {
            elapsed = player.currentTime
            progress = min(1, elapsed / player.duration)
            if !player.isPlaying && progress >= 0.99 { finish() }
        } else {
            elapsed += 0.1
            progress = min(1, elapsed / duration)
            // Chant and Silent are self-led practices. The target duration is
            // gentle pacing feedback, not permission to claim the person has
            // finished; completion is always an explicit action.
        }
    }

    private func finish() {
        progress = 1
        isRunning = false
        isFinished = true
        timer?.cancel()
        timer = nil
        audioPlayer?.stop()
    }

    /// Attempt to load the prayer's approved bundled audio. Returns false and
    /// flags `audioUnavailable` when playback cannot begin.
    private func prepareAudio() -> Bool {
        guard let url = audioAssetResolver.resolve(prayer: prayer, variant: audioVariant) else {
            audioUnavailable = true
            return false
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            audioPlayer = player
            audioUnavailable = false
            return true
        } catch {
            audioUnavailable = true
            return false
        }
    }
}
