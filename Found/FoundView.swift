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
    
    @State private var category: String = ""
    @State private var selectedColors: [String] = []
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var location: String = ""
    @State private var email: String = "" //pre-fill with user's email
    @State private var phoneNumber: String = "" //pre-fill with user's phone number
    
    @State private var showDatePicker: Bool = false

    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    //insert image here, 
                    CategorySection(category: $category)
                        .padding([.leading, .trailing], 20)
                    ColorSection(selectedColors: $selectedColors)
                        .padding([.leading, .trailing], 20)
                    DescriptionSection(description: $description)
                        .padding([.leading, .trailing], 20)
                    DatePickerSection(showDatePicker: $showDatePicker, date: $date)
                        .padding([.leading, .trailing], 20)
                    LocationSection(location: $location)
                        .padding([.leading, .trailing], 20)
                    EmailSection(email: $email)
                        .padding([.leading, .trailing], 20)
                    PhoneNumberSection(phoneNumber: $phoneNumber)
                        .padding([.leading, .trailing], 20)
                    
                    NavigationLink(destination: ReceivedView()) {//change this later w/ networking etc. 
                        Text("Submit!")
                            .font(.title)
                            .padding()
                            .frame(width: 400, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding([.leading, .trailing], 20)

                    Spacer()
                }
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            viewModel.showProfile()
                        } label: {
                            Image(systemName: "person")
                        }
                    }
                }
                .navigationTitle("Found something?")

            }
        }
        .sheet(isPresented: $viewModel.isShowingProfileView) {
            ProfileView(viewModel: viewModel)
        }
    }
}

    struct CategorySection: View {
        @Binding var category: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Category")
                    .font(.headline)
                Menu {
                    ForEach(Categories.init().categories, id: \.self) { option in
                        Button(option) {
                            category = option
                        }
                    }
                } label: {
                    Label(category.isEmpty ? "Select a category" : category, systemImage: "arrow.down.circle")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                if(category == "Other" || !Categories.init().categories.contains(category)){
                    TextField("Enter a category, if Other", text: $category)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
    }

    struct ColorSection: View {
        @Binding var selectedColors: [String]
        @State private var colorOptions: [ColorOption] = Categories.init().colorOptions

        var body: some View {
            VStack(alignment: .leading) {
                Text("Color")
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(colorOptions, id: \.self) { colorOption in
                            Text(colorOption.name)
                                .padding()
                                .background(selectedColors.contains(colorOption.name) ? colorOption.color.opacity(0.7) : Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .onTapGesture {
                                    if selectedColors.contains(colorOption.name) {
                                        selectedColors.removeAll { $0 == colorOption.name }
                                    } else {
                                        if selectedColors.count < 3 {
                                            selectedColors.append(colorOption.name)
                                        }
                                    }
                                }
                        }
                    }
                }
                HStack{
                    Text("Selected Colors: ")
                    if(selectedColors.count <= 0){
                        Text("You must select at least one color")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    ForEach(selectedColors, id: \.self){ selectedColor in
                        Text(selectedColor)
                            .padding(3)
                            .background(colorOptions[colorOptions.firstIndex(where: { $0.name == selectedColor })!].color.opacity(0.7))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }

    struct DescriptionSection: View {
        @Binding var description: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Write a short description: ")
                    .font(.headline)
                TextField("Enter description", text: $description)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }

    struct DatePickerSection: View {
        @Binding var showDatePicker: Bool
        @Binding var date: Date
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Date Found")
                    .font(.headline)
                Text("Selected: \(date.formatted(date: .long, time: .shortened))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Button(action: {
                    showDatePicker = true // Show the date picker
                }) {
                    Text("Pick a Date")
                        .font(.caption)
                        .padding()
                        .frame(width: 120, height: 30)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .sheet(isPresented: $showDatePicker) {
                DatePickerPopup(selectedDate: $date)
            }
        }
    }

    struct LocationSection: View {
        @Binding var location: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Location Found")
                    .font(.headline)
                TextField("Enter location", text: $location)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }

    struct EmailSection: View {
        @Binding var email: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Email")
                    .font(.headline)
                TextField("Enter email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }

    struct PhoneNumberSection: View {
        @Binding var phoneNumber: String
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Phone Number")
                    .font(.headline)
                TextField("Enter phone number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
        }
    }
struct DatePickerPopup: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            Text("Select Date and Time")
                .font(.headline)
                .padding()

            DatePicker(
                "Select Date and Time",
                selection: $selectedDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(WheelDatePickerStyle())
            .labelsHidden()
            .padding()

            Button(action: {
                dismiss() // Dismiss the popup
            }) {
                Text("Done")
                    .font(.title2)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

