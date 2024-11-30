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

    func signInWithGoogle(appState: AppState) {
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
                return
            }

            guard let user = result?.user, let idToken = user.idToken else {
                print("Failed to retrieve user or token")
                return
            }

            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken.tokenString,
                accessToken: user.accessToken.tokenString
            )

            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    print("Firebase Sign-In Error: \(error.localizedDescription)")
                    return
                }

                guard let user = authResult?.user else { return }

                print("User signed in: \(user.email ?? "No Email")")

                // Check Firestore for user existence
                let db = Firestore.firestore()
                let userDoc = db.collection("users").document(user.uid)

                userDoc.getDocument { document, error in
                    if let error = error {
                        print("Error checking user existence: \(error.localizedDescription)")
                        return
                    }

                    if let document = document, document.exists {
                        print("User already exists: \(document.data() ?? [:])")
                        DispatchQueue.main.async {
                            appState.loggedIn = true
                        }
                    } else {
                        // First-time user
                        print("First-time user. Creating profile...")
                        DispatchQueue.main.async {
                            appState.isFirstTimeUser = true
                        }

                        userDoc.setData([
                            "email": user.email ?? "",
                            "displayName": user.displayName ?? "",
                            "uid": user.uid,
                            "createdAt": Timestamp()
                        ]) { error in
                            if let error = error {
                                print("Error creating user: \(error.localizedDescription)")
                            } else {
                                print("User profile created successfully.")
                            }
                        }
                    }
                }
            }
        }
    }





}
