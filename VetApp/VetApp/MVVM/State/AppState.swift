import SwiftUI
import Combine

class AppState: ObservableObject {
    @AppStorage("selected_role") var roleRaw: String?
    
    @Published var selectedTab: RootTab = .pets
    @Published var showRolePicker: Bool = false
    
    var currentRole: AppRole {
        if let roleString = roleRaw, let role = AppRole(rawValue: roleString) {
            return role
        }
        return .owner // Default role
    }
    
    var availableTabs: [RootTab] {
        RootTab.tabsForRole(currentRole)
    }
    
    init() {
        // Determine if we need to show role picker on first launch
        showRolePicker = roleRaw == nil
        
        // Set initial tab based on role
        if let roleString = roleRaw, let role = AppRole(rawValue: roleString) {
            selectedTab = RootTab.tabsForRole(role).first ?? .profile
        } else {
            // If no role is set, default to the first tab of the default role
            selectedTab = RootTab.tabsForRole(.owner).first ?? .profile
        }
    }
    
    func setRole(_ role: AppRole) {
        roleRaw = role.rawValue
        selectedTab = RootTab.tabsForRole(role).first ?? .profile
        showRolePicker = false
    }
}
