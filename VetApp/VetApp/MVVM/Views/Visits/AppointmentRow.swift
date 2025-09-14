import SwiftUI

struct AppointmentRow: View {
    @EnvironmentObject var store: AppStorageStore
    @EnvironmentObject var appState: AppState
    
    let appointment: Appointment
    
    var pet: Pet? {
        store.getPet(id: appointment.petId)
    }
    
    var isPast: Bool {
        appointment.date < Date()
    }
    
    var accentColor: Color {
        appState.currentRole.accentColor
    }
    
    var body: some View {
        HStack(spacing: Theme.spacingMedium) {
            VStack(alignment: .center, spacing: 4) {
                Text(appointment.date.formatDate())
                    .font(.caption)
                    .foregroundColor(Theme.gray)
                
                Text(appointment.date.formatTime())
                    .font(.headline)
                    .foregroundColor(isPast ? Theme.gray : .white)
            }
            .frame(width: 80)
            
            Rectangle()
                .fill(Theme.gray.opacity(0.3))
                .frame(width: 1, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                if let pet = pet {
                    Text(pet.name)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(pet.species)
                        .font(.subheadline)
                        .foregroundColor(Theme.gray)
                } else {
                    Text("Unknown Pet")
                        .font(.headline)
                        .foregroundColor(Theme.gray)
                }
                
                Text(appointment.reason)
                    .font(.caption)
                    .foregroundColor(Theme.gray)
                    .lineLimit(1)
                
                if let notes = appointment.notes, !notes.isEmpty {
                    HStack {
                        Image(systemName: "doc.text")
                            .font(.caption)
                        Text("Has notes")
                            .font(.caption)
                    }
                    .foregroundColor(accentColor)
                }
            }
            
            Spacer()
            
            if isPast {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Theme.teal)
            } else {
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.gray)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
    }
}
