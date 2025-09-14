import SwiftUI

enum AppRole: String, CaseIterable, Codable {
    case owner = "Pet Owner"
    case vet = "Veterinarian"
    case admin = "Admin"
    
    var icon: String {
        switch self {
        case .owner: return "person.circle"
        case .vet: return "stethoscope"
        case .admin: return "gear"
        }
    }
    
    var accentColor: Color {
        switch self {
        case .owner: return Theme.primaryBlue
        case .vet: return Theme.teal
        case .admin: return Theme.purple
        }
    }
}
