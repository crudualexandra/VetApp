import SwiftUI

struct PetRow: View {
    @EnvironmentObject var appState: AppState
    let pet: Pet
    
    var accentColor: Color {
        appState.currentRole.accentColor
    }
    
    var body: some View {
        HStack(spacing: Theme.spacingMedium) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.2))
                    .frame(width: 60, height: 60)
                
                Text(String(pet.name.prefix(1).uppercased()))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(accentColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(pet.name)
                    .font(.headline)
                    .foregroundColor(.white)
                
                HStack {
                    Text(pet.species)
                        .font(.subheadline)
                        .foregroundColor(Theme.gray)
                    
                    if let breed = pet.breed, !breed.isEmpty {
                        Text("•")
                            .foregroundColor(Theme.gray)
                        
                        Text(breed)
                            .font(.subheadline)
                            .foregroundColor(Theme.gray)
                            .lineLimit(1)
                    }
                }
                
                if let birthdate = pet.birthdate {
                    Text("Born: \(birthdate.formatDate())")
                        .font(.caption)
                        .foregroundColor(Theme.gray)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.gray)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
    }
}
