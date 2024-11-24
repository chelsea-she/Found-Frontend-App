//
//  ProfileViewModel.swift
//  instaVerify
//
//  Created by Chelsea She on 8/17/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

class ProfileViewModel: ObservableObject {
    @Published var isShowingProfileView = false
    @Published var userName: String?
    @Published var isLoggedIn: Bool = false
    @Published var isLoading = false
    @Published var email: String?
    
    init() {
        fetchUserName()
        fetchUserEmail()
        self.isLoggedIn = Auth.auth().currentUser != nil
    }

    func fetchUserName() {
        if let user = Auth.auth().currentUser {
            self.userName = user.displayName ?? "No name available"
        } else {
            self.userName = "No user is currently logged in"
        }
    }
    func fetchUserEmail() {
        // Check if the user is logged in
        if let user = Auth.auth().currentUser {
            // Get the user's email address
            self.email = user.email
        } else {
            // No user is logged in
            self.email = "No user is logged in"
        }
    }
    
    func signOut(appState: AppState){
        isLoading = true
        Task {
            do {
                try Auth.auth().signOut()
                await MainActor.run {
                    appState.currentUser = nil
                    isLoading = false
                }
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
            }
        }
    }
    
    func showProfile() {
        isShowingProfileView = true
    }
}

