import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var persistenceHealth: PersistenceHealth

    var body: some View {
        TabView(selection: $coordinator.selectedTab) {
            TodayView()
                .tabItem { Label("Today", systemImage: "sun.and.horizon") }
                .tag(AppTab.today)

            MomentsView()
                .tabItem { Label("Find", systemImage: "magnifyingglass") }
                .tag(AppTab.moments)

            MeView()
                .tabItem { Label("Me", systemImage: "person") }
                .tag(AppTab.me)
        }
        .safeAreaInset(edge: .top) {
            if !persistenceHealth.isPersistent {
                Label(
                    "Changes won't be saved after Anjali closes.",
                    systemImage: "exclamationmark.triangle.fill"
                )
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.red)
                .accessibilityLabel(
                    "Storage unavailable. Completions and saved prayers will not be kept after Anjali closes."
                )
            }
        }
    }
}
