import SwiftUI

struct PillSegmented: View {
    var options: [String]
    @Binding var selectedIndex: Int
    var accentColor: Color
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(options.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(Theme.standardSpring) {
                        selectedIndex = index
                    }
                    HapticFeedback.selection()
                }) {
                    Text(options[index])
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .foregroundColor(selectedIndex == index ? .white : Theme.gray)
                        .background(
                            ZStack {
                                if selectedIndex == index {
                                    Capsule()
                                        .fill(accentColor)
                                        .matchedGeometryEffect(id: "pill", in: animation)
                                }
                            }
                        )
                }
            }
        }
        .background(
            Capsule()
                .fill(Theme.deepBlue.opacity(0.5))
        )
        .padding(.horizontal, Theme.spacingMedium)
    }
}
