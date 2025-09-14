import Foundation

struct Certificate: Identifiable, Codable, Equatable {
    var id: UUID
    var petId: UUID
    var title: String
    var issuedAt: Date
    var expiresAt: Date?
}
