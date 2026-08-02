import SwiftUI

/// Short, optional first-launch orientation:
///  1. Product promise with an immediate skip.
///  2. A live prayer-text preview and optional devotional preference.
///
/// Mode teaching and reminder permission stay in context, after entry, rather
/// than asking people to configure concepts they have not experienced yet.
struct OnboardingView: View {
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var library: PrayerLibrary
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var page = 0

    // Local draft of preferences, committed on finish.
    @State private var script: ScriptPreference = .both
    @State private var ishta: Deity?

    private let theme = ThemePalette.palette(for: .dawn)

    var body: some View {
        ZStack {
            theme.background.ignoresSafeArea()

            TabView(selection: $page) {
                welcome.tag(0)
                preferences.tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Screen 1

    private var welcome: some View {
        VStack(spacing: 16) {
            Spacer()
            Text("Anjali")
                .font(.system(.largeTitle, design: .serif, weight: .light))
                .foregroundStyle(theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text("A sacred pause for everyday life")
                .font(.title3)
                .foregroundStyle(theme.foreground.opacity(0.85))
                .multilineTextAlignment(.center)
            Spacer()
            Button {
                if reduceMotion { page = 1 } else { withAnimation { page = 1 } }
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(AnjaliPrimaryButtonStyle(theme: theme))
            .padding(.horizontal, 32)

            Button("Skip for now", action: complete)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(theme.foreground)
                .frame(minHeight: 44)
                .accessibilityHint("Use the default text and prayer preferences")
                .padding(.bottom, 36)
        }
        .padding()
    }

    // MARK: Screen 2

    private var preferences: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Make the prayer easy to read")
                        .font(.title.weight(.semibold))
                        .foregroundStyle(theme.foreground)
                    Text("Choose how Sanskrit appears. You can change this anytime in Me.")
                        .font(.subheadline)
                        .foregroundStyle(theme.secondaryForeground)
                }

                scriptSection
                ishtaSection

                Button {
                    finish()
                } label: {
                    Text("Enter")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(AnjaliPrimaryButtonStyle(theme: theme))
                .padding(.top, 4)
                .padding(.bottom, 56)
            }
            .padding(.horizontal, 32)
            .padding(.top, 56)
        }
    }

    private var scriptSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Script")
            Picker("Script", selection: $script) {
                ForEach(ScriptPreference.allCases) { pref in
                    Text(pref.displayName).tag(pref)
                }
            }
            .pickerStyle(.segmented)

            if let sample = library.prayers.first {
                VStack(spacing: 8) {
                    Text("PREVIEW")
                        .font(.caption2.weight(.semibold))
                        .tracking(1.4)
                        .foregroundStyle(theme.accent)
                    PrayerTextView(
                        prayer: sample,
                        scriptPreference: script,
                        theme: theme,
                        primaryStyle: .title2
                    )
                }
                .frame(maxWidth: .infinity)
                .padding(16)
                .background(theme.foreground.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            }
        }
    }

    private var ishtaSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Ishta devata")
            Text("A deity close to your heart, if you have one.")
                .font(.caption)
                .foregroundStyle(theme.secondaryForeground)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    deityChip(nil, label: "None")
                    ForEach(Deity.allCases) { deity in
                        deityChip(deity, label: deity.displayName)
                    }
                }
            }
        }
    }

    // MARK: Chip builders

    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.headline)
            .foregroundStyle(theme.foreground)
    }

    private func deityChip(_ deity: Deity?, label: String) -> some View {
        let isSelected = ishta == deity
        return Button {
            ishta = deity
        } label: {
            Text(label)
                .font(.subheadline)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(isSelected ? theme.accent : Color.white.opacity(0.12))
                .foregroundStyle(isSelected ? Color(hex: "1A1208") : theme.foreground)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityHint(
            deity == nil
                ? "Do not prioritize a deity on Today"
                : "Gently prioritize \(label) prayers on Today"
        )
    }

    // MARK: Finish

    private func finish() {
        settings.scriptPreference = script
        settings.preferredPrayerMode = .chant
        settings.ishtaDevata = ishta
        complete()
    }

    private func complete() {
        if reduceMotion { settings.hasCompletedOnboarding = true }
        else { withAnimation { settings.hasCompletedOnboarding = true } }
    }
}
