import SwiftUI

struct AdminOverviewView: View {
    @EnvironmentObject var store: AppStorageStore
    
    var body: some View {
        ZStack {
            Theme.backgroundGradient
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: Theme.spacingLarge) {
                    // Stats Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: Theme.spacingMedium) {
                        StatCard(title: "Pets", count: store.pets.count, icon: "pawprint", color: Theme.primaryBlue)
                        StatCard(title: "Appointments", count: store.appointments.count, icon: "calendar", color: Theme.teal)
                        StatCard(title: "Certificates", count: store.certificates.count, icon: "qrcode", color: Theme.purple)
                        StatCard(title: "Vaccinations", count: store.pets.reduce(0) { $0 + $1.vaccinations.count }, icon: "syringe", color: Color.orange)
                    }
                    
                    // Rings Chart
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Data Distribution")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: Theme.spacingLarge) {
                            RingChart(values: [
                                (value: Double(store.pets.count), color: Theme.primaryBlue),
                                (value: Double(store.appointments.count), color: Theme.teal),
                                (value: Double(store.certificates.count), color: Theme.purple)
                            ])
                            .frame(width: 150, height: 150)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                LegendItem(color: Theme.primaryBlue, label: "Pets")
                                LegendItem(color: Theme.teal, label: "Appointments")
                                LegendItem(color: Theme.purple, label: "Certificates")
                            }
                        }
                        .padding()
                        .background(Color.black.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    }
                    
                    // Recent Activity
                    VStack(alignment: .leading, spacing: Theme.spacingMedium) {
                        Text("Recent Activity")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        if store.appointments.isEmpty && store.certificates.isEmpty {
                            Text("No recent activity")
                                .foregroundColor(Theme.gray)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .background(Color.black.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        } else {
                            let recentAppointments = store.appointments
                                .sorted { $0.date > $1.date }
                                .prefix(3)
                            
                            let recentCertificates = store.certificates
                                .sorted { $0.issuedAt > $1.issuedAt }
                                .prefix(3)
                            
                            VStack(spacing: 0) {
                                ForEach(Array(recentAppointments), id: \.id) { appointment in
                                    HStack(spacing: Theme.spacingMedium) {
                                        Circle()
                                            .fill(Theme.teal)
                                            .frame(width: 8, height: 8)
                                        
                                        Text("Appointment for \(store.getPet(id: appointment.petId)?.name ?? "N/A")")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        Text(appointment.date.formatDate())
                                            .font(.subheadline)
                                            .foregroundColor(Theme.gray)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.2))
                                    
                                    Divider()
                                        .background(Color.gray.opacity(0.3))
                                }
                                
                                ForEach(Array(recentCertificates), id: \.id) { certificate in
                                    HStack(spacing: Theme.spacingMedium) {
                                        Circle()
                                            .fill(Theme.purple)
                                            .frame(width: 8, height: 8)
                                        
                                        Text("Certificate for \(store.getPet(id: certificate.petId)?.name ?? "N/A")")
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .lineLimit(1)
                                        
                                        Spacer()
                                        
                                        Text(certificate.issuedAt.formatDate())
                                            .font(.subheadline)
                                            .foregroundColor(Theme.gray)
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.2))
                                    
                                    if certificate.id != recentCertificates.last?.id {
                                        Divider()
                                            .background(Color.gray.opacity(0.3))
                                    }
                                }
                            }
                            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                            .overlay(
                                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Overview")
        }
    }
}
