//
//  AuthService.swift
//  Lost and Found
//
//  Created by Chelsea She on 11/23/24.
//

import Foundation
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class AuthService {
    let db = Firestore.firestore()
    
    func createUserFirestore(email: String) async throws {
        _ = try await db.collection("users").addDocument(data: ["email": email])
    }
    
    func checkUserExists(email: String) async throws -> Bool {
//        let documentSnapshot = db.collection("users").whereField("email", isEqualTo: email).count
//        let count = try await documentSnapshot.getAggregation(source: .server).count
//        return Int(truncating: count) > 0
        
        let query = db.collection("users").whereField("email", isEqualTo: email).limit(to: 1)
        let snapshot = try await query.getDocuments()
        
        return !snapshot.isEmpty
    }
    
    func login(email: String, password: String, userExists: Bool) async throws -> AuthDataResult? {
        
        if userExists {
            return try await Auth.auth().signIn(withEmail: email, password: password)
        } else {
            return try await Auth.auth().createUser(withEmail: email, password: password)
        }
    }
    
    func checkUserSession() async {
        if let user = Auth.auth().currentUser {
            // User is signed in
            print("User is already signed in with uid: \(user.uid)")
            // Navigate to the main part of the app
        } else {
            // No user is signed in
            print("No user is signed in")
            // Navigate to the login screen
        }
    }
}
