import SwiftUI

/// A simple list of prayers under a heading. Tapping a row opens the player.
struct PrayerListView: View {
    @EnvironmentObject private var settings: AppSettings

    let title: String
    var subtitle: String? = nil
    let prayers: [Prayer]
    let onSelect: (Prayer) -> Void

    var body: some View {
        List {
            if let subtitle {
                Section {
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            if prayers.isEmpty {
                Text("No prayers here yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(prayers) { prayer in
                    Button {
                        onSelect(prayer)
                    } label: {
                        PrayerRow(
                            prayer: prayer,
                            scriptPreference: settings.scriptPreference
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// A compact row describing a prayer.
struct PrayerRow: View {
    let prayer: Prayer
    let scriptPreference: ScriptPreference

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: prayer.deity?.symbolName ?? "flame")
                .font(.title3)
                .foregroundStyle(.orange)
                .frame(width: 32)
            VStack(alignment: .leading, spacing: 3) {
                Text(prayer.title)
                    .font(.headline)
                if scriptPreference != .transliteration {
                    Text(prayer.primaryText.devanagari)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                if scriptPreference != .devanagari {
                    Text(prayer.transliteration)
                        .font(scriptPreference == .both ? .caption : .subheadline)
                        .italic()
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            Text(prayer.durationLabel)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
    }
}
