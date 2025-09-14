import SwiftUI

struct CertificateDetailView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    let certificate: Certificate
    @State private var showDeleteAlert = false
    
    var pet: Pet? {
        store.getPet(id: certificate.petId)
    }
    
    var isExpired: Bool {
        if let expiresAt = certificate.expiresAt {
            return expiresAt < Date()
        }
        return false
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // QR Code Placeholder
                    ZStack {
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .fill(isExpired ? Theme.gray.opacity(0.2) : Theme.primaryBlue.opacity(0.1))
                            .frame(width: 200, height: 200)
                        
                        Image(systemName: "qrcode")
                            .font(.system(size: 100))
                            .foregroundColor(isExpired ? Theme.gray : Theme.primaryBlue)
                    }
                    .overlay(
                        Group {
                            if isExpired {
                                Text("EXPIRED")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.red.opacity(0.8))
                                    .rotationEffect(Angle(degrees: -30))
                            }
                        }
                    )
                    .padding(.top)
                    
                    // Certificate Details
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text(certificate.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .center)
                        
                        if let pet = pet {
                            InfoRow(label: "Pet", value: pet.name)
                        }
                        
                        InfoRow(label: "Issued On", value: certificate.issuedAt.formatDate())
                        
                        if let expiresAt = certificate.expiresAt {
                            InfoRow(
                                label: "Expires On",
                                value: expiresAt.formatDate()
                            )
                        }
                        
                        if appState.currentRole == .owner {
                            Button(action: {
                                showDeleteAlert = true
                            }) {
                                Text("Delete Certificate")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                            }
                            .padding(.top)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Certificate Details")
            .toolbar {
                if appState.currentRole != .admin {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            Button("Share Certificate") {
                                // Share functionality would go here
                            }
                            
                            if appState.currentRole == .owner {
                                Button("Delete Certificate", role: .destructive) {
                                    showDeleteAlert = true
                                }
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                                .foregroundColor(appState.currentRole.accentColor)
                        }
                    }
                }
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Certificate"),
                    message: Text("Are you sure you want to delete this certificate? This cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        store.deleteCertificate(certificate.id)
                        presentationMode.wrappedValue.dismiss()
                        HapticFeedback.success()
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
}
