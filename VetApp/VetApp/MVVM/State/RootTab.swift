import Foundation

enum RootTab: Int, Identifiable, CaseIterable {
    var id: Int { rawValue }
    
    // Owner tabs
    case pets
    case visits
    case certificates
    case profile
    
    // Vet tabs
    case patients
    case vetVisits
    case vetCertificates
    case vetProfile
    
    // Admin tabs
    case overview
    case data
    case adminProfile
    
    var icon: String {
        switch self {
        case .pets, .patients: return "pawprint"
        case .visits, .vetVisits: return "calendar"
        case .certificates, .vetCertificates: return "qrcode"
        case .profile, .vetProfile, .adminProfile: return "person.circle"
        case .overview: return "square.grid.2x2"
        case .data: return "tray.full"
        }
    }
    
    var title: String {
        switch self {
        case .pets: return "Pets"
        case .patients: return "Patients"
        case .visits, .vetVisits: return "Visits"
        case .certificates, .vetCertificates: return "Certificates"
        case .profile, .vetProfile, .adminProfile: return "Profile"
        case .overview: return "Overview"
        case .data: return "Data"
        }
    }
    
    static func tabsForRole(_ role: AppRole) -> [RootTab] {
        switch role {
        case .owner:
            return [.pets, .visits, .certificates, .profile]
        case .vet:
            return [.patients, .vetVisits, .vetCertificates, .vetProfile]
        case .admin:
            return [.overview, .data, .adminProfile]
        }
    }
}
