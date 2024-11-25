//
//  FoundApp.swift
//  Found
//
//  Created by Chelsea She on 11/23/24.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

@main
struct FoundApp: App {
    
    //    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState: AppState = AppState()
    @StateObject var profileViewModel = ProfileViewModel()
    
    //    init() {
    //        configureFirebase()
    //    }
    
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn {
                NavigationStack(path: $appState.navigationPath) {
                    TabView {
                        LostView()
                            .tabItem {
                                Label("Lost", systemImage: "questionmark.square.dashed")
                            }
                        FoundView()
                            .tabItem {
                                Label("Found", systemImage: "magnifyingglass")
                            }
                        ReceivedView()
                            .tabItem {
                                Label("Received", systemImage: "checkmark.seal")
                            }
                    }
                    .environmentObject(profileViewModel)
                    .environmentObject(appState)
                }
            }
            else {
                AuthView()
                    .environmentObject(appState)
            }
            
        }
    }
    
    func configureFirebase() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication,
//                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//
//    func application(_ app: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
//}
