//
//  SignupView.swift
//  Found
//
//  Created by Chelsea She on 11/24/24.
//

import SwiftUI
import FirebaseAuth
import Firebase
import PhotosUI

struct SignupView: View {
    @State private var password = ""
    @State private var displayName = ""
    @State private var profileImage: UIImage?
    @State private var bio = ""
    @State private var phone = ""
    @State private var isPickerPresented = false
    @Binding var user: AppUser
    
    @EnvironmentObject var appState: AppState
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Profile Image
            //                Button(action: {
            //                    isPickerPresented = true
            //                }) {
            //                    if let profileImage = profileImage {
            //                        Image(uiImage: profileImage)
            //                            .resizable()
            //                            .scaledToFill()
            //                            .frame(width: 100, height: 100)
            //                            .clipShape(Circle())
            //                            .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            //                    } else {
            //                        Image(systemName: "person.circle")
            //                            .resizable()
            //                            .scaledToFit()
            //                            .frame(width: 100, height: 100)
            //                            .foregroundColor(.gray)
            //                    }
            //                }
            
            // Input Fields
            Text("Hello there!")
                .font(.largeTitle)
                .fontWeight(.medium)
            SecureField("Password",text: $viewModel.passwordText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            TextField("Display Name", text: $displayName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Phone #", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Bio", text: $bio)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            // Register Button
            Button(action: completeRegistration) {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Register")
                        .padding()
                        .foregroundStyle(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .padding()
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("An error occurred, please try again"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
        //        .sheet(isPresented: $isPickerPresented) {
        //            ImagePicker(image: $profileImage)
        //        }
    }
    
    private func completeRegistration() {
        // Simplified action to set `isFirstTimeUser` to false
        NetworkManager.shared.createNewUser(profileImage: "url", username: displayName, bio: bio, email: Auth.auth().currentUser!.email!, phone: phone, licenseApprove: true) {
            success, newUser in
            if(success){
                appState.isFirstTimeUser = false
                appState.loggedIn = true
                viewModel.authenticate(appState: appState)
                user = newUser!
                print("si view \(user)")

            }
        }
    }
}
