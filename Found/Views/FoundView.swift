//
//  FoundView.swift
//  Found
//
//  Created by Chelsea She on 11/23/24.
//

import SwiftUI
import PhotosUI
import PhoneNumberKit
import Firebase
import FirebaseStorage
import SwiftUI


struct FoundView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    @EnvironmentObject var appState: AppState
    
    @State private var category: String = ""
    @State private var itemName: String = ""
    @State private var selectedColors: [String] = []
    @State private var description: String = ""
    @State private var date: Date = Date()
    @State private var location: String = ""
    @State private var drop: String = ""
    @State private var email: String = "" //pre-fill with user's email
    @State private var phoneNumber: String = "" //pre-fill with user's phone number
    
    @State private var selectedImages: [UIImage] = []
    
    @State private var showImagePickerFound = false
    @State private var showDatePicker: Bool = false
    @State private var selectedTab = 0
    @State private var shouldNavigate = false
    @State private var phoneNumberValid = false
    @State private var showResetAlert = false
    @State private var showIncompleteAlert = false

    @State private var formPost: Post = Post.dummyData //MARK: change this later
    @State private var isLoading: Bool = false
    
    //MARK: main body
    var body: some View {
        VStack(spacing: 0) {
            
            FoundTabButtonView(selectedTab: $selectedTab)

            ZStack{
                if selectedTab == 0 {
                    TabItemView(title: "Found something?", content: {
                        NameSectionFound(itemName: $itemName)
                        CategorySectionFound(category: $category)
                        ColorSectionFound(selectedColors: $selectedColors)
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
                            .frame(width: 22, height: 22)
                        }
                    })
                }
                
                else if selectedTab == 1 {
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
                            .frame(width: 22, height: 22)
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
                    })
                }
                
                else if selectedTab == 2 {
                    TabItemView(title: "Omg where'd you find it?", content: {
                        //DatePickerSectionFound(showDatePicker: $showDatePicker, date: $date)
                        LocationSectionFound(location: $location)//MARK: make a location selcetor in the future
                        DropSectionFound(drop: $drop)//MARK: make a location selcetor in the future
                        //MARK: future make a more detailed location descirption
                        DescriptionSectionFound(description: $description)
                        
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
                            .frame(width: 22, height: 22)
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
                    })
                }
                
                else{
                    TabItemView(title: "Final step", content: {
                        EmailSectionFound(email: $email)
                        PhoneNumberSectionFound(phoneNumber: $phoneNumber, phoneNumberValid: $phoneNumberValid)
                        Spacer()
                        HStack{
                            Spacer()
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .padding()
                            }
                            Spacer()
                        }
                        Button(action:{//TODO: push do networking here and push to a confirmation page
                            if(checkFormFinished()){
                                isLoading = true
                                updatePost()

                                uploadImagesToFirebase(images: selectedImages) { result in
                                    switch result {
                                    case .success(let urls):
                                        print("All images uploaded successfully!")
                                        print("Uploaded URLs: \(urls)")
                                        // You can save these URLs to Firestore or use them as needed
                                        
                                        var urlString = "['"
                                        var firstTime = true
                                        for url in urls {
                                            if firstTime {
                                                urlString += url
                                                firstTime = false
                                            } else {
                                                urlString += "', '\(url)"
                                            }
                                        }
                                        urlString += "']"
                                        formPost.image = urlString
                                        
                                        shouldNavigate = true
                                        isLoading = false
                                        
                                    case .failure(let error):
                                        print("Failed to upload images: \(error.localizedDescription)")
                                        shouldNavigate = false
                                        isLoading = false

                                    }
                                }
                                
                                
                            }
                            else{
                                showIncompleteAlert.toggle()
                                shouldNavigate = false
                            }
                        }) {
                            Text("Submit!")
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
                        
                        HStack {
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
                            Button(action:{
                                showResetAlert.toggle()
                            }){
                                VStack {
                                    Image(systemName: "arrow.counterclockwise")
                                    Text("Restart")
                                        .font(.caption)
                                }
                                .foregroundColor(.red)
                            }
                            .alert(isPresented: $showResetAlert) {
                                Alert(
                                    title: Text("Are you sure?"),
                                    message: Text("This will reset the form"),
                                    primaryButton: .destructive(Text("OK")) { //Resets everything
                                        selectedTab = 0
                                        category = ""
                                        itemName = ""
                                        selectedColors = []
                                        description = ""
                                        date = Date()
                                        location = ""
                                        drop = ""
                                        
                                        selectedImages = []
                                        
                                        showImagePickerFound = false
                                        showDatePicker = false
                                        selectedTab = 0
                                        shouldNavigate = false
                                        phoneNumberValid = false
                                        showResetAlert = false
                                        
                                        formPost = Post.dummyData //MARK: change this later
                                        
                                    },
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                    })
                }
            }
            .padding(.bottom, 10)
            
        }
    }
    
    func checkFormFinished() -> Bool {
        if(itemName.isEmpty ||
           category.isEmpty || category == "Other" ||
           selectedColors.isEmpty ||
           selectedImages.isEmpty ||
           location.isEmpty || drop.isEmpty ||
           description.isEmpty ||
           email.isEmpty ||
           phoneNumber.isEmpty || !phoneNumberValid){
            return false
        }
        
        return true
    }
    
    func updatePost() {
        var colorString = "['"
        var firstTime = true
        for color in selectedColors {
            if firstTime {
                colorString += color
                firstTime = false
            } else {
                colorString += "', '\(color)"
            }
        }
        colorString += "']"
        
        
        formPost = Post(id: Post.dummyID, itemName: itemName, description: description, timestamp: Date(), locationFound: location, dropLocation: drop, color: colorString, category: category, image: Post.dummyString, fulfilled: false, userID: 1)//MARK: change this
    }
    
    func uploadImagesToFirebase(images: [UIImage], completion: @escaping (Result<[String], Error>) -> Void) {
        var uploadedURLs: [String] = []
        let group = DispatchGroup() // To track completion of all uploads
        
        for image in images {
            group.enter() // Enter the group for each image
            
            // Convert UIImage to Data
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("Failed to convert image to data")
                group.leave()
                continue
            }
            // Get a reference to Firebase Storage
            let storageRef = Storage.storage().reference()
            
            // Create a unique file name for the image
            let fileName = UUID().uuidString
            let imageRef = storageRef.child("images/\(fileName).jpg")
            
            // Upload the image to Firebase Storage
            imageRef.putData(imageData, metadata: nil) { metadata, error in
                if let error = error {
                    print("Error uploading image: \(error.localizedDescription)")
                    group.leave()
                } else {
                    // Get the download URL
                    imageRef.downloadURL { url, error in
                        if let error = error {
                            print("Error getting download URL: \(error.localizedDescription)")
                        } else if let downloadURL = url {
                            print("Uploaded image URL: \(downloadURL.absoluteString)")
                            uploadedURLs.append(downloadURL.absoluteString)
                        }
                        group.leave()
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            if uploadedURLs.count == images.count {
                completion(.success(uploadedURLs))
            } else {
                let error = NSError(domain: "ImageUpload", code: -1, userInfo: [NSLocalizedDescriptionKey: "Some images failed to upload."])
                completion(.failure(error))
            }
        }
        
    }
}

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
                    Spacer().frame(height: UIScreen.main.bounds.height/2-220) // Create space for the title
                    content
                }
                
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .offset(x:0, y:-140)
            }
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 15)
        }
    }
}

