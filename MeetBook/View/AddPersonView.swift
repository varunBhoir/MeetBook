//
//  AddPersonView.swift
//  MeetBook
//
//  Created by varun bhoir on 17/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import SwiftUI

struct AddPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var persons: PersonViewModel
    @State private var personName = ""
    @State private var showImagePickerSheet = false
    @State var image: Image?
    @State var inputImage: UIImage?
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var imageSourceType: ImageSourceType = .library
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Photo")) {
                    if image != nil {
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: [5,5]))
                            .scaledToFit()
                    }
                    HStack {
                        Text("Take new...")
                            .onTapGesture(perform: takePicture)
                        Spacer()
                        Text("Select existing...")
                            .onTapGesture(perform: selectPhoto)
                    }
                }
                Section(header: Text("Name")) {
                    TextField("Name of the Person", text: $personName)
                }
            }
            .navigationBarTitle("Add Person")
            .navigationBarItems(trailing: Button(action: {
                self.addPerson()
            }) {
                Text("Add")
            })
        }
        .sheet(isPresented: $showImagePickerSheet, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage, sourceType: self.imageSourceType)
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text(self.errorMessage))
        }
    }
    
    
    
    func loadImage() {
        guard let inputImage = inputImage else {
            print("Image is not selected by user")
            return
        }
        image = Image(uiImage: inputImage)
    }
    
    func addPerson() {
        guard isPersonNameLegal(personName: personName) else {
            self.showingErrorAlert = true
            self.errorMessage = "Please provide a Person name"
            return
        }
        
        var person = Person(name: personName, date: Date())
        if let inputImage = inputImage {
            if let jpegData = inputImage.jpegData(compressionQuality: 0.8) {
                person.setImage(image: jpegData)
            }
        }
        if let fetchedLocation = fetchLocation() {
            person.setLocation(title: personName, latitude: fetchedLocation.latitude, longitude: fetchedLocation.longitude)
        }
        self.persons.add(person: person)
        presentationMode.wrappedValue.dismiss()
    }
    
    // check for blank person name 
    func isPersonNameLegal(personName: String) -> Bool {
        if personName.trimmingCharacters(in: .whitespaces).isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func fetchLocation() -> (latitude: Double, longitude: Double)? {
        let locationFetcher = LocationFetcher()
        locationFetcher.start()
        if let location = locationFetcher.lastKnownLocation {
            print(location)
            return (Double(location.latitude), Double(location.longitude))
        } else {
            print("location fetching failed")
            return nil
        }
    }
    
    func takePicture() {
        if ImagePicker.isCameraAvailable() {
            self.imageSourceType = .camera
            self.showImagePickerSheet = true
            
        }
        else {
            errorMessage = "Camera is not available"
            showingErrorAlert = true
        }
    }
    
    func selectPhoto() {
        self.imageSourceType = .library
        self.showImagePickerSheet = true
    }
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView(persons: PersonViewModel(), image: Image(systemName: "person.crop.square"))
    }
}
