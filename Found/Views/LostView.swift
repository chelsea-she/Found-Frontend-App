//
//  ContentView.swift
//  Found
//
//  Created by Chelsea She on 11/23/24.
//

import SwiftUI

struct LostView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState
    
    @State var category: String = ""
    @State var itemName: String = ""
    @State var selectedColors: [String] = []
    @State var description: String = ""
    @State var location: String = ""
    @State var date:Date = Date()
    
    @State var showDatePicker:Bool = false
    
    @State private var selectedTab = 0
    @State private var shouldNavigate = false
    @State private var showIncompleteAlert = false

    @State private var formPost:Post = Post.dummyData
    
    var body: some View {
        VStack{
            LostTabButtonView(selectedTab: $selectedTab)

            
            ZStack{
                if(selectedTab == 0){
                    TabItemView(title: "Lost something?", content:{
                        NameSectionLost(itemName: $itemName)
                        CategorySectionLost(category: $category)
                        ColorSectionLost(selectedColors: $selectedColors)
                        Spacer()
                        HStack{
                            HStack {
                                Spacer()
                                Button(action: {
                                    selectedTab += 1
                                }) {
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                        .clipShape(Circle())
                                }
                                .contentShape(Rectangle())
                                .frame(width: 22, height: 22)
                            }
                        }
                    })
                }
                if(selectedTab == 1){
                    TabItemView(title: "Where'd you lose it?", content:{
                        DescriptionSectionLost(description: $description)
                        //DatePickerSectionLost(showDatePicker: $showDatePicker, date: $date)
                        LocationSectionLost(location: $location)
                        Spacer()
                        Button(action:{//TODO: push do networking here and push to a confirmation page
                            if(checkFormFinished()){
                                shouldNavigate = true
                            }
                            else{
                                showIncompleteAlert = true
                            }
                        }) {
                            Text("Search")
                                .font(.title2)
                                .frame(width: UIScreen.main.bounds.width-40, height: 50)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .alert("Stop!", isPresented: $showIncompleteAlert, actions: {
   
                        }, message: {
                            Text("Please fill out all form fields!")
                        })
                        NavigationLink(
                            destination: UIKitViewControllerWrapperFound(post: $formPost),
                            isActive: $shouldNavigate,
                            label: { EmptyView() }
                        )
                        HStack{
                            Button(action: {
                                selectedTab -= 1
                            }) {
                                Image(systemName: "arrow.left")
                                    .foregroundColor(.black)
                                    .clipShape(Circle())
                            }
                            .contentShape(Rectangle())
                            .frame(width: 22, height: 22)
                            Spacer()
                        }
                    })
                }
            }
        }
    }
    func checkFormFinished() -> Bool {
        if(category==""||itemName==""||selectedColors.count==0||description==""||location==""){
            return false;
        }
        return true;
    }
}
//MARK: tab buttons:
struct LostTabButtonView: View {
    @Binding var selectedTab: Int
    var body: some View{
        HStack {
            Spacer()
            Button(action: { selectedTab = 0 }) {
                VStack {
                    Image(systemName: "1.circle")
                    Text("Description")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 0 ? .blue : .gray)
            }
            Spacer()
            Button(action: { selectedTab = 1 }) {
                VStack {
                    Image(systemName: "2.circle")
                    Text("Submit")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 1 ? .blue : .gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

//MARK: item name
struct NameSectionLost: View {
    @Binding var itemName: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("What is this item?")
                .font(.headline)
            TextField("A watch, a bracelet, etc.", text: $itemName)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}
//MARK: categories
struct CategorySectionLost: View {
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
struct ColorSectionLost: View {
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
                    .padding(3)
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
struct DescriptionSectionLost: View {
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
struct DatePickerSectionLost: View {
    @Binding var showDatePicker: Bool
    @Binding var date: Date
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Date Lost")
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
            DatePickerPopupLost(selectedDate: $date)
        }
    }
}
//MARK: location
struct LocationSectionLost: View {
    @Binding var location: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Location Lost")
                .font(.headline)
            TextField("Enter location", text: $location)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
}

//MARK: date picker

struct DatePickerPopupLost: View {
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
//MARK: wrapper
struct UIKitViewControllerWrapperLost: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FoundPushSuccessPage {
        //TODO: do networking here, if successful, return, push a collectionview page. this is currently set to push to a test page
        return FoundPushSuccessPage(success: false, post:Post.dummyData)
    }
    
    func updateUIViewController(_ uiViewController: FoundPushSuccessPage, context: Context) {
        // No updates needed for this example
    }
}
//#Preview {
//    LostView()
//}