//MARK: tab buttons:
struct FoundTabButtonView: View {
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
                    Text("Image")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 1 ? .blue : .gray)
            }
            Spacer()
            Button(action: { selectedTab = 2 }) {
                VStack {
                    Image(systemName: "3.circle")
                    Text("Location")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 2 ? .blue : .gray)
            }
            Spacer()
            Button(action: { selectedTab = 3 }) {
                VStack {
                    Image(systemName: "4.circle")
                    Text("Contact")
                        .font(.caption)
                }
                .foregroundColor(selectedTab == 3 ? .blue : .gray)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
    }
}

//MARK: item name
struct NameSectionFound: View {
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
            Text("Write a short description about the item: ")
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

//MARK: drop
struct DropSectionFound: View {
    @Binding var drop: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("If you dropped this somewhere, where is it?")
                .font(.headline)
            TextField("Enter location", text: $drop)
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
    @Binding var phoneNumberValid: Bool
    
    let phoneNumberUtility = PhoneNumberUtility()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Phone Number")
                .font(.headline)
            if(!phoneNumberValid){
                Text("You must input a valid US phone number")
                    .font(.caption)
                    .foregroundColor(.red)
            }
            TextField("Enter phone number", text: $phoneNumber)
                .keyboardType(.phonePad)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
                .onChange(of: phoneNumber){
                    newValue in phoneNumberValid = validatePhoneNumber(newValue)
                }
            
        }
    }
    
    func validatePhoneNumber(_ number: String) -> Bool {
        do {
            _ = try phoneNumberUtility.parse(number, withRegion:"US", ignoreType: true)
            return true
        } catch {
            return false
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
    @Binding var post: Post
    func makeUIViewController(context: Context) -> FoundPushSuccessPage {
        //TODO: do networking here, if successful, return, else return a failed page or just don't return a page?
        //TODO: should we have a review and submit page?
        //TODO: this is currently set to push to a test page
        var successful = false
        NetworkManager.shared.uploadFoundPost(post: post, userID: 1){
            success in
            print("success")
            successful = success
        }
        return FoundPushSuccessPage(success: successful, post: post)

    }
    
    func updateUIViewController(_ uiViewController: FoundPushSuccessPage, context: Context) {
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
