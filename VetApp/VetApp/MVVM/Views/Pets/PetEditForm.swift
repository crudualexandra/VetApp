import SwiftUI

struct PetEditForm: View {
    @EnvironmentObject var appState: AppState
    @Binding var pet: Pet
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingLarge) {
            // Basic info - editable by owner
            if appState.currentRole == .owner {
                VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                    Text("Basic Information")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    FormTextField(label: "Pet Name", text: $pet.name)
                    FormTextField(label: "Species", text: $pet.species)
                    FormTextField(label: "Breed (Optional)", text: Binding(
                        get: { pet.breed ?? "" },
                        set: { pet.breed = $0.isEmpty ? nil : $0 }
                    ))
                    
                    Toggle("Has Birthdate", isOn: Binding(
                        get: { pet.birthdate != nil },
                        set: { if !$0 { pet.birthdate = nil } else if pet.birthdate == nil { pet.birthdate = Date() } }
                    ).animation())
                    .foregroundColor(.white)
                    .toggleStyle(SwitchToggleStyle(tint: appState.currentRole.accentColor))
                    
                    if pet.birthdate != nil {
                        DatePicker(
                            "Date of Birth",
                            selection: Binding(
                                get: { pet.birthdate ?? Date() },
                                set: { pet.birthdate = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .foregroundColor(.white)
                        .accentColor(appState.currentRole.accentColor)
                        .colorScheme(.dark)
                    }
                }
            }
            
            // Clinical info - editable by vet only
            if appState.currentRole == .vet {
                VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                    Text("Clinical Information")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    
                    Toggle("Has Weight Record", isOn: Binding(
                        get: { pet.weightKg != nil },
                        set: { if !$0 { pet.weightKg = nil } else if pet.weightKg == nil { pet.weightKg = 0.0 } }
                    ).animation())
                    .foregroundColor(.white)
                    .toggleStyle(SwitchToggleStyle(tint: appState.currentRole.accentColor))

                    if pet.weightKg != nil {
                        HStack {
                            Text("Weight (kg)")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            TextField("", value: Binding(
                                get: { pet.weightKg ?? 0.0 },
                                set: { pet.weightKg = $0 }
                            ), formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                            .frame(width: 80)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    
                    
                    Toggle("Has Checkup Record", isOn: Binding(
                        get: { pet.lastCheckupAt != nil },
                        set: { if !$0 { pet.lastCheckupAt = nil } else if pet.lastCheckupAt == nil { pet.lastCheckupAt = Date() } }
                    ).animation())
                    .foregroundColor(.white)
                    .toggleStyle(SwitchToggleStyle(tint: appState.currentRole.accentColor))
                    
                    if pet.lastCheckupAt != nil {
                        DatePicker(
                            "Last Checkup Date",
                            selection: Binding(
                                get: { pet.lastCheckupAt ?? Date() },
                                set: { pet.lastCheckupAt = $0 }
                            ),
                            displayedComponents: .date
                        )
                        .foregroundColor(.white)
                        .accentColor(appState.currentRole.accentColor)
                        .colorScheme(.dark)
                    }
                    
                    VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                        HStack {
                            Text("Vaccinations")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Button(action: {
                                let newVaccination = Vaccination(id: UUID(), name: "", date: Date())
                                pet.vaccinations.append(newVaccination)
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(appState.currentRole.accentColor)
                            }
                        }
                        
                        if pet.vaccinations.isEmpty {
                            Text("No vaccinations recorded")
                                .foregroundColor(Theme.gray)
                                .padding(.vertical, 8)
                        } else {
                            ForEach($pet.vaccinations) { $vaccination in
                                HStack {
                                    TextField("Vaccination name", text: $vaccination.name)
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    DatePicker(
                                        "",
                                        selection: $vaccination.date,
                                        displayedComponents: .date
                                    )
                                    .labelsHidden()
                                    .fixedSize()
                                    .accentColor(appState.currentRole.accentColor)
                                    .colorScheme(.dark)
                                    
                                    Button(action: {
                                        pet.vaccinations.removeAll { $0.id == vaccination.id }
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
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
