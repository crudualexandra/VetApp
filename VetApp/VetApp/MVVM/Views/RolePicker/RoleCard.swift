import SwiftUI

struct RoleCard: View {
    var role: AppRole
    var action: () -> Void
    
    var body: some View {
        PressableCard(action: action) {
            HStack(spacing: Theme.spacingMedium) {
                Image(systemName: role.icon)
                    .font(.system(size: 30))
                    .foregroundColor(role.accentColor)
                    .frame(width: 60, height: 60)
                    .background(role.accentColor.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(role.rawValue)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text(roleDescription(for: role))
                        .font(.subheadline)
                        .foregroundColor(Theme.gray)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.gray)
            }
            .padding(Theme.spacingMedium)
            .background(Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(role.accentColor.opacity(0.5), lineWidth: 1)
            )
        }
    }
    
    private func roleDescription(for role: AppRole) -> String {
        switch role {
        case .owner:
            return "Manage your pets, schedule appointments, and view certificates."
        case .vet:
            return "Manage patients, visits, and create certificates."
        case .admin:
            return "View all data and manage system settings."
        }
    }
}
