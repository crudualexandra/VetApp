import SwiftUI

struct AppointmentDetailView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    
    let appointment: Appointment
    @State private var isEditing: Bool = false
    @State private var editedAppointment: Appointment
    @State private var showDeleteAlert = false
    @State private var showClinicalUpdate = false
    
    var pet: Pet? {
        store.getPet(id: appointment.petId)
    }
    
    var isPast: Bool {
        appointment.date < Date()
    }
    
    var canEditAppointment: Bool {
        appState.currentRole == .owner && !isPast
    }
    
    var canEditNotes: Bool {
        appState.currentRole == .vet
    }
    
    init(appointment: Appointment) {
        self.appointment = appointment
        self._editedAppointment = State(initialValue: appointment)
    }
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: Theme.spacingLarge) {
                    headerView
                    
                    if isEditing {
                        editFormView.padding(.horizontal)
                    } else {
                        detailsView.padding(.horizontal)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit" : "Appointment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if isEditing {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            editedAppointment = appointment
                            isEditing = false
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Save") {
                            store.updateAppointment(editedAppointment)
                            isEditing = false
                            HapticFeedback.success()
                        }
                        .foregroundColor(appState.currentRole.accentColor)
                    }
                }
            }
            .alert("Cancel Appointment?", isPresented: $showDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Yes, Cancel", role: .destructive) {
                    store.deleteAppointment(appointment.id)
                    presentationMode.wrappedValue.dismiss()
                    HapticFeedback.success()
                }
            } message: {
                Text("Are you sure you want to cancel this appointment?")
            }
            .sheet(isPresented: $showClinicalUpdate) {
                if let pet = pet {
                    NavigationView {
                        ClinicalUpdateView(pet: pet, visitDate: appointment.date)
                    }
                }
            }
        }
    }
    
    private var headerView: some View {
        VStack(spacing: Theme.spacingSmall) {
            Text(appointment.date.formatDate())
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            
            Text(appointment.date.formatTime())
                .font(.title3)
                .foregroundColor(Theme.gray)
            
            if let pet = pet {
                HStack {
                    Text("Pet:")
                        .foregroundColor(Theme.gray)
                    Text(pet.name)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .padding(.top, 4)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.spacingLarge)
    }
    
    private var editFormView: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
            if canEditAppointment {
                DatePicker("Date", selection: $editedAppointment.date, in: Date()..., displayedComponents: [.date, .hourAndMinute])
                    .colorScheme(.dark)
                    .accentColor(appState.currentRole.accentColor)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reason for Visit").font(.headline).foregroundColor(.white)
                    TextEditor(text: $editedAppointment.reason)
                        .foregroundColor(.white)
                        .padding()
                        .frame(minHeight: 100)
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
            }
            
            if canEditNotes {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Veterinarian Notes").font(.headline).foregroundColor(.white)
                    TextEditor(text: Binding(
                        get: { editedAppointment.notes ?? "" },
                        set: { editedAppointment.notes = $0 }
                    ))
                    .foregroundColor(.white)
                    .padding()
                    .frame(minHeight: 150)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
            }
        }
    }
    
    private var detailsView: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
            InfoBlock(title: "Reason for Visit", content: appointment.reason)
            
            if let notes = appointment.notes, !notes.isEmpty {
                InfoBlock(title: "Veterinarian Notes", content: notes)
            }
            
            if canEditAppointment {
                Button(action: { isEditing = true }) {
                    Label("Reschedule Appointment", systemImage: "pencil")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.primaryBlue)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
                
                Button(action: { showDeleteAlert = true }) {
                    Label("Cancel Appointment", systemImage: "xmark.circle")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                }
            }
            
            if canEditNotes {
                VStack(spacing: Theme.spacingMedium) {
                    Button(action: {
                        editedAppointment = appointment
                        isEditing = true
                    }) {
                        Label(appointment.notes == nil || appointment.notes!.isEmpty ? "Add Visit Notes" : "Edit Visit Notes", systemImage: "doc.text.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Theme.teal)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    
                    if isPast {
                        Button(action: { showClinicalUpdate = true }) {
                            Label("Update Clinical Records", systemImage: "cross.case.fill")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Theme.purple)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        }
                    }
                }
            }
        }
    }
}

struct InfoBlock: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(content)
                .foregroundColor(Theme.lightGray)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.black.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
        }
    }
}
