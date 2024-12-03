//
//  FoundView.swift
//  Found
//
//  Created by Chelsea She on 11/23/24.
//

import SwiftUI
import PhotosUI

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
    
    @State private var selectedImages: [UIImage] = []
    
    @State private var showImagePickerFound = false
    @State private var showDatePicker: Bool = false
    @State private var selectedTab = 0
    
    //MARK: layout helper
    struct TabItemView<Content: View>: View {
        let title: String
        let content: Content
        
        init(title: String, @ViewBuilder content: () -> Content) {
            self.title = title
            self.content = content()
        }
        
        var body: some View {
            NavigationView {
                ZStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 16) {
                        Spacer().frame(height: UIScreen.main.bounds.height/2-210) // Create space for the title
                        content
                    }
                    
                    Text(title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(x:0, y:-135)
                }
                .padding([.leading, .trailing], 20)
            }
        }
    }
    
    //MARK: main body
    var body: some View {
        TabView(selection: $selectedTab) {
            TabItemView(title: "Found something?", content: {
                CategorySectionFound(category: $category)
                ColorSectionFound(selectedColors: $selectedColors)
                DescriptionSectionFound(description: $description)
                Spacer()
                    .frame(minWidth:0, minHeight:-50)
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
                    .frame(width: 15, height: 15)
                }
            })
            .tag(0)
            .tabItem {
                Label("Description", systemImage: "1.circle")
            }

            TabItemView(title: "Insert an Image", content: {
                // Insert image here
                ImagePickerFound(selectedImages: $selectedImages, showImagePickerFound: $showImagePickerFound)
                Spacer()

                HStack {
                    Button(action: {
                        selectedTab -= 1
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle())
                    .frame(width: 15, height: 15)
                    Spacer()
                    Button(action: {
                        selectedTab += 1
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle())
                    .frame(width: 15, height: 15)
                }
            })
            .tag(1)
            .tabItem {
                Label("Image", systemImage: "2.circle")
            }

            TabItemView(title: "Omg where'd you find it?", content: {
                DatePickerSectionFound(showDatePicker: $showDatePicker, date: $date)
                LocationSectionFound(location: $location)

                Spacer()
                HStack {
                    Button(action: {
                        selectedTab -= 1
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle())
                    .frame(width: 15, height: 15)
                    Spacer()
                    Button(action: {
                        selectedTab += 1
                    }) {
                        Image(systemName: "arrow.right")
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle())
                    .frame(width: 15, height: 15)
                }
            })
            .tag(2)
            .tabItem {
                Label("Location", systemImage: "3.circle")
            }

            TabItemView(title: "Final step", content: {
                EmailSectionFound(email: $email)
                PhoneNumberSectionFound(phoneNumber: $phoneNumber)
                Spacer()

                NavigationLink(destination: UIKitViewControllerWrapperFound()) {//TODO: push do networking here and push to a confirmation page
                    Text("Submit!")
                        .font(.title2)
                        .frame(width: UIScreen.main.bounds.width-40, height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                HStack {
                    Button(action: {
                        selectedTab -= 1
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    .contentShape(Rectangle())
                    .frame(width: 15, height: 15)
                    Spacer()
                }
            })
            .tag(3)
            .tabItem {
                Label("Contact", systemImage: "4.circle")
            }
        }
        .padding(.bottom, 10)
    }

}
//MARK: categories
struct CategorySectionFound: View {
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
struct ColorSectionFound: View {
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
struct DescriptionSectionFound: View {
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
struct DatePickerSectionFound: View {
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
            DatePickerPopupFound(selectedDate: $date)
        }
    }
}
//MARK: location
struct LocationSectionFound: View {
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
struct EmailSectionFound: View {
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

struct PhoneNumberSectionFound: View {
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

struct DatePickerPopupFound: View {
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
struct UIKitViewControllerWrapperFound: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyUIKitViewController {
        //TODO: do networking here, if successful, return, else return a failed page or just don't return a page?
        //TODO: should we have a review and submit page?
        //TODO: this is currently set to push to a test page
        return MyUIKitViewController()
    }
    
    func updateUIViewController(_ uiViewController: MyUIKitViewController, context: Context) {
        // No updates needed for this example
    }
}

//MARK: image picker
struct ImagePickerFound: View {
    @Binding var selectedImages: [UIImage]
    @Binding var showImagePickerFound: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Text("Insert up to 3 images:")
                Text("\(selectedImages.count)/3")
                    .padding()
                    .foregroundColor(.gray)
            }
            if selectedImages.isEmpty {
                Spacer()
                Text("*No Images Selected!")
                    .foregroundColor(.red)
                Spacer()
            } else {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(selectedImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(minWidth:0, maxWidth: 500)
                                .frame(height: UIScreen.main.bounds.height / 2.75)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
            }
            Spacer()
            Button("Select Photos") {
                showImagePickerFound = true
            }
            .sheet(isPresented: $showImagePickerFound) {
                PhotoPickerFound(selectedImages: $selectedImages)
            }
        }
    }
}

struct PhotoPickerFound: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage]

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 3

        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerFound

        init(_ parent: PhotoPickerFound) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            let group = DispatchGroup()
            var images: [UIImage] = []

            for result in results {
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    group.enter()
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        if let uiImage = image as? UIImage {
                            images.append(uiImage)
                        }
                        group.leave()
                    }
                }
            }

            group.notify(queue: .main) {
                self.parent.selectedImages = images
            }
        }
    }
}
