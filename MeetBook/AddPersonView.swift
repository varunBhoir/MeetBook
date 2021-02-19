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
    @State private var blankPersonNameAlert = false
    @State var image: Image?
    @State var inputImage: UIImage?
    
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
                    
                    Button(action: {
                        self.showImagePickerSheet = true
                    }) {
                        Text("Select image")
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
            ImagePicker(image: self.$inputImage)
        }
        .alert(isPresented: $blankPersonNameAlert) {
            Alert(title: Text("Please provide a Person name"))
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
//        guard !self.personName.isEmpty else {
//            self.blankPersonNameAlert = true
//            return
//        }
        guard isPersonNameLegal(personName: personName) else {
            self.blankPersonNameAlert = true
            return
        }
        var person = Person(name: personName, date: Date())
        if let inputImage = inputImage {
            if let jpegData = inputImage.jpegData(compressionQuality: 0.8) {
                person.setImage(image: jpegData)
            }
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
}

struct AddPersonView_Previews: PreviewProvider {
    static var previews: some View {
        AddPersonView(persons: PersonViewModel(), image: Image(systemName: "person.crop.square"))
    }
}
