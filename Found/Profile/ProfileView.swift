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
    @State private var displayText: String = "Guest"
    @State private var isEditing: Bool = false
    @State private var newName: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            GeometryReader { geometry in
                VStack(spacing: 20) {
                    // Profile Header
                    VStack(spacing: 8) {
                        Text("Welcome, \(displayText)")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(viewModel.email ?? "Not signed in")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center) // Center align within the parent
                    .multilineTextAlignment(.center) // Center align text
                    
                    // Profile Details Section
                    VStack(alignment: .leading, spacing: 16) {
                        // Display Name Row
                        HStack {
                            Text("Display Name:")
                                .font(.headline)
                            Spacer()
                            Text(displayText)
                                .font(.body)
                                .foregroundColor(.primary)
                            Button(action: {
                                newName = displayText
                                isEditing = true
                            }) {
                                Image(systemName: "square.and.pencil")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                            }
                        }
                        Divider() // Add a subtle separator
                        
                        // Email Row
                        HStack {
                            Text("Email:")
                                .font(.headline)
                            Spacer()
                            Text(viewModel.email ?? "Not signed in")
                                .font(.body)
                                .foregroundColor(viewModel.email != nil ? .primary : .secondary)
                        }
                    }
                }
                .padding()
                .frame(width: geometry.size.width, height: geometry.size.height) // Fill available space
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center) // Center vertically and horizontally
            }
            Spacer()
            
            // Logout Button or Loading Indicator
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else {
                Button(action: {
                    viewModel.signOut(appState: appState)
                }) {
                    Text("Log Out")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical, 12) // Padding inside the button (top and bottom)
                        .padding(.horizontal, 20) // Padding inside the button (left and right)
                }
                .padding(.horizontal, 40)
                .background(Color.blue.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
        .padding(.bottom, 20)
        .onAppear {
            viewModel.fetchUserName()
        }
        .sheet(isPresented: $isEditing) {
            // Edit Name Popup
            VStack {
                Text("Edit Display Name")
                    .font(.headline)
                    .padding()
                
                TextField("Enter new name", text: $newName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                HStack {
                    Button("Cancel") {
                        isEditing = false // Dismiss without saving
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Button("Save") {
                        displayText = newName // Save changes
                        isEditing = false // Dismiss the popup
                    }
                    .font(.body)
                    .foregroundColor(.blue)
                }
                .padding()
            }
        }
    }
}
