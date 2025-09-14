import SwiftUI

struct PressableCard<Content: View>: View {
    var action: () -> Void
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        Button(action: {
            HapticFeedback.selection()
            action()
        }) {
            content()
        }
        .buttonStyle(PressableButtonStyle())
    }
}

struct PressableButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .brightness(configuration.isPressed ? -0.1 : 0)
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
            .animation(configuration.isPressed ? .easeOut(duration: 0.2) : .spring(response: 0.4, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
