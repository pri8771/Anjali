import SwiftUI
import SwiftData

/// Full-screen prayer player with one stable layout for Listen, self-led
/// Chant, and inward Silent practice. Records an explicit completion locally.
struct PrayerPlayerView: View {
    let prayer: Prayer
    /// When set, the player opens preselected to this mode (Today card's quiet
    /// shortcut). The user can still switch modes inside the player.
    let forcedMode: PlayMode?

    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var persistenceHealth: PersistenceHealth
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @StateObject private var controller: PlayerController
    @State private var mode: PlayMode
    @State private var audioVariant: PrayerAudioVariant
    @State private var showCompletion = false
    @State private var persistenceErrorMessage: String?
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    private let playerModes: [PlayMode]

    // Today's theme drives the player background too.
    private let theme = ThemePalette.palette(for: TimeBandResolver.timeContext(for: Date()))

    init(prayer: Prayer, forcedMode: PlayMode? = nil) {
        self.prayer = prayer
        self.forcedMode = forcedMode
        let audioResolver = PrayerAudioAssetResolver()
        let audioVariants = audioResolver.availableVariants(for: prayer)
        let initialAudioVariant = audioVariants.contains(.traditional)
            ? .traditional
            : audioVariants.first ?? .traditional
        let audioAvailable = !audioVariants.isEmpty
        let playerModes = prayer.playableModes(audioAvailable: audioAvailable)
        _audioVariant = State(initialValue: initialAudioVariant)
        self.playerModes = playerModes
        let initialMode = forcedMode ?? playerModes.first ?? .silent
        _mode = State(initialValue: initialMode)
        _controller = StateObject(wrappedValue: PlayerController(
            prayer: prayer,
            mode: initialMode,
            audioAssetResolver: audioResolver,
            audioVariant: initialAudioVariant
        ))
    }

