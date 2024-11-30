//
//  AppState.swift
//  Lost and Found
//
//  Created by Chelsea She on 11/23/24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Firebase

class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var navigationPath = NavigationPath()
    @Published var isFirstTimeUser: Bool = false
    @Published var loggedIn: Bool = false
    
    var isLoggedIn: Bool {
        return currentUser != nil || loggedIn || Auth.auth().currentUser != nil
    }
    
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }

        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
