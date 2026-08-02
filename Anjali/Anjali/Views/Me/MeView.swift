import SwiftUI
import SwiftData
import UIKit

/// The Me tab: preferences, reminders, and saved prayers.
struct MeView: View {
    @EnvironmentObject private var library: PrayerLibrary
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var persistenceHealth: PersistenceHealth
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase

    @Query(sort: \FavoritePrayer.savedAt, order: .reverse) private var favorites: [FavoritePrayer]

    @StateObject private var notifications = NotificationManager.shared
    @State private var notificationsDenied = false
    @State private var reminderErrorMessage: String?
    @State private var persistenceErrorMessage: String?
    @State private var reminderOperations: Set<ReminderSlot> = []

    // Local mirrors so SwiftUI re-renders on change.
    @State private var script: ScriptPreference = .both
    @State private var mode: PlayMode = .chant
    @State private var ishta: Deity?
    @State private var favoriteMoments: Set<Moment> = []
    @State private var enabledReminders: Set<ReminderSlot> = []
    @State private var reminderTimes: [ReminderSlot: Date] = [:]

    var body: some View {
        NavigationStack {
            Form {
                scriptSection
                modeSection
                ishtaSection
                momentsSection
                remindersSection
                savedSection
                aboutSection
            }
            .navigationTitle("Me")
            .onAppear(perform: loadState)
            .onChange(of: scenePhase) { _, phase in
                if phase == .active {
                    refreshNotificationState()
                }
            }
            .alert(
                "Reminder not changed",
                isPresented: Binding(
                    get: { reminderErrorMessage != nil },
                    set: { if !$0 { reminderErrorMessage = nil } }
                )
            ) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(reminderErrorMessage ?? "")
            }
            .alert(
                "Saved prayers not changed",
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
    }

    // MARK: Sections

    private var scriptSection: some View {
        Section("Script") {
            Picker("Show text as", selection: $script) {
                ForEach(ScriptPreference.allCases) { Text($0.displayName).tag($0) }
            }
            .onChange(of: script) { _, value in settings.scriptPreference = value }
        }
    }

    private var modeSection: some View {
        Section {
            Picker("Pray with", selection: $mode) {
                ForEach(library.availablePreferredModes) {
                    Text($0.displayName).tag($0)
                }
            }
            .onChange(of: mode) { _, value in settings.preferredPrayerMode = value }
        } header: {
            Text("Preferred mode")
        } footer: {
            Text(mode.guidance)
        }
    }

    private var ishtaSection: some View {
        Section {
            Picker("Ishta devata", selection: $ishta) {
                Text("None").tag(Deity?.none)
                ForEach(Deity.allCases) { deity in
                    Text(deity.displayName).tag(Deity?.some(deity))
                }
            }
            .onChange(of: ishta) { _, value in settings.ishtaDevata = value }
        } header: {
            Text("Ishta devata")
        } footer: {
            Text("Prayers to this deity are gently favoured on Today.")
        }
    }

    private var momentsSection: some View {
        Section {
            ForEach(Moment.allCases) { moment in
                Button {
                    toggleMoment(moment)
                } label: {
                    HStack {
                        Label(moment.displayName, systemImage: moment.symbolName)
                            .foregroundStyle(.primary)
                        Spacer()
                        if favoriteMoments.contains(moment) {
                            Image(systemName: "checkmark")
                                .foregroundStyle(.orange)
                        }
                    }
                }
            }
        } header: {
            Text("Situations to prioritize")
        } footer: {
            Text("These gently shape what Today suggests. Every situation remains available in Find a prayer.")
        }
    }

    private var remindersSection: some View {
        Section {
            ForEach(ReminderSlot.allCases) { slot in
                VStack {
                    Toggle(isOn: bindingForReminder(slot)) {
                        Text(slot.title)
                    }
                    .disabled(reminderOperations.contains(slot))

                    if enabledReminders.contains(slot) {
                        DatePicker(
                            "Time",
                            selection: bindingForReminderTime(slot),
                            displayedComponents: .hourAndMinute
                        )
                        .disabled(reminderOperations.contains(slot))
                    }
                }
            }
            if notificationsDenied {
                Text("Notifications are turned off in Settings.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Button("Open iOS Settings") {
                    guard let url = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    openURL(url)
                }
            }
        } header: {
            Text("Reminders")
        } footer: {
            Text("Local reminders only. Nothing leaves your device.")
        }
    }

    private var savedSection: some View {
        Section("Saved prayers") {
            if savedPrayers.isEmpty {
                Text("Prayers you save will rest here.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(savedPrayers) { prayer in
                    Button {
                        coordinator.play(prayer)
                    } label: {
                        PrayerRow(
                            prayer: prayer,
                            scriptPreference: settings.scriptPreference
                        )
                    }
                    .buttonStyle(.plain)
                    .accessibilityIdentifier("savedPrayer.\(prayer.id)")
                }
                .onDelete(perform: deleteSaved)
            }
        }
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Anjali")
                Spacer()
                Text("A sacred pause, not a session.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            NavigationLink {
                PrivacyView()
            } label: {
                Label("Privacy", systemImage: "hand.raised")
            }
            NavigationLink {
                HowAnjaliWorksView()
            } label: {
                Label("How Anjali works", systemImage: "questionmark.circle")
            }
            LabeledContent("Version", value: appVersion)
        }
    }

