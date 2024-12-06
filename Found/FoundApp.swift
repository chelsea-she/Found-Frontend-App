//
//  FoundApp.swift
//  Found
//
//  Created by Chelsea She on 11/23/24.
//

import SwiftUI
import Firebase
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

@main
struct FoundApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appState: AppState = AppState()
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var authViewModel = AuthViewModel(appState: AppState())
    @State var user: AppUser?

    
//    init() {
//            let appState = AppState()
//            self._authViewModel = StateObject(wrappedValue: AuthViewModel(appState: appState))
//    }
    
    var body: some Scene {
        WindowGroup {
            if appState.isFirstTimeUser {
                if appState.isGoogleUser {
                    GoogleSignupView(user: $user, viewModel: authViewModel)
                        .environmentObject(appState)
                }
                else {
                    SignupView(viewModel: authViewModel)
                        .environmentObject(appState)
                }
            }
            else if appState.isLoggedIn {
                NavigationStack(path: $appState.navigationPath) {
                    TabView {
                        LostView(user: $user)
                            .tabItem {
                                Label("Lost", systemImage: "questionmark.square.dashed")
                            }
                        FoundView(user:$user)
                            .tabItem {
                                Label("Found", systemImage: "magnifyingglass")
                            }
                        
                        ReceivedView(user:$user)
                            .tabItem {
                                Label("Received", systemImage: "checkmark.seal")
                            }
                        ProfileView(viewModel: ProfileViewModel(), user:$user)
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }

                    }
                    .environmentObject(profileViewModel)
                    .environmentObject(appState)
                }
            }
            else {
                AuthView(viewModel: authViewModel, user:$user)
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

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}
