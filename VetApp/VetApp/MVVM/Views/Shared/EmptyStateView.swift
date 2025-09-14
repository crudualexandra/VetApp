import SwiftUI

struct EmptyStateView: View {
    var title: String
    var message: String
    var icon: String
    var action: (() -> Void)?
    var actionTitle: String?
    
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: Theme.spacingLarge) {
            Image(systemName: icon)
                .font(.system(size: 50))
                .foregroundColor(Theme.gray)
                .padding(.bottom, Theme.spacingMedium)
            
            Text(title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            
            Text(message)
                .font(.body)
                .foregroundColor(Theme.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.spacingLarge)
            
            if let action = action, let actionTitle = actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, Theme.spacingLarge)
                        .padding(.vertical, Theme.spacingMedium)
                        .background(RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .fill(appState.currentRole.accentColor))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}
