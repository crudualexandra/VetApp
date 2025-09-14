import SwiftUI

struct PetsListView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    
    @State private var showAddPet = false
    @State private var selectedPet: Pet?
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if store.pets.isEmpty {
                    EmptyStateView(
                        title: appState.currentRole == .owner ? "No Pets Yet" : "No Patients",
                        message: appState.currentRole == .owner ? "Add your first pet to get started with VetSecure" : "No patient records found.",
                        icon: "pawprint",
                        action: appState.currentRole == .owner ? { showAddPet = true } : nil,
                        actionTitle: appState.currentRole == .owner ? "Add Pet" : nil
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.spacingMedium) {
                            ForEach(store.pets) { pet in
                                PressableCard(action: {
                                    selectedPet = pet
                                }) {
                                    PetRow(pet: pet)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(appState.currentRole == .owner ? "My Pets" : "Patients")
            .toolbar {
                if appState.currentRole == .owner {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddPet = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(appState.currentRole.accentColor)
                        }
                    }
                }
            }
            .sheet(item: $selectedPet) { pet in
                NavigationView {
                    PetDetailView(pet: pet, isEditing: false)
                }
            }
            .sheet(isPresented: $showAddPet) {
                NavigationView {
                    PetFormView(mode: .create)
                }
            }
        }
    }
}
