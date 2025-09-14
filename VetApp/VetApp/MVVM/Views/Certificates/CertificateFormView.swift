import SwiftUI

struct CertificateFormView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    let petId: UUID?
    @State private var selectedPetId: UUID?
    @State private var title = ""
    @State private var issuedAt = Date()
    @State private var hasExpiration = false
    @State private var expiresAt = Date().addingTimeInterval(365 * 24 * 60 * 60) // One year from today
    
    init(petId: UUID?) {
        self.petId = petId
        self._selectedPetId = State(initialValue: petId)
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    if petId == nil {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Pet")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            PetPickerView(selectedPetId: $selectedPetId)
                        }
                    }
                    
                    FormTextField(label: "Certificate Title", text: $title)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Issue Date")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        DatePicker(
                            "Issue Date",
                            selection: $issuedAt,
                            displayedComponents: .date
                        )
                        .foregroundColor(.white)
                        .accentColor(appState.currentRole.accentColor)
                        .colorScheme(.dark)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Toggle("Has Expiration Date", isOn: $hasExpiration.animation())
                            .foregroundColor(.white)
                            .toggleStyle(SwitchToggleStyle(tint: appState.currentRole.accentColor))
                        
                        if hasExpiration {
                            DatePicker(
                                "Expiration Date",
                                selection: $expiresAt,
                                in: issuedAt...,
                                displayedComponents: .date
                            )
                            .foregroundColor(.white)
                            .accentColor(appState.currentRole.accentColor)
                            .colorScheme(.dark)
                        }
                    }
                    
                    Button(action: saveCertificate) {
                        Text("Add Certificate")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? appState.currentRole.accentColor : Theme.gray)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    .disabled(!isFormValid)
                }
                .padding()
            }
            .navigationTitle("Add Certificate")
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
        selectedPetId != nil && !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func saveCertificate() {
        guard let petId = selectedPetId, isFormValid else { return }
        
        let certificate = Certificate(
            id: UUID(),
            petId: petId,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            issuedAt: issuedAt,
            expiresAt: hasExpiration ? expiresAt : nil
        )
        
        store.addCertificate(certificate)
        HapticFeedback.success()
        presentationMode.wrappedValue.dismiss()
    }
}
