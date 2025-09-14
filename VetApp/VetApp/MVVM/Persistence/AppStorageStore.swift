import SwiftUI
import Combine
import Foundation

class AppStorageStore: ObservableObject {
    @AppStorage("prefs_json") var prefsJSON: String = "{}"
    @AppStorage("pets_json") var petsJSON: String = "[]"
    @AppStorage("appointments_json") var apptsJSON: String = "[]"
    @AppStorage("certs_json") var certsJSON: String = "[]"
    
    @Published var pets: [Pet] = []
    @Published var appointments: [Appointment] = []
    @Published var certificates: [Certificate] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadData()
        
        $pets
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.savePets() }
            .store(in: &cancellables)
            
        $appointments
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.saveAppointments() }
            .store(in: &cancellables)

        $certificates
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in self?.saveCertificates() }
            .store(in: &cancellables)
    }
    
    private func loadData() {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        pets = decodeJSON(from: petsJSON, decoder: decoder, defaultValue: [])
        appointments = decodeJSON(from: apptsJSON, decoder: decoder, defaultValue: [])
        certificates = decodeJSON(from: certsJSON, decoder: decoder, defaultValue: [])
    }
    
    // MARK: - Pet CRUD
    
    func addPet(_ pet: Pet) {
        pets.append(pet)
    }
    
    func updatePet(_ pet: Pet) {
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index] = pet
        }
    }
    
    func deletePet(_ id: UUID) {
        pets.removeAll { $0.id == id }
    }
    
    private func savePets() {
        petsJSON = encodeJSON(pets, defaultValue: "[]")
    }
    
    // MARK: - Appointment CRUD
    
    func addAppointment(_ appointment: Appointment) {
        appointments.append(appointment)
    }
    
    func updateAppointment(_ appointment: Appointment) {
        if let index = appointments.firstIndex(where: { $0.id == appointment.id }) {
            appointments[index] = appointment
        }
    }
    
    func deleteAppointment(_ id: UUID) {
        appointments.removeAll { $0.id == id }
    }
    
    private func saveAppointments() {
        apptsJSON = encodeJSON(appointments, defaultValue: "[]")
    }
    
    // MARK: - Certificate CRUD
    
    func addCertificate(_ certificate: Certificate) {
        certificates.append(certificate)
    }
    
    func updateCertificate(_ certificate: Certificate) {
        if let index = certificates.firstIndex(where: { $0.id == certificate.id }) {
            certificates[index] = certificate
        }
    }
    
    func deleteCertificate(_ id: UUID) {
        certificates.removeAll { $0.id == id }
    }
    
    private func saveCertificates() {
        certsJSON = encodeJSON(certificates, defaultValue: "[]")
    }
    
    // MARK: - Lookups & Utilities
    
    func getPet(id: UUID) -> Pet? {
        return pets.first { $0.id == id }
    }
    
    func getAppointmentsForPet(id: UUID) -> [Appointment] {
        return appointments.filter { $0.petId == id }
    }
    
    func getCertificatesForPet(id: UUID) -> [Certificate] {
        return certificates.filter { $0.petId == id }
    }
    
    func upcomingAppointments() -> [Appointment] {
        let now = Date()
        return appointments.filter { $0.date > now }.sorted { $0.date < $1.date }
    }
    
    func pastAppointments() -> [Appointment] {
        let now = Date()
        return appointments.filter { $0.date <= now }.sorted { $0.date > $1.date }
    }
    
    func clearAll() {
        pets = []
        appointments = []
        certificates = []
    }
    
    // MARK: - JSON Helpers
    
    private func encodeJSON<T: Encodable>(_ data: T, defaultValue: String) -> String {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        do {
            let jsonData = try encoder.encode(data)
            return String(data: jsonData, encoding: .utf8) ?? defaultValue
        } catch {
            print("Error encoding data: \(error.localizedDescription)")
            return defaultValue
        }
    }
    
    private func decodeJSON<T: Decodable>(from jsonString: String, decoder: JSONDecoder, defaultValue: T) -> T {
        guard !jsonString.isEmpty else { return defaultValue }
        
        do {
            if let jsonData = jsonString.data(using: .utf8) {
                return try decoder.decode(T.self, from: jsonData)
            }
        } catch {
            print("Error decoding data: \(error.localizedDescription)")
        }
        
        return defaultValue
    }
}
