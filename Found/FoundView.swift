//
//  FoundView.swift
//  Found
//
//  Created by Chelsea She on 11/23/24.
//

import SwiftUI

struct FoundView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Found Items")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .navigationTitle("Found")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showProfile()
                    } label: {
                        Image(systemName: "person")
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.isShowingProfileView){
            ProfileView(viewModel: ProfileViewModel())
        }
    }
}