    var body: some View {
        ZStack {
            theme.backgroundGradient.ignoresSafeArea()
            playerContent
        }
        .preferredColorScheme(theme.prefersDarkForeground ? .light : .dark)
        .onAppear {
            applyInitialMode()
        }
        .onChange(of: controller.isFinished) { _, finished in
            if finished {
                recordCompletion()
                if reduceMotion { showCompletion = true }
                else { withAnimation { showCompletion = true } }
            }
        }
        .onDisappear { controller.stop() }
        .overlay {
            if showCompletion {
                CompletionView(
                    prayer: prayer,
                    theme: theme,
                    onDone: finishAndClose,
                    onRepeat: repeatPrayer,
                    onSave: savePrayer
                )
                .transition(.opacity)
            }
        }
        .alert(
            "Changes weren't saved",
            isPresented: Binding(
                get: { persistenceErrorMessage != nil },
                set: { if !$0 { persistenceErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(persistenceErrorMessage ?? "")
        }
    }

    // MARK: Player

    private var playerContent: some View {
        VStack(spacing: 0) {
            topBar

            modePicker.padding(.top, 12)

            if mode == .listen && audioVariants.count > 1 {
                audioVariantPicker.padding(.top, 10)
            }

            modeGuidance
                .padding(.top, 12)

            if mode == .listen {
                experimentalAudioDisclosure
                    .padding(.top, 10)
            }

            ScrollView {
                VStack(spacing: 18) {
                    Text(prayer.title)
                        .font(.system(.title2, design: .serif, weight: .semibold))
                        .foregroundStyle(theme.foreground)

                    Text("PRAYER TEXT")
                        .font(.caption2.weight(.semibold))
                        .tracking(1.4)
                        .foregroundStyle(theme.accent)

                    PrayerTextView(
                        prayer: prayer,
                        scriptPreference: settings.scriptPreference,
                        theme: theme,
                        primaryStyle: .largeTitle
                    )

                    VStack(spacing: 6) {
                        Text("MEANING")
                            .font(.caption2.weight(.semibold))
                            .tracking(1.4)
                            .foregroundStyle(theme.accent)
                        Text(prayer.meaning)
                            .font(.body)
                            .foregroundStyle(theme.secondaryForeground)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 18)
            }

            progressView
                .padding(.bottom, 8)

            Text(statusText)
                .font(.caption)
                .foregroundStyle(
                    controller.audioUnavailable ? Color.red : theme.secondaryForeground
                )
                .multilineTextAlignment(.center)
                .frame(minHeight: 34)
                .padding(.horizontal)

            VStack(spacing: 10) {
                controls

                if mode != .listen {
                    Button {
                        controller.completeNow()
                    } label: {
                        Text("Complete").frame(maxWidth: .infinity)
                    }
                    .silentCompleteStyle(theme: theme)
                    .accessibilityLabel("Complete prayer")
                    .accessibilityHint(
                        controller.hasStarted
                            ? "Finish this prayer and show completion options"
                            : "Begin the prayer before marking it complete"
                    )
                    .disabled(!controller.hasStarted)
                    .opacity(controller.hasStarted ? 1 : 0.45)
                }
            }
            .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
    }

    private var modeGuidance: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: mode.symbolName)
                .foregroundStyle(theme.accent)
                .accessibilityHidden(true)
            Text(mode.guidance)
                .font(.subheadline)
                .foregroundStyle(theme.foreground)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(theme.foreground.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(mode.displayName) mode. \(mode.guidance)")
    }

    private var experimentalAudioDisclosure: some View {
        Text("TestFlight pilot: Listen uses experimental generated audio. The displayed text, transliteration, and meaning are the source of truth.")
            .font(.caption)
            .foregroundStyle(theme.secondaryForeground)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(10)
            .background(theme.foreground.opacity(0.06))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .accessibilityLabel("TestFlight pilot notice. Listen uses experimental generated audio. Follow the displayed prayer text as the source of truth.")
    }

    @ViewBuilder
    private var progressView: some View {
        if mode == .silent {
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(theme.foreground.opacity(0.15))
                    Capsule()
                        .fill(theme.accent)
                        .frame(width: geo.size.width * controller.progress)
                }
            }
            .frame(height: 5)
            .padding(.vertical, 12)
            .accessibilityElement()
            .accessibilityLabel(progressAccessibilityLabel)
        } else {
            FlameProgressView(progress: controller.progress, theme: theme)
                .frame(width: 92, height: 92)
                .accessibilityLabel(progressAccessibilityLabel)
        }
    }

    // MARK: Shared subviews

    private var topBar: some View {
        HStack {
            Button {
                controller.stop()
                coordinator.dismissPlayer()
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline)
                    .foregroundStyle(theme.foreground)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .accessibilityLabel("Close")
            Spacer()
            InfoChip(text: prayer.durationLabel, systemImage: "clock", tint: theme.accent)
                .accessibilityLabel("Duration: \(prayer.accessibleDuration)")
        }
        .padding(.top, 12)
    }

    private var modePicker: some View {
        HStack(spacing: 10) {
            ForEach(playerModes) { available in
                // ModeChip carries its own VoiceOver label + button/selected traits.
                ModeChip(mode: available, isSelected: available == mode, theme: theme) {
                    mode = available
                    controller.setMode(available)
                }
            }
        }
    }

    private var audioVariants: [PrayerAudioVariant] {
        PrayerAudioAssetResolver().availableVariants(for: prayer)
    }

    private var audioVariantPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(audioVariants) { variant in
                    Button {
                        audioVariant = variant
                        controller.setAudioVariant(variant)
                    } label: {
                        Text(variant.displayName)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(
                                audioVariant == variant ? theme.background : theme.foreground
                            )
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                audioVariant == variant ? theme.accent : theme.foreground.opacity(0.08)
                            )
                            .clipShape(Capsule())
                    }
                    .accessibilityLabel("Listen style: \(variant.displayName)")
                    .accessibilityAddTraits(audioVariant == variant ? .isSelected : [])
                }
            }
            .frame(maxWidth: .infinity)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Listen style")
    }

    private var controls: some View {
        Button {
            if controller.isRunning {
                controller.pause()
            } else {
                controller.start()
            }
        } label: {
            HStack {
                Image(systemName: controller.isRunning ? "pause.fill" : "flame.fill")
                Text(controlTitle)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(AnjaliPrimaryButtonStyle(theme: theme))
        .accessibilityLabel(controlTitle)
    }

    private var controlTitle: String {
        if controller.isRunning {
            switch mode {
            case .listen: return "Pause listening"
            case .chant: return "Pause chanting"
            case .silent: return "Pause silent prayer"
            }
        }
        if controller.hasStarted {
            switch mode {
            case .listen: return "Resume listening"
            case .chant: return "Continue chanting"
            case .silent: return "Continue silent prayer"
            }
        }
        switch mode {
        case .listen: return "Play recitation"
        case .chant: return "Begin chanting"
        case .silent: return "Begin silent prayer"
        }
    }

    private var statusText: String {
        if controller.audioUnavailable {
            return "The recording couldn’t start. Choose Chant or Silent to continue."
        }
        if controller.isFinished {
            return "Prayer complete"
        }
        if !controller.hasStarted {
            return "Ready · \(prayer.accessibleDuration)"
        }
        let time = formattedTime(controller.remaining)
        if controller.isRunning {
            switch mode {
            case .listen: return "Playing · \(time) remaining"
            case .chant:
                return controller.remaining > 0
                    ? "Chanting · \(time) suggested time remaining"
                    : "Continue at your own pace · Complete when ready"
            case .silent:
                return controller.remaining > 0
                    ? "Silent prayer · \(time) suggested time remaining"
                    : "Continue at your own pace · Complete when ready"
            }
        }
        if controller.remaining <= 0 {
            return "Paused · Continue at your own pace"
        }
        return "Paused · \(time) remaining"
    }

    private var progressAccessibilityLabel: String {
        "Prayer progress, \(Int((controller.progress * 100).rounded())) percent complete"
    }

    private func formattedTime(_ interval: TimeInterval) -> String {
        let seconds = max(0, Int(interval.rounded(.up)))
        return String(format: "%d:%02d", seconds / 60, seconds % 60)
    }

    // MARK: Mode handling

    /// Resolve the opening mode. A mode selected by the launching action wins;
    /// otherwise use the user's preference when supported.
    private func applyInitialMode() {
        guard forcedMode == nil else { return }
        let preferred = settings.preferredPrayerMode
        guard playerModes.contains(preferred), preferred != mode else { return }
        mode = preferred
        controller.setMode(preferred)
    }

    // MARK: Actions

    private func recordCompletion() {
        let completion = PrayerCompletion(prayerID: prayer.id, mode: mode, completedAt: Date())
        modelContext.insert(completion)
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            let message = "The prayer is complete, but it couldn't be added to your local history."
            persistenceHealth.report(message)
            persistenceErrorMessage = message
        }
    }

    private func finishAndClose() {
        coordinator.noteSessionCompletion(prayer.id)
        controller.stop()
        coordinator.dismissPlayer()
        dismiss()
    }

    private func repeatPrayer() {
        // The user explicitly wants this prayer again — do not deprioritise it.
        if reduceMotion { showCompletion = false }
        else { withAnimation { showCompletion = false } }
        controller.reset()
        controller.start()
    }

    private func savePrayer() {
        // Avoid duplicate favourites for the same prayer.
        let id = prayer.id
        let descriptor = FetchDescriptor<FavoritePrayer>(
            predicate: #Predicate { $0.prayerID == id }
        )
        do {
            let alreadySaved = try modelContext.fetch(descriptor).isEmpty == false
            if !alreadySaved {
                modelContext.insert(FavoritePrayer(prayerID: id, savedAt: Date()))
                try modelContext.save()
            }
        } catch {
            modelContext.rollback()
            let message = "This prayer couldn't be saved. Please try again."
            persistenceHealth.report(message)
            persistenceErrorMessage = message
            return
        }
        coordinator.noteSessionCompletion(id)
        controller.stop()
        coordinator.dismissPlayer()
        dismiss()
    }
}

private extension View {
    /// Discreet styling for the self-led modes' explicit completion action.
    func silentCompleteStyle(theme: ThemePalette) -> some View {
        self
            .font(.headline)
            .padding(.vertical, 14)
            .background(theme.foreground.opacity(0.12))
            .foregroundStyle(theme.foreground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .buttonStyle(.plain)
    }
}
