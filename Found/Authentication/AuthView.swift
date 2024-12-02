//
//  AuthView.swift
//  Lost and Found
//
//  Created by Chelsea She on 11/23/24.
//TODO: add google sign in
//    https://www.youtube.com/watch?v=vZEUAIHrsg8
//   https://github.com/sheehanmunim/GoogleSignInFirebaseSwiftUI
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase
import GoogleSignInSwift

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            VStack {
                Text("Found")
                    .font(.largeTitle)
                    .fontWeight(.medium)

                TextField("Email", text: $viewModel.emailText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if viewModel.isPasswordVisible {
                    SecureField("Password", text: $viewModel.passwordText)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Spacer().frame(height: 20)
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Button {
                        viewModel.authenticate(appState: appState)
                    } label: {
                        Text(viewModel.userExists ? "Login" : "Sign in")
                    }
                    .padding()
                    .foregroundStyle(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(
                            title: Text("Invalid Password"),
                            message: Text(viewModel.alertMessage),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                }

                Spacer().frame(height: 20)
                Button(action: {
                    viewModel.signInWithGoogle(appState: appState)
                }) {
                    HStack {
                        Image("google") // Add Google logo as an asset
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Sign in with Google")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color.gray)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
            }
            .navigationDestination(isPresented: $appState.isFirstTimeUser) {
                SignupView(viewModel: viewModel)
            }
            .navigationDestination(isPresented: $appState.loggedIn) {
                LostView()
            }
        }
        .padding()
    }
}
