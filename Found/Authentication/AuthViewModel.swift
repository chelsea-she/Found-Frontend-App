//
//  AuthViewModel.swift
//  Lost and Found
//
//  Created by Chelsea She on 11/23/24.
//

import Foundation
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    
    @Published var isLoading = false
    @Published var isPasswordVisible = false
    @Published var userExists = false
    @Published var showAlert = false
    @Published var alertMessage = ""
    
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
}
