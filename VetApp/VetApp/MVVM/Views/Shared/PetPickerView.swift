import SwiftUI

struct PetPickerView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    @Binding var selectedPetId: UUID?
    
    var accentColor: Color {
        appState.currentRole.accentColor
    }
    
    var body: some View {
        if store.pets.isEmpty {
            Text("No pets available")
                .foregroundColor(Theme.gray)
                .padding()
                .background(Color.black.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.spacingMedium) {
                    ForEach(store.pets) { pet in
                        Button(action: {
                            withAnimation(Theme.quickSpring) {
                                selectedPetId = pet.id
                            }
                            HapticFeedback.selection()
                        }) {
                            VStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(selectedPetId == pet.id ? accentColor.opacity(0.2) : Color.black.opacity(0.3))
                                        .frame(width: 60, height: 60)
                                    
                                    Text(String(pet.name.prefix(1).uppercased()))
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(selectedPetId == pet.id ? accentColor : .white)
                                }
                                
                                Text(pet.name)
                                    .font(.caption)
                                    .foregroundColor(selectedPetId == pet.id ? accentColor : .white)
                                    .lineLimit(1)
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 4)
                            .frame(width: 80)
                            .background(
                                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                    .fill(Color.clear)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                            .stroke(selectedPetId == pet.id ? accentColor : Color.clear, lineWidth: 2)
                                    )
                            )
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
