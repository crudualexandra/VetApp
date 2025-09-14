import SwiftUI

struct CertificateRow: View {
    @EnvironmentObject var store: AppStorageStore
    
    let certificate: Certificate
    
    var pet: Pet? {
        store.getPet(id: certificate.petId)
    }
    
    var isExpired: Bool {
        if let expiresAt = certificate.expiresAt {
            return expiresAt < Date()
        }
        return false
    }
    
    var accentColor: Color {
        Theme.primaryBlue
    }
    
    var body: some View {
        HStack(spacing: Theme.spacingMedium) {
            Image(systemName: "qrcode")
                .font(.system(size: 30))
                .foregroundColor(isExpired ? Theme.gray : accentColor)
                .frame(width: 60, height: 60)
                .background(isExpired ? Theme.gray.opacity(0.2) : accentColor.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(certificate.title)
                    .font(.headline)
                    .foregroundColor(isExpired ? Theme.gray : .white)
                
                if let pet = pet {
                    Text(pet.name)
                        .font(.subheadline)
                        .foregroundColor(Theme.gray)
                }
                
                HStack(spacing: 16) {
                    Text("Issued: \(certificate.issuedAt.formatDate())")
                        .font(.caption)
                        .foregroundColor(Theme.gray)
                    
                    if let expiresAt = certificate.expiresAt {
                        Text("Expires: \(expiresAt.formatDate())")
                            .font(.caption)
                            .foregroundColor(isExpired ? Color.red.opacity(0.8) : Theme.gray)
                    }
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.gray)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(isExpired ? Color.red.opacity(0.3) : Color.clear, lineWidth: 1)
        )
    }
}
