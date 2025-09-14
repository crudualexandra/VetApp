import SwiftUI

struct CertificatesSection: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    
    let pet: Pet
    @State private var showAddCertificate = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
            HStack {
                Text("Certificates")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if appState.currentRole == .vet {
                    Button(action: {
                        showAddCertificate = true
                    }) {
                        Label("Add", systemImage: "plus")
                            .font(.subheadline)
                            .foregroundColor(appState.currentRole.accentColor)
                    }
                }
            }
            
            let certificates = store.getCertificatesForPet(id: pet.id)
            
            if certificates.isEmpty {
                Text("No certificates yet")
                    .font(.subheadline)
                    .foregroundColor(Theme.gray)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            } else {
                ForEach(certificates) { certificate in
                    CertificateRow(certificate: certificate)
                }
            }
        }
        .sheet(isPresented: $showAddCertificate) {
            NavigationView {
                CertificateFormView(petId: pet.id)
            }
        }
    }
}
