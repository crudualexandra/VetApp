import SwiftUI

struct PetInfoSection: View {
    let pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
            Text("Pet Information")
                .font(.headline)
                .foregroundColor(.white)
            
            VStack(spacing: Theme.spacingMedium) {
                if let birthdate = pet.birthdate {
                    InfoRow(label: "Date of Birth", value: birthdate.formatDate())
                }
                
                if let weight = pet.weightKg {
                    InfoRow(label: "Weight", value: String(format: "%.1f kg", weight))
                }
                
                if let lastCheckup = pet.lastCheckupAt {
                    InfoRow(label: "Last Checkup", value: lastCheckup.formatDate())
                }
                
                if !pet.vaccinations.isEmpty {
                    VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                        Text("Vaccinations")
                            .font(.subheadline)
                            .foregroundColor(Theme.gray)
                        
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
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
            }
        }
    }
}
