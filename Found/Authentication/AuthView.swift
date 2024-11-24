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

struct AuthView: View {
    @ObservedObject var viewModel: AuthViewModel = AuthViewModel()
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            Text("Found")
                .font(.largeTitle)
                .fontWeight(.medium)
            
            TextField("Email",text: $viewModel.emailText)
                .padding()
                .background(Color.gray.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            if viewModel.isPasswordVisible {
                SecureField("Password",text: $viewModel.passwordText)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            Spacer().frame(height: 20)
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button {viewModel.authenticate(appState: appState)
                } label: {
                    Text(viewModel.userExists ? "Login" : "Sign in")
                }
                .padding()
                .foregroundStyle(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .alert(isPresented: $viewModel.showAlert) {
                    Alert(title: Text("Invalid Password"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))}
            }
            
        }
        .padding()
    }
    
//    func signInWithGoogle() {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        
//        GIDSignIn.sharedInstance.signIn(withPresenting: Application._utility.rootViewController) { [unowned self] result, error in
//            guard error == nil else {
//                print(error?.localizedDescription)
//                return
//            }
//            
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString
//                    
//                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                                   accessToken: user.accessToken.tokenString)
//                    Auth.auth().signIn(with: credential) { res, error in
//                        if let error = error {
//                            print(error.localizedDescription)
//                            return
//                        }
//                        guard let user = res?.user else {return}
//                        print(user)
//                        
//                    }
//        }
//    }
    
}
