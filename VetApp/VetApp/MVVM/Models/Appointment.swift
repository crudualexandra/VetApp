import Foundation

struct Appointment: Identifiable, Codable, Equatable {
    var id: UUID
    var petId: UUID
    var date: Date
    var reason: String
    var notes: String?                 // Vet writes visit notes here
}
