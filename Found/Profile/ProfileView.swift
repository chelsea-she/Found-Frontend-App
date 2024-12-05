//
//  ProfileView.swift
//  instaVerify
//
//  Created by Chelsea She on 8/14/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            if let email = viewModel.email {
                Text("Welcome, \(email)")
                    .padding()
                    .fontWeight(.semibold)
            } else {
                Text("Welcome, Guest")
            }
            Text("You are logged in.")
                .padding()
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
//            NavigationLink(destination: ReceivedView()) {
//                Text("Confirm item reception")
//            }
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

