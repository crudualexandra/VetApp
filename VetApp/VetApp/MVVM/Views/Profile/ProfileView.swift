import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var store: AppStorageStore
    
    @State private var showChangeRole = false
    @State private var showClearDataAlert = false
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Profile Header
                    VStack(spacing: Theme.spacingMedium) {
                        Image(systemName: appState.currentRole.icon)
                            .font(.system(size: 60))
                            .foregroundColor(appState.currentRole.accentColor)
                            .frame(width: 120, height: 120)
                            .background(appState.currentRole.accentColor.opacity(0.2))
                            .clipShape(Circle())
                        
                        Text(appState.currentRole.rawValue)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .padding(.top, 40)
                    .padding(.bottom, 20)
                    
                    // Options
                    VStack(spacing: Theme.spacingMedium) {
                        PressableCard(action: { showChangeRole = true }) {
                            ProfileRow(title: "Change Role", icon: "person.2.circle", color: appState.currentRole.accentColor)
                        }
                        
                        if appState.currentRole == .admin {
                            PressableCard(action: { showClearDataAlert = true }) {
                                ProfileRow(title: "Clear All App Data", icon: "trash.circle", color: .red)
                            }
                        }
                    }
                    
                    // App Info
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("About VetSecure")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.bottom, 4)
                        
                        HStack {
                            Image(systemName: "info.circle")
                                .foregroundColor(appState.currentRole.accentColor)
                            Text("Version 1.0.0")
                                .foregroundColor(Theme.gray)
                        }
                        
                        HStack {
                            Image(systemName: "swift")
                                .foregroundColor(appState.currentRole.accentColor)
                            Text("Built with SwiftUI")
                                .foregroundColor(Theme.gray)
                        }
                        
                        HStack {
                            Image(systemName: "lock.shield")
                                .foregroundColor(appState.currentRole.accentColor)
                            Text("Local data storage")
                                .foregroundColor(Theme.gray)
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                .padding()
            }
            .navigationTitle("Profile")
        }
        .sheet(isPresented: $showChangeRole) {
            RolePickerView(showChangeRole: $showChangeRole)
        }
        .alert("Clear All Data?", isPresented: $showClearDataAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Clear Data", role: .destructive) {
                store.clearAll()
                HapticFeedback.success()
            }
        } message: {
            Text("This will delete all pets, visits, and certificates from this device and cannot be undone.")
        }
    }
}

struct ProfileRow: View {
    var title: String
    var icon: String
    var color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.gray)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
    }
}
