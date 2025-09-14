import SwiftUI

struct LegendItem: View {
    var color: Color
    var label: String
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 16, height: 16)
            
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
