import SwiftUI

struct Theme {
    // Colors
    static let deepBlue = Color(hex: "0F1C2E")
    static let primaryBlue = Color(hex: "3B82F6")
    static let teal = Color(hex: "2DD4BF")
    static let purple = Color(hex: "8B5CF6")
    static let white = Color(hex: "FFFFFF")
    static let lightGray = Color(hex: "F3F4F6")
    static let gray = Color(hex: "9CA3AF")
    static let darkGray = Color(hex: "4B5563")
    
    // Dimensions
    static let cornerRadius: CGFloat = 16
    static let cardCornerRadius: CGFloat = 20
    static let iconSize: CGFloat = 24
    static let spacingSmall: CGFloat = 8
    static let spacingMedium: CGFloat = 16
    static let spacingLarge: CGFloat = 24
    
    // Animations
    static let standardSpring = Animation.spring(response: 0.3, dampingFraction: 0.7, blendDuration: 0)
    static let quickSpring = Animation.spring(response: 0.2, dampingFraction: 0.6, blendDuration: 0)
    
    // Gradients
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [deepBlue.opacity(0.95), deepBlue]),
        startPoint: .top,
        endPoint: .bottom
    )
}
