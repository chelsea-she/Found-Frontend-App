//
//  AuthViewModel.swift
//  Lost and Found
//
//  Created by Chelsea She on 11/23/24.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import Firebase
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    @Published var isLoading = false
    @Published var isPasswordVisible = false
    @Published var userExists = false
    @Published var showAlert = false
    @Published var alertMessage = ""

    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
    }
    
    let authService = AuthService()
    
    func authenticate(appState: AppState) {
        isLoading = true
        Task {
            do {
                if !emailText.hasSuffix("@cornell.edu") {
                    await MainActor.run {
                        alertMessage = "You must use a Cornell University email address."
                        showAlert = true
                        isLoading = false
                    }
                    return
                }
                
                if isPasswordVisible {
                    let loginResult = try await authService.login(email: emailText, password: passwordText, userExists: userExists)
                    let _ = try await authService.createUserFirestore(email: emailText)
                    let _ = await authService.checkUserSession()
                    await MainActor.run {
                        guard let result = loginResult else { return }
                        // Update app state
                        appState.currentUser = result.user
                        isLoading = false // Reset loading state after operation
                    }
                } else {
                    let userExistsResult = try await authService.checkUserExists(email: emailText)
                    await MainActor.run {
                        userExists = userExistsResult
                        isPasswordVisible = true
                        isLoading = false // Reset loading state after operation
                        if !userExists {
                            appState.loggedIn = false
                            appState.isFirstTimeUser = true
                        }
                    }
                }
            } catch let authError as NSError {
                // Handle authentication errors
                await MainActor.run {
                    switch AuthErrorCode(rawValue: authError.code) {
                    case .wrongPassword:
                        alertMessage = "The password is incorrect."
                    case .weakPassword:
                        alertMessage = "Password must be at least 6 characters long."
                    default:
                        alertMessage = "Error: \(authError.localizedDescription)"
                    }
                    showAlert = true
                    isLoading = false // Ensure loading state is reset after an error
                }
            } catch {
                print(error)
                await MainActor.run {
                    isLoading = false // Ensure loading state is reset after a generic error
                }
            }
        }
    }

    func signInWithGoogle(appState: AppState, showAlert: Binding<Bool>, alertMessage: Binding<String>) {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("Missing clientID")
            return
        }

        let config = GIDConfiguration(clientID: clientID)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("Failed to get rootViewController")
            return
        }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
            if let error = error {
                print("Google Sign-In Error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    appState.isGoogleUser = false
                    appState.isFirstTimeUser = true
                    appState.loggedIn = false
                }
                return
            }

            guard let user = result?.user, let email = user.profile?.email else {
                print("Failed to retrieve user or email")
                DispatchQueue.main.async {
                    appState.isGoogleUser = false
                    appState.isFirstTimeUser = true
                    appState.loggedIn = false
                }
                return
            }

            // Check if the email domain is @cornell.edu
            if email.hasSuffix("@cornell.edu") {
                let credential = GoogleAuthProvider.credential(
                    withIDToken: user.idToken!.tokenString,
                    accessToken: user.accessToken.tokenString
                )

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase Sign-In Error: \(error.localizedDescription)")
                        DispatchQueue.main.async {
                            appState.isGoogleUser = false
                            appState.loggedIn = false
                        }
                        return
                    }

                    guard let user = authResult?.user else { return }

                    print("Firebase user signed in: \(user.email ?? "No Email")")
                    DispatchQueue.main.async {
                        appState.isGoogleUser = true
                        appState.loggedIn = true
                    }

                    self.checkFirestoreUser(user: user, appState: appState)
                    
                    
                }
            } else {
                // Show alert for non-Cornell email
                DispatchQueue.main.async {
                    alertMessage.wrappedValue = "Please sign in with a Cornell University email address."
                    showAlert.wrappedValue = true
                }
            }
        }
    }




    private func checkFirestoreUser(user: User?, appState: AppState) {
        guard let user = user else { return }
        let db = Firestore.firestore()
        let userDoc = db.collection("users").document(user.uid)

        userDoc.getDocument { document, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error checking user existence: \(error.localizedDescription)")
                    appState.isGoogleUser = false
                    appState.isFirstTimeUser = true
                    appState.loggedIn = false
                    return
                }

                if let document = document, document.exists {
                    print("User already exists in Firestore: \(document.data() ?? [:])")
                    appState.isGoogleUser = true
                    appState.loggedIn = true
                } else {
                    print("First-time user. Creating profile...")
                    appState.isGoogleUser = true
                    appState.isFirstTimeUser = true
                    appState.loggedIn = false

                    userDoc.setData([
                        "email": user.email ?? "",
                        "displayName": user.displayName ?? "",
                        "uid": user.uid,
                        "createdAt": Timestamp()
                    ]) { error in
                        if let error = error {
                            print("Error creating Firestore profile: \(error.localizedDescription)")
                        } else {
                            print("Firestore profile created successfully.")
                        }
                    }
                }
                print("isGoogleUser after Firestore check: \(appState.isGoogleUser)") // Debug log
            }
        }
    }



}
