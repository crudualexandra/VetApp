import SwiftUI

struct PetHeader: View {
    @EnvironmentObject var appState: AppState
    let pet: Pet
    
    var accentColor: Color {
        appState.currentRole.accentColor
    }
    
    var body: some View {
        VStack(spacing: Theme.spacingLarge) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.2))
                    .frame(width: 100, height: 100)
                
                Text(String(pet.name.prefix(1).uppercased()))
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .foregroundColor(accentColor)
            }
            
            VStack(spacing: 4) {
                Text(pet.name)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                HStack {
                    Text(pet.species)
                        .font(.headline)
                        .foregroundColor(Theme.gray)
                    
                    if let breed = pet.breed, !breed.isEmpty {
                        Text("•")
                            .foregroundColor(Theme.gray)
                        
                        Text(breed)
                            .font(.headline)
                            .foregroundColor(Theme.gray)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.spacingLarge)
    }
}
