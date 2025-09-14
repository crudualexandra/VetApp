import SwiftUI

struct AdminDataView: View {
    @EnvironmentObject var store: AppStorageStore
    
    @State private var selectedTab = 0
    @State private var showClearDataAlert = false
    @State private var selectedPet: Pet?
    @State private var selectedAppointment: Appointment?
    @State private var selectedCertificate: Certificate?
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                PillSegmented(
                    options: ["Pets", "Appointments", "Certificates"],
                    selectedIndex: $selectedTab,
                    accentColor: Theme.purple
                )
                .padding(.vertical)
                
                if selectedTab == 0 && store.pets.isEmpty {
                    EmptyStateView(
                        title: "No Pets",
                        message: "No pet data available",
                        icon: "pawprint"
                    )
                } else if selectedTab == 1 && store.appointments.isEmpty {
                    EmptyStateView(
                        title: "No Appointments",
                        message: "No appointment data available",
                        icon: "calendar"
                    )
                } else if selectedTab == 2 && store.certificates.isEmpty {
                    EmptyStateView(
                        title: "No Certificates",
                        message: "No certificate data available",
                        icon: "qrcode"
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: Theme.spacingMedium) {
                            if selectedTab == 0 {
                                ForEach(store.pets) { pet in
                                    PressableCard(action: {
                                        selectedPet = pet
                                    }) {
                                        PetRow(pet: pet)
                                    }
                                }
                            } else if selectedTab == 1 {
                                ForEach(store.appointments.sorted(by: { $0.date > $1.date })) { appointment in
                                    PressableCard(action: {
                                        selectedAppointment = appointment
                                    }) {
                                        AppointmentRow(appointment: appointment)
                                    }
                                }
                            } else if selectedTab == 2 {
                                ForEach(store.certificates) { certificate in
                                    PressableCard(action: {
                                        selectedCertificate = certificate
                                    }) {
                                        CertificateRow(certificate: certificate)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
                
                Button(action: {
                    showClearDataAlert = true
                }) {
                    Text("Clear All Data")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(Theme.cornerRadius)
                }
                .padding()
            }
            .navigationTitle("Data Management")
            .alert(isPresented: $showClearDataAlert) {
                Alert(
                    title: Text("Clear All Data"),
                    message: Text("Are you sure you want to delete all pets, appointments, and certificates? This action cannot be undone."),
                    primaryButton: .destructive(Text("Clear All")) {
                        store.clearAll()
                        HapticFeedback.success()
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(item: $selectedPet) { pet in
                NavigationView {
                    PetDetailView(pet: pet, isEditing: false)
                }
            }
            .sheet(item: $selectedAppointment) { appointment in
                NavigationView {
                    AppointmentDetailView(appointment: appointment)
                }
            }
            .sheet(item: $selectedCertificate) { certificate in
                NavigationView {
                    CertificateDetailView(certificate: certificate)
                }
            }
        }
    }
}
