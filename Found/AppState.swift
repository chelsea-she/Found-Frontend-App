//
//  AppState.swift
//  Lost and Found
//
//  Created by Chelsea She on 11/23/24.
//

import Foundation
import FirebaseAuth
import SwiftUI
import FirebaseCore

class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var navigationPath = NavigationPath()
    
    var isLoggedIn: Bool {
        return currentUser != nil
    }
    
    init() {
        FirebaseApp.configure()
        if let currentUser = Auth.auth().currentUser {
            self.currentUser = currentUser
        }
    }
}
