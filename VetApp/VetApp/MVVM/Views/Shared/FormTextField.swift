import SwiftUI

struct FormTextField: View {
    var label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)
            
            TextField("", text: $text)
                .padding()
                .background(Color.black.opacity(0.3))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.cornerRadius)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
}
