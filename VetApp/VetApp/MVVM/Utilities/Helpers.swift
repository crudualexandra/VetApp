import SwiftUI

struct Identified<T: Identifiable>: Identifiable {
    let id: UUID
    let value: T
    
    init(_ value: T) {
        self.id = UUID()
        self.value = value
    }
}

struct HapticFeedback {
    static func selection() {
        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    }
    
    static func success() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    static func error() {
        UINotificationFeedbackGenerator().notificationOccurred(.error)
    }
}
