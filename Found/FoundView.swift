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
    @State private var selectedTab = 0
    
    //MARK: main body
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    CategorySection(category: $category)
                    ColorSection(selectedColors: $selectedColors)
                    DescriptionSection(description: $description)
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            selectedTab += 1
                        }) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .padding()
                                .clipShape(Circle())
                        }
                    }
                }
                .padding([.leading, .trailing], 20)
                .navigationTitle("Found something?")
                .navigationBarTitleDisplayMode(.large)
            }
            .tag(0)
            .tabItem {
                Label("Description", systemImage: "1.circle")
            }

            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    // Insert image here
                    Text("Image stuff will go here")
                    Spacer()
                    HStack {
                        Button(action: {
                            selectedTab -= 1
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding()
                                .clipShape(Circle())
                        }
                        Spacer()
                        Button(action: {
                            selectedTab += 1
                        }) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .padding()
                                .clipShape(Circle())
                        }
                    }
                }
                .padding([.leading, .trailing], 20)
                .navigationTitle("Insert an Image")
                .navigationBarTitleDisplayMode(.large)
            }
            .tag(1)
            .tabItem {
                Label("Image", systemImage: "2.circle")
            }

            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    DatePickerSection(showDatePicker: $showDatePicker, date: $date)
                    LocationSection(location: $location)
                    Spacer()
                    HStack {
                        Button(action: {
                            selectedTab -= 1
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding()
                                .clipShape(Circle())
                        }
                        Spacer()
                        Button(action: {
                            selectedTab += 1
                        }) {
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                                .padding()
                                .clipShape(Circle())
                        }
                    }
                }
                .padding([.leading, .trailing], 20)
                .navigationTitle("Omg where'd you find it?")
                .navigationBarTitleDisplayMode(.large)
            }
            .tag(2)
            .tabItem {
                Label("Location", systemImage: "3.circle")
            }

            NavigationView {
                VStack(alignment: .leading, spacing: 16) {
                    EmailSection(email: $email)
                    PhoneNumberSection(phoneNumber: $phoneNumber)
                    NavigationLink(destination: UIKitViewControllerWrapper()) {//TODO: push do networking here and push to a confirmation page
                        Text("Submit!")
                            .font(.title)
                            .padding()
                            .frame(width: 400, height: 50)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                    HStack {
                        Button(action: {
                            selectedTab -= 1
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.black)
                                .padding()
                                .clipShape(Circle())
                        }
                        Spacer()
                    }
                }
                .padding([.leading, .trailing], 20)
                .navigationTitle("Final step")
                .navigationBarTitleDisplayMode(.large)
            }
            .tag(3)
            .tabItem {
                Label("Contact", systemImage: "4.circle")
            }
        }
        .padding(.bottom, 10)
    }

}
//MARK: categories
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
                Button("Other") {
                    category = ""
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
//MARK: colors
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
//MARK: description
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
//MARK: date picker
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
//MARK: location
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

//MARK: email
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

//MARK: phone number

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

//MARK: date picker

struct DatePickerPopup: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) private var dismiss
    
    let startDate = Calendar.current.date(byAdding: .day, value: -10, to: Date())! // 5 days ago
    let endDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())! // 5 days in the future

    var body: some View {
        VStack {
            Text("Select Date and Time")
                .font(.headline)
                .padding()

            DatePicker(
                "Select Date and Time",
                selection: $selectedDate,
                in: startDate...endDate,
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



struct UIKitViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyUIKitViewController {
        //TODO: do networking here, if successful, return, else return a failed page or just don't return a page?
        //TODO: should we have a review and submit page?
        return MyUIKitViewController()
    }
    
    func updateUIViewController(_ uiViewController: MyUIKitViewController, context: Context) {
        // No updates needed for this example
    }
}
