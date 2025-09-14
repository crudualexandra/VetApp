import SwiftUI

struct PetFormView: View {
    @EnvironmentObject var store: AppStorageStore
    @Environment(\.presentationMode) var presentationMode
    
    enum FormMode {
        case create
    }
    
    let mode: FormMode
    @State private var petName = ""
    @State private var species = ""
    @State private var breed = ""
    @State private var hasBirthdate = false
    @State private var birthdate = Date()
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    FormTextField(label: "Pet Name", text: $petName)
                    FormTextField(label: "Species", text: $species)
                    FormTextField(label: "Breed (Optional)", text: $breed)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Add Birthdate", isOn: $hasBirthdate.animation())
                            .foregroundColor(.white)
                            .toggleStyle(SwitchToggleStyle(tint: Theme.primaryBlue))
                        
                        if hasBirthdate {
                            DatePicker(
                                "Date of Birth",
                                selection: $birthdate,
                                in: ...Date(),
                                displayedComponents: .date
                            )
                            .foregroundColor(.white)
                            .accentColor(Theme.primaryBlue)
                            .colorScheme(.dark)
                        }
                    }
                    
                    Button(action: savePet) {
                        Text(mode == .create ? "Add Pet" : "Save Changes")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Theme.primaryBlue : Theme.gray)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    .disabled(!isFormValid)
                }
                .padding()
            }
            .navigationTitle(mode == .create ? "Add Pet" : "Edit Pet")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    var isFormValid: Bool {
        !petName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !species.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func savePet() {
        guard isFormValid else { return }
        
        let pet = Pet(
            id: UUID(),
            name: petName.trimmingCharacters(in: .whitespacesAndNewlines),
            species: species.trimmingCharacters(in: .whitespacesAndNewlines),
            breed: breed.isEmpty ? nil : breed.trimmingCharacters(in: .whitespacesAndNewlines),
            birthdate: hasBirthdate ? birthdate : nil,
            weightKg: nil,
            lastCheckupAt: nil,
            vaccinations: []
        )
        
        store.addPet(pet)
        HapticFeedback.success()
        presentationMode.wrappedValue.dismiss()
    }
}
