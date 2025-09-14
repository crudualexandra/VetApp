import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                TabView(selection: $appState.selectedTab) {
                    ForEach(appState.availableTabs) { tab in
                        tabView(for: tab)
                            .tag(tab)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                OrbitTabBar(
                    tabs: appState.availableTabs,
                    selectedTab: $appState.selectedTab,
                    accentColor: appState.currentRole.accentColor
                )
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    @ViewBuilder
    func tabView(for tab: RootTab) -> some View {
        NavigationView {
            switch tab {
            // Owner tabs
            case .pets:
                PetsListView()
            case .visits:
                VisitsView()
            case .certificates:
                CertificatesView()
            case .profile:
                ProfileView()
                
            // Vet tabs
            case .patients:
                PetsListView()
            case .vetVisits:
                VisitsView()
            case .vetCertificates:
                CertificatesView()
            case .vetProfile:
                ProfileView()
                
            // Admin tabs
            case .overview:
                AdminOverviewView()
            case .data:
                AdminDataView()
            case .adminProfile:
                ProfileView()
            }
        }
    }
}