    // MARK: Helpers

    private var savedPrayers: [Prayer] {
        favorites.compactMap { library.prayer(withID: $0.prayerID) }
    }

    private func loadState() {
        script = settings.scriptPreference
        let preferredMode = settings.preferredPrayerMode
        mode = library.availablePreferredModes.contains(preferredMode) ? preferredMode : .chant
        if mode != preferredMode {
            settings.preferredPrayerMode = mode
        }
        ishta = settings.ishtaDevata
        favoriteMoments = Set(settings.favoriteMoments)
        enabledReminders = settings.enabledReminders
        reminderTimes = Dictionary(
            uniqueKeysWithValues: ReminderSlot.allCases.map { slot in
                (slot, date(for: settings.reminderTime(for: slot)))
            }
        )
        refreshNotificationState()
    }

    private func refreshNotificationState() {
        Task { @MainActor in
            let status = await notifications.authorizationStatus()
            notificationsDenied = (status == .denied)
            let pending = await notifications.pendingSlots()
            let reconciled = enabledReminders.intersection(pending)
            if reconciled != enabledReminders {
                enabledReminders = reconciled
                settings.enabledReminders = reconciled
            }
        }
    }

    private func toggleMoment(_ moment: Moment) {
        if favoriteMoments.contains(moment) {
            favoriteMoments.remove(moment)
        } else {
            favoriteMoments.insert(moment)
        }
        settings.favoriteMoments = Array(favoriteMoments)
    }

    private func bindingForReminder(_ slot: ReminderSlot) -> Binding<Bool> {
        Binding(
            get: { enabledReminders.contains(slot) },
            set: { isOn in
                Task { await setReminder(slot, enabled: isOn) }
            }
        )
    }

    private func bindingForReminderTime(_ slot: ReminderSlot) -> Binding<Date> {
        Binding(
            get: { reminderTimes[slot] ?? date(for: slot.defaultTime) },
            set: { newDate in
                Task { await setReminderTime(newDate, for: slot) }
            }
        )
    }

    @MainActor
    private func setReminder(_ slot: ReminderSlot, enabled: Bool) async {
        guard !reminderOperations.contains(slot) else { return }
        reminderOperations.insert(slot)
        defer { reminderOperations.remove(slot) }

        if enabled {
            let granted = await notifications.requestAuthorization()
            guard granted else {
                notificationsDenied = true
                reminderErrorMessage =
                    "Notifications are off. Enable them in Settings before turning on a reminder."
                return
            }
            do {
                let time = reminderTime(from: reminderTimes[slot] ?? date(for: slot.defaultTime))
                try await notifications.schedule(slot, at: time)
                enabledReminders.insert(slot)
                notificationsDenied = false
            } catch {
                reminderErrorMessage =
                    "Anjali couldn't schedule this reminder. Please try again."
                return
            }
        } else {
            notifications.cancel(slot)
            enabledReminders.remove(slot)
        }
        settings.enabledReminders = enabledReminders
    }

