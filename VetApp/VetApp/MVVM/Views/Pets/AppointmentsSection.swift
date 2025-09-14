import SwiftUI

struct AppointmentsSection: View {
    @EnvironmentObject var store: AppStorageStore
    
    let pet: Pet
    @State private var showAddAppointment = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.spacingMedium) {
            HStack {
                Text("Upcoming Appointments")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    showAddAppointment = true
                }) {
                    Label("Add", systemImage: "plus")
                        .font(.subheadline)
                        .foregroundColor(Theme.primaryBlue)
                }
            }
            
            let appointments = store.getAppointmentsForPet(id: pet.id)
                .filter { $0.date > Date() }
                .sorted { $0.date < $1.date }
            
            if appointments.isEmpty {
                Text("No upcoming appointments")
                    .font(.subheadline)
                    .foregroundColor(Theme.gray)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .background(Color.black.opacity(0.3))
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            } else {
                ForEach(appointments.prefix(3)) { appointment in
                    AppointmentRow(appointment: appointment)
                }
                
                if appointments.count > 3 {
                    HStack {
                        Spacer()
                        Text("View all (\(appointments.count))")
                            .font(.subheadline)
                            .foregroundColor(Theme.primaryBlue)
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddAppointment) {
            NavigationView {
                AppointmentFormView(petId: pet.id)
            }
        }
    }
}
