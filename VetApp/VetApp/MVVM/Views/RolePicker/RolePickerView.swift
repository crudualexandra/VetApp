import SwiftUI

struct RolePickerView: View {
    @EnvironmentObject var appState: AppState
    @Binding var showChangeRole: Bool
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: Theme.spacingLarge) {
                Text("Welcome to VetSecure")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                
                Text("Select your role to continue")
                    .font(.headline)
                    .foregroundColor(Theme.gray)
                    .padding(.bottom, 40)
                
                VStack(spacing: Theme.spacingLarge) {
                    ForEach(AppRole.allCases, id: \.self) { role in
                        RoleCard(role: role) {
                            withAnimation(Theme.standardSpring) {
                                appState.setRole(role)
                                
                            }
                            HapticFeedback.success()
                            showChangeRole = false
                        }
                    }
                }
                .padding(.horizontal, Theme.spacingLarge)
                
                Spacer()
            }
            .padding()
        }
    }
}
