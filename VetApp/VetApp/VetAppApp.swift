//
//  VetAppApp.swift
//  VetApp
//
//  Created by Badarau Dan on 07.09.2025.
//

import SwiftUI

@main
struct VetAppApp: App {
    @StateObject private var store = AppStorageStore()
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if appState.showRolePicker {
                    RolePickerView(showChangeRole: $appState.showRolePicker)
                        .environmentObject(appState)
                        .environmentObject(store)
                } else {
                    ContentView()
                        .environmentObject(appState)
                        .environmentObject(store)
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
