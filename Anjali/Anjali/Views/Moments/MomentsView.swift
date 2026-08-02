import SwiftUI

/// Browse prayers by situation or deity. A Moment is an anytime life context,
/// not a clock restriction.
struct MomentsView: View {
    @EnvironmentObject private var library: PrayerLibrary
    @EnvironmentObject private var coordinator: AppCoordinator

    enum BrowseMode: String, CaseIterable, Identifiable {
        case moment = "Moment"
        case intention = "Intention"
        case deity = "Deity"
        var id: String { rawValue }
    }

    @State private var browseMode: BrowseMode = .moment
    @State private var path: [Route] = []

    enum Route: Hashable {
        case moment(Moment)
        case intention(Intention)
        case deity(Deity)
    }

    private let dailyRhythm: [Moment] = [.dawn, .beforeWork, .sunset, .sleep]
    private let everydayLife: [Moment] = [.leavingHome, .meeting, .study, .travel]

    var body: some View {
        NavigationStack(path: $path) {
            List {
                Section {
                    Text(
                        "Choose what is happening in your day or what you need "
                        + "right now. Moments are available anytime."
                    )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .listRowSeparator(.hidden)
                }

                Picker("Browse", selection: $browseMode) {
                    ForEach(BrowseMode.allCases) { Text($0.rawValue).tag($0) }
                }
                .pickerStyle(.segmented)
                .listRowSeparator(.hidden)

                switch browseMode {
                case .moment:
                    momentSection("Daily rhythm", moments: dailyRhythm)
                    momentSection("Everyday life", moments: everydayLife)
                case .intention:
                    Section("What do you need?") {
                        ForEach(library.availableIntentions) { intention in
                            NavigationLink(value: Route.intention(intention)) {
                                browseRow(
                                    title: intention.displayName,
                                    guidance: intention.guidance,
                                    symbolName: intention.symbolName
                                )
                            }
                        }
                    }
                case .deity:
                    Section("Deities") {
                        ForEach(library.availableDeities) { deity in
                            NavigationLink(value: Route.deity(deity)) {
                                Label(deity.displayName, systemImage: deity.symbolName)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Find a prayer")
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .moment(let moment):
                    PrayerListView(
                        title: moment.displayName,
                        subtitle: "\(moment.guidance) Open this moment whenever it supports you.",
                        prayers: library.prayers(for: moment)
                    ) { coordinator.play($0) }
                case .intention(let intention):
                    PrayerListView(
                        title: intention.displayName,
                        subtitle: intention.guidance,
                        prayers: library.prayers(for: intention)
                    ) { coordinator.play($0) }
                case .deity(let deity):
                    PrayerListView(
                        title: deity.displayName,
                        prayers: library.prayers(for: deity)
                    ) { coordinator.play($0) }
                }
            }
        }
        .onChange(of: coordinator.pendingMoment) { _, moment in
            routeToPendingMoment(moment)
        }
        .onAppear {
            routeToPendingMoment(coordinator.pendingMoment)
        }
    }

    @ViewBuilder
    private func momentSection(_ title: String, moments: [Moment]) -> some View {
        let available = moments.filter { library.availableMoments.contains($0) }
        if !available.isEmpty {
            Section(title) {
                ForEach(available) { moment in
                    NavigationLink(value: Route.moment(moment)) {
                        browseRow(
                            title: moment.displayName,
                            guidance: moment.guidance,
                            symbolName: moment.symbolName
                        )
                    }
                }
            }
        }
    }

    private func browseRow(
        title: String,
        guidance: String,
        symbolName: String
    ) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbolName)
                .foregroundStyle(.orange)
                .frame(width: 24)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                Text(guidance)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 3)
    }

    private func routeToPendingMoment(_ moment: Moment?) {
        guard let moment else { return }
        browseMode = .moment
        path = [.moment(moment)]
        coordinator.pendingMoment = nil
    }
}