    @MainActor
    private func setReminderTime(_ newDate: Date, for slot: ReminderSlot) async {
        guard !reminderOperations.contains(slot) else { return }
        let oldDate = reminderTimes[slot] ?? date(for: slot.defaultTime)
        reminderTimes[slot] = newDate
        let newTime = reminderTime(from: newDate)

        guard enabledReminders.contains(slot) else {
            settings.setReminderTime(newTime, for: slot)
            return
        }

        reminderOperations.insert(slot)
        defer { reminderOperations.remove(slot) }
        do {
            try await notifications.schedule(slot, at: newTime)
            settings.setReminderTime(newTime, for: slot)
        } catch {
            reminderTimes[slot] = oldDate
            reminderErrorMessage =
                "Anjali couldn't change this reminder time. The previous time is still scheduled."
        }
    }

    private func date(for time: ReminderTime) -> Date {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        return calendar.date(
            bySettingHour: time.hour,
            minute: time.minute,
            second: 0,
            of: start
        ) ?? start
    }

    private func reminderTime(from date: Date) -> ReminderTime {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        return ReminderTime(
            hour: components.hour ?? 0,
            minute: components.minute ?? 0
        )
    }

    private func deleteSaved(at offsets: IndexSet) {
        let prayersToRemove = offsets.map { savedPrayers[$0] }
        let ids = Set(prayersToRemove.map(\.id))
        for favorite in favorites where ids.contains(favorite.prayerID) {
            modelContext.delete(favorite)
        }
        do {
            try modelContext.save()
        } catch {
            modelContext.rollback()
            let message = "Anjali couldn't remove the selected prayer. Please try again."
            persistenceHealth.report(message)
            persistenceErrorMessage = message
        }
    }

    @Environment(\.modelContext) private var modelContext

    private var appVersion: String {
        let version = Bundle.main.object(
            forInfoDictionaryKey: "CFBundleShortVersionString"
        ) as? String
        return version ?? "—"
    }
}

/// In-app copy of the privacy policy, so the disclosure remains available
/// offline. App Store Connect still requires a public policy URL before an
/// external beta or store submission.
private struct PrivacyView: View {
    var body: some View {
        List {
            Section {
                Text(
                    "Anjali collects no personal data, uses no analytics or advertising, "
                    + "and makes no network requests."
                )
            } header: {
                Text("Private by default")
            }

            Section("Stored on this device") {
                Text(
                    "Your script and mode preferences, chosen deity and moments, "
                    + "reminder choices, prayer completions, and saved prayers stay on this device."
                )
                Text("Deleting Anjali removes this locally stored information.")
            }

            Section("Notifications") {
                Text(
                    "Optional reminders are scheduled locally. Notification permission "
                    + "is requested only after you choose to enable reminders."
                )
            }

            Section("Sharing") {
                Text("Anjali has no account, backend, third-party SDKs, tracking, or data sharing.")
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Plain-language explanation of the product's core concepts. This remains
/// available offline and mirrors the labels used in the player and discovery.
private struct HowAnjaliWorksView: View {
    var body: some View {
        List {
            Section("Prayer modes") {
                guideRow(
                    title: "Listen",
                    symbol: PlayMode.listen.symbolName,
                    text: "Hear a reviewed human recitation while following the prayer text. Listen appears only when that exact recording is approved and included."
                )
                guideRow(
                    title: "Chant",
                    symbol: PlayMode.chant.symbolName,
                    text: "Recite the prayer aloud yourself, at your own pace. The app does not play a voice in this mode."
                )
                guideRow(
                    title: "Silent",
                    symbol: PlayMode.silent.symbolName,
                    text: "Read or repeat the prayer inwardly. No sound plays, making it useful around other people or whenever you prefer quiet."
                )
            }

            Section("Find a prayer") {
                Text(
                    "A Moment describes what is happening in your day, such as dawn, study, travel, or sleep. It is a suggestion, not a time lock—you can open any Moment whenever it supports you."
                )
                Text(
                    "Intentions describe what you seek, such as peace, focus, courage, or gratitude. Deity is an optional devotional filter."
                )
            }

            Section("Reminders") {
                Text(
                    "Reminders are optional, stay on this device, and use the time you choose in Me. You can change or turn off each one at any time."
                )
            }
        }
        .navigationTitle("How Anjali works")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func guideRow(title: String, symbol: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(title, systemImage: symbol)
                .font(.headline)
            Text(text)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}
