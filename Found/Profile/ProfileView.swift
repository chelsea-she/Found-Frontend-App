//
//  ProfileView.swift
//  instaVerify
//
//  Created by Chelsea She on 8/14/24.
//

//import SwiftUI
//
//
//struct ProfileView: View {
//    @StateObject var viewModel: ProfileViewModel
//    @EnvironmentObject var appState: AppState
//    
//    var body: some View {
//        VStack(spacing: 20) { // Add spacing between elements
//            // Header with user email or guest message
//            VStack(spacing: 8) {
//                if let email = viewModel.email {
//                    Text("Welcome, \(email)")
//                        .font(.headline)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.primary)
//                } else {
//                    Text("Welcome, Guest")
//                        .font(.headline)
//                        .foregroundColor(.secondary)
//                }
//                Text("You are logged in.")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//            }
//            .padding()
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.blue.opacity(0.1))
//            )
//            
//            // Show loading spinner if necessary
//            if viewModel.isLoading {
//                ProgressView("Loading...")
//                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
//            } else {
//                // Logout button
//                Button(action: {
//                    viewModel.signOut(appState: appState)
//                }) {
//                    Text("Log Out")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.red)
//                        .cornerRadius(10)
//                }
//                .padding(.horizontal)
//            }
//            
//            Spacer() // Push content upward if there's extra space
//        }
//        .padding()
//        .background(Color(UIColor.systemGroupedBackground)) // Background for better contrast
//        .cornerRadius(20)
//        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
//        .onAppear {
//            viewModel.fetchUserName()
//        }
//        .navigationTitle("Profile")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}


import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if let email = viewModel.email {
                Text("Welcome, \(email)")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            } else {
                Text("Welcome, Guest")
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            if viewModel.isLoading {
                ProgressView()
            } else {
                Button("logout") {
                    viewModel.signOut(appState: appState)
                }
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color.red)
                .padding(10)
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            // Uncomment the NavigationLink when the destination view is ready
            // NavigationLink(destination: ReceivedView()) {
            //     Text("Confirm item reception")
            // }
        }
        .onAppear {
            viewModel.fetchUserName()
        }
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView(viewModel: .init())
//    }
//}

