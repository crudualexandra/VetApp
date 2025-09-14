import SwiftUI

struct VisitsView: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    
    @State private var selectedFilter = 0 // 0 = All, 1 = By Pet
    @State private var selectedPetId: UUID? = nil
    @State private var showAddVisit = false
    @State private var selectedAppointment: Appointment?
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                if appState.currentRole != .admin {
                    PillSegmented(
                        options: ["All Visits", "By Pet"],
                        selectedIndex: $selectedFilter,
                        accentColor: appState.currentRole.accentColor
                    )
                    .padding(.vertical)
                }
                
                if selectedFilter == 1 {
                    PetPickerView(selectedPetId: $selectedPetId)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                
                if filteredAppointments.isEmpty {
                    EmptyStateView(
                        title: "No Visits",
                        message: appState.currentRole == .owner
                            ? "Schedule your first veterinary visit."
                            : "No scheduled visits found.",
                        icon: "calendar",
                        action: appState.currentRole == .owner ? { showAddVisit = true } : nil,
                        actionTitle: appState.currentRole == .owner ? "Schedule Visit" : nil
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.spacingMedium) {
                            if !upcomingAppointments.isEmpty {
                                SectionHeader(title: "Upcoming Visits")
                                ForEach(upcomingAppointments) { appointment in
                                    PressableCard(action: { selectedAppointment = appointment }) {
                                        AppointmentRow(appointment: appointment)
                                    }
                                }
                            }
                            
                            if !pastAppointments.isEmpty {
                                SectionHeader(title: "Past Visits")
                                ForEach(pastAppointments) { appointment in
                                    PressableCard(action: { selectedAppointment = appointment }) {
                                        AppointmentRow(appointment: appointment)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle(appState.currentRole == .owner ? "My Visits" : "Patient Visits")
            .toolbar {
                if appState.currentRole == .owner {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { showAddVisit = true }) {
                            Image(systemName: "plus")
                                .foregroundColor(appState.currentRole.accentColor)
                        }
                    }
                }
            }
            .sheet(item: $selectedAppointment) { appointment in
                NavigationView {
                    AppointmentDetailView(appointment: appointment)
                }
            }
            .sheet(isPresented: $showAddVisit) {
                NavigationView {
                    AppointmentFormView(petId: nil)
                }
            }
        }
    }
    
    private var filteredAppointments: [Appointment] {
        if selectedFilter == 0 {
            return store.appointments
        } else if let petId = selectedPetId {
            return store.appointments.filter { $0.petId == petId }
        } else {
            // If filtering by pet, but no pet is selected, show nothing
            return []
        }
    }
    
    private var upcomingAppointments: [Appointment] {
        let now = Date()
        return filteredAppointments
            .filter { $0.date >= now }
            .sorted { $0.date < $1.date }
    }
    
    private var pastAppointments: [Appointment] {
        let now = Date()
        return filteredAppointments
            .filter { $0.date < now }
            .sorted { $0.date > $1.date }
    }
}

struct SectionHeader: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 4)
    }
}
