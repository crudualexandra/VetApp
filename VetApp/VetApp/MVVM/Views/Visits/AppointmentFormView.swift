import SwiftUI

struct AppointmentFormView: View {
    @EnvironmentObject var store: AppStorageStore
    @Environment(\.presentationMode) var presentationMode
    
    let petId: UUID?
    @State private var selectedPetId: UUID?
    @State private var date = Date().addingTimeInterval(24 * 60 * 60)
    @State private var reason = ""
    
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Date and Time")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        DatePicker(
                            "Select a date and time",
                            selection: $date,
                            in: Date()...,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .accentColor(Theme.primaryBlue)
                        .colorScheme(.dark)
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reason for Visit")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        TextEditor(text: $reason)
                            .foregroundColor(.white)
                            .padding()
                            .frame(minHeight: 100)
                            .background(Color.black.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    Button(action: saveAppointment) {
                        Text("Schedule Appointment")
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
            .navigationTitle("Schedule Visit")
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
        selectedPetId != nil && !reason.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func saveAppointment() {
        guard let petId = selectedPetId, isFormValid else { return }
        
        let appointment = Appointment(
            id: UUID(),
            petId: petId,
            date: date,
            reason: reason.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: nil
        )
        
        store.addAppointment(appointment)
        HapticFeedback.success()
        presentationMode.wrappedValue.dismiss()
    }
}
