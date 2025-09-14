import SwiftUI

struct PetDetailView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    
    @Environment(\.presentationMode) var presentationMode
    
    let pet: Pet
    @State var isEditing: Bool
    @State private var editedPet: Pet
    @State private var showDeleteAlert = false
    
    init(pet: Pet, isEditing: Bool) {
        self.pet = pet
        self._isEditing = State(initialValue: isEditing)
        self._editedPet = State(initialValue: pet)
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                    PetHeader(pet: isEditing ? editedPet : pet)
                    
                    Group {
                        if isEditing {
                            PetEditForm(pet: $editedPet)
                        } else {
                            PetInfoSection(pet: pet)
                            
                            if appState.currentRole == .owner {
                                AppointmentsSection(pet: pet)
                                CertificatesSection(pet: pet)
                            } else if appState.currentRole == .vet {
                                VetClinicalSection(pet: pet, editedPet: $editedPet, isEditing: $isEditing)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle(isEditing ? "Edit Pet" : pet.name)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if appState.currentRole != .admin {
                        if isEditing {
                            Button("Save") {
                                store.updatePet(editedPet)
                                isEditing = false
                                HapticFeedback.success()
                            }
                            .foregroundColor(appState.currentRole.accentColor)
                        } else {
                            Menu {
                                if appState.currentRole == .owner {
                                    Button("Edit Pet") {
                                        isEditing = true
                                    }
                                    
                                    Button("Delete Pet", role: .destructive) {
                                        showDeleteAlert = true
                                    }
                                } else if appState.currentRole == .vet {
                                    Button("Edit Clinical Data") {
                                        isEditing = true
                                    }
                                }
                            } label: {
                                Image(systemName: "ellipsis.circle")
                                    .foregroundColor(appState.currentRole.accentColor)
                            }
                        }
                    }
                }
                
                if isEditing {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            editedPet = pet
                            isEditing = false
                        }
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Pet"),
                    message: Text("Are you sure you want to delete \(pet.name)? This cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        store.deletePet(pet.id)
                        presentationMode.wrappedValue.dismiss()
                        HapticFeedback.success()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
