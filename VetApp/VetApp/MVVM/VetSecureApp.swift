//import SwiftUI
//
//@main
//struct VetSecureApp: App {
//    @StateObject private var store = AppStorageStore()
//    @StateObject private var appState = AppState()
//    
//    var body: some Scene {
//        WindowGroup {
//            ZStack {
//                if appState.showRolePicker {
//                    RolePickerView()
//                        .environmentObject(appState)
//                        .environmentObject(store)
//                } else {
//                    ContentView()
//                        .environmentObject(appState)
//                        .environmentObject(store)
//                }
//            }
//            .preferredColorScheme(.dark)
//        }
//    }
//}
