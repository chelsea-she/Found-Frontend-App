//
//  ReceivedView.swift
//  Found
//
//  Created by Chelsea She on 11/24/24.
//

import SwiftUI

struct ReceivedView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Received Items")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .navigationTitle("Received")
//            .toolbar {
//                ToolbarItem(placement: .primaryAction) {
//                    Button {
//                        viewModel.showProfile()
//                    } label: {
//                        Image(systemName: "person")
//                    }
//                }
//            }
//            .sheet(isPresented: $viewModel.isShowingProfileView){
//                ProfileView(viewModel: ProfileViewModel())
//            }
        }
        
    }
}

