import SwiftUI

struct ClinicalUpdateView: View {
    @EnvironmentObject var store: AppStorageStore
    @Environment(\.presentationMode) var presentationMode
    
    let pet: Pet
    let visitDate: Date
    @State private var editedPet: Pet
    
    init(pet: Pet, visitDate: Date) {
        self.pet = pet
        self.visitDate = visitDate
        var initialPet = pet
        initialPet.lastCheckupAt = visitDate // Pre-set the checkup date
        self._editedPet = State(initialValue: initialPet)
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                    Text("Update clinical records for \(pet.name) following the visit on \(visitDate.formatDate()).")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)
                    
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        HStack {
                            Text("Weight (kg)")
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            TextField("", value: Binding(
                                get: { editedPet.weightKg ?? 0.0 },
                                set: { editedPet.weightKg = $0 }
                            ), formatter: NumberFormatter())
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.white)
                            .frame(width: 80)
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        
                        Toggle("Has Weight Record", isOn: Binding(
                            get: { editedPet.weightKg != nil },
                            set: { if !$0 { editedPet.weightKg = nil } else if editedPet.weightKg == nil { editedPet.weightKg = 0.0 } }
                        ))
                        .foregroundColor(.white)
                        .toggleStyle(SwitchToggleStyle(tint: Theme.teal))
                        
                        
                        VStack(alignment: .leading, spacing: Theme.spacingSmall) {
                            HStack {
                                Text("Add Vaccination")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    let newVaccination = Vaccination(id: UUID(), name: "", date: visitDate)
                                    editedPet.vaccinations.append(newVaccination)
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(Theme.teal)
                                }
                            }
                            
                            ForEach($editedPet.vaccinations) { $vaccination in
                                if vaccination.date == visitDate { // Only show vaccinations added for this visit
                                    HStack {
                                        TextField("Vaccination name", text: $vaccination.name)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Button(action: {
                                            editedPet.vaccinations.removeAll { $0.id == vaccination.id }
                                        }) {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        
                        Button(action: {
                            store.updatePet(editedPet)
                            HapticFeedback.success()
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Text("Save Clinical Updates")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.teal)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
            .navigationTitle("Clinical Update")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}
