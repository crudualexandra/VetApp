import Foundation

struct Pet: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var species: String
    var breed: String?
    var birthdate: Date?
    var weightKg: Double?              // Vet-editable
    var lastCheckupAt: Date?           // Vet-editable
    var vaccinations: [Vaccination]    // Vet-editable
}

struct Vaccination: Identifiable, Codable, Equatable {
    var id: UUID
    var name: String
    var date: Date
}
