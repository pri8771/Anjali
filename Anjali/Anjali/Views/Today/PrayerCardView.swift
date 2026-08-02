import SwiftUI

/// The single contextual prayer card on Today, with three actions:
///  - mode-specific primary action — open the preferred supported mode
///  - Read silently             — open preselected to Silent
///  - Another prayer            — show the next contextual suggestion
struct PrayerCardView: View {
    let prayer: Prayer
    let theme: ThemePalette
    let scriptPreference: ScriptPreference
    let preferredMode: PlayMode
    let recommendationReason: String
    /// Whether another contextual suggestion is available.
    let canChange: Bool
    let onBegin: () -> Void
    let onSilent: () -> Void
    let onChange: () -> Void

    private var playerModes: [PlayMode] {
        let audioAvailable = PrayerAudioAssetResolver().resolve(prayer: prayer) != nil
        return prayer.playableModes(audioAvailable: audioAvailable)
    }

    private var primaryMode: PlayMode {
        if playerModes.contains(preferredMode) {
            return preferredMode
        }
        return playerModes.first ?? .silent
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack {
                if let deity = prayer.deity {
                    InfoChip(text: deity.displayName, systemImage: deity.symbolName, tint: theme.accent)
                }
                Spacer()
                InfoChip(text: prayer.durationLabel, systemImage: "clock", tint: theme.accent)
                    .accessibilityLabel("Duration: \(prayer.accessibleDuration)")
            }

            VStack(alignment: .leading, spacing: 8) {
                Label(recommendationReason, systemImage: "sparkles")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(theme.accent)

                Text(prayer.title)
                    .font(.system(.title2, design: .serif, weight: .semibold))
                    .foregroundStyle(theme.foreground)

                PrayerTextView(
                    prayer: prayer,
                    scriptPreference: scriptPreference,
                    theme: theme,
                    primaryStyle: .title3
                )
                .frame(maxWidth: .infinity)
            }

            // Available modes for this prayer.
            HStack(spacing: 8) {
                ForEach(playerModes) { mode in
                    InfoChip(text: mode.displayName, systemImage: mode.symbolName, tint: theme.foreground.opacity(0.9))
                }
            }

            Text(prayer.meaning)
                .font(.body)
                .foregroundStyle(theme.foreground.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)

            Text("Source: \(prayer.sourceTitle)")
                .font(.caption2)
                .foregroundStyle(theme.secondaryForeground)

            actions
        }
        .padding(22)
        .background(theme.foreground.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(theme.foreground.opacity(0.10), lineWidth: 1)
        )
    }

    private var actions: some View {
        VStack(spacing: 12) {
            // Primary
            Button(action: onBegin) {
                Text(primaryActionTitle)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AnjaliPrimaryButtonStyle(theme: theme))
            .accessibilityLabel(primaryActionTitle)
            .accessibilityHint(primaryMode.guidance)

            Button(action: onSilent) {
                Label("Read silently", systemImage: "moon")
                    .frame(maxWidth: .infinity)
            }
            .secondaryCardAction(theme: theme)
            .accessibilityLabel("Begin in silent mode")
            .accessibilityHint("Read or repeat the prayer inwardly; no sound plays")

            if canChange {
                Button(action: onChange) {
                    Label("Another prayer", systemImage: "arrow.triangle.2.circlepath")
                        .frame(maxWidth: .infinity)
                }
                .secondaryCardAction(theme: theme)
                .accessibilityLabel("Another prayer")
                .accessibilityHint("Shows a different prayer for right now")
            }
        }
    }

    private var primaryActionTitle: String {
        switch primaryMode {
        case .listen: return "Listen now"
        case .chant: return "Begin chanting"
        case .silent: return "Read silently"
        }
    }
}

private extension View {
    /// Smaller, secondary styling for the quiet / alternate actions.
    func secondaryCardAction(theme: ThemePalette) -> some View {
        self
            .font(.subheadline.weight(.medium))
            .padding(.vertical, 12)
            .background(theme.foreground.opacity(0.12))
            .foregroundStyle(theme.foreground)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .buttonStyle(.plain)
    }
}
