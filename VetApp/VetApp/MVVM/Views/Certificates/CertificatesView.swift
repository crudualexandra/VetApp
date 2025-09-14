import SwiftUI

struct CertificatesView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    
    @State private var selectedFilter = 0
    @State private var selectedPetId: UUID? = nil
    @State private var showAddCertificate = false
    @State private var selectedCertificate: Certificate?
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                PillSegmented(
                    options: ["All Certificates", "By Pet"],
                    selectedIndex: $selectedFilter,
                    accentColor: appState.currentRole.accentColor
                )
                .padding(.vertical)
                
                if selectedFilter == 1 {
                    PetPickerView(selectedPetId: $selectedPetId)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                if filteredCertificates.isEmpty {
                    EmptyStateView(
                        title: "No Certificates",
                        message: appState.currentRole == .owner
                            ? "Add your first pet certificate"
                            : "No certificates found",
                        icon: "qrcode",
                        action: appState.currentRole == .vet ? { showAddCertificate = true } : nil,
                        actionTitle: appState.currentRole == .vet ? "Create Certificate" : nil
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.spacingMedium) {
                            ForEach(filteredCertificates) { certificate in
                                PressableCard(action: {
                                    selectedCertificate = certificate
                                }) {
                                    CertificateRow(certificate: certificate)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Certificates")
            .toolbar {
                if appState.currentRole == .vet {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            showAddCertificate = true
                        }) {
                            Image(systemName: "plus")
                                .foregroundColor(appState.currentRole.accentColor)
                        }
                    }
                }
            }
            .sheet(item: $selectedCertificate) { certificate in
                NavigationView {
                    CertificateDetailView(certificate: certificate)
                }
            }
            .sheet(isPresented: $showAddCertificate) {
                NavigationView {
                    CertificateFormView(petId: selectedPetId)
                }
            }
        }
    }
    
    var filteredCertificates: [Certificate] {
        let sorted = store.certificates.sorted { $0.issuedAt > $1.issuedAt }
        if selectedFilter == 0 {
            return sorted
        } else if let petId = selectedPetId {
            return sorted.filter { $0.petId == petId }
        } else {
            // If filtering by pet but no pet is selected, show nothing
            return []
        }
    }
}
