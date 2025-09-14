import SwiftUI

struct VetClinicalSection: View {
    let pet: Pet
    @Binding var editedPet: Pet
    @Binding var isEditing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
            Text("Clinical Information")
                .font(.headline)
                .foregroundColor(.white)
            
            InfoRow(label: "Weight", value: pet.weightKg != nil ? String(format: "%.1f kg", pet.weightKg!) : "Not recorded")
            
            InfoRow(label: "Last Checkup", value: pet.lastCheckupAt != nil ? pet.lastCheckupAt!.formatDate() : "Not recorded")
            
            VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                Text("Vaccinations")
                    .font(.subheadline)
                    .foregroundColor(Theme.gray)
                
                if pet.vaccinations.isEmpty {
                    Text("No vaccinations recorded")
                        .foregroundColor(Theme.gray)
                        .padding(.vertical, 4)
                } else {
                    ForEach(pet.vaccinations) { vaccination in
                        HStack {
                            Text(vaccination.name)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Text(vaccination.date.formatDate())
                                .foregroundColor(Theme.gray)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .background(Color.black.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            
            Button(action: {
                isEditing = true
            }) {
                Text("Update Clinical Data")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Theme.teal)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            }
            .padding(.top, Theme.spacingMedium)
        }
    }
}
