import SwiftUI

struct OrbitTabBar: View {
    let tabs: [RootTab]
    @Binding var selectedTab: RootTab
    let accentColor: Color
    
    @Namespace private var tabAnimation
    
    var body: some View {
        HStack {
            ForEach(tabs) { tab in
                TabBarButton(tab: tab, selectedTab: $selectedTab, namespace: tabAnimation, accentColor: accentColor)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 25)
        .padding(.horizontal)
        .background(.black.opacity(0.8))
        .background(.ultraThinMaterial)
        .frame(height: 85, alignment: .top)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

struct TabBarButton: View {
    let tab: RootTab
    @Binding var selectedTab: RootTab
    var namespace: Namespace.ID
    var accentColor: Color
    
    var isSelected: Bool {
        selectedTab == tab
    }
    
    var body: some View {
        Button {
            withAnimation(Theme.standardSpring) {
                selectedTab = tab
            }
            HapticFeedback.selection()
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(accentColor)
                            .frame(height: 44)
                            .matchedGeometryEffect(id: "background_pill", in: namespace)
                            .shadow(color: accentColor.opacity(0.5), radius: 8, y: 4)
                    }
                    
                    Image(systemName: tab.icon)
                        .font(isSelected ? .headline : .body)
                        .foregroundColor(isSelected ? .white : .gray)
                }
                .frame(height: 44)
                
                Text(tab.title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : .gray)
                    .opacity(isSelected ? 1 : 0)
                    .animation(isSelected ? .easeIn(duration: 0.2).delay(0.1) : .easeOut(duration: 0.1), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .accessibilityLabel(tab.title)
        }
        .buttonStyle(.plain)
    }
}

// Helper for corner radius on specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
