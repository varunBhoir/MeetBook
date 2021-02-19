//
//  ContentView.swift
//  MeetBook
//
//  Created by varun bhoir on 16/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var persons = PersonViewModel()
    @State private var showAddPersonSheet = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(persons.persons, id: \.id) { person in
                    NavigationLink(destination: PersonDetailView(person: person, persons: self.persons)) {
                        HStack {
                            self.getImage(for: person)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .shadow(radius: 2)
                            Spacer()
                            Text(person.name)
                        }
                    }
                }
                .onDelete(perform: deletePerson)
            }
            .navigationBarTitle("MeetBook")
            .navigationBarItems(trailing: Button(action: {
                self.showAddPersonSheet = true
            }) {
                Image(systemName: "plus")
                    // increase tapable area
                    .padding(15)
            })
        }
        .sheet(isPresented: $showAddPersonSheet) {
            AddPersonView(persons: self.persons)
        }
    }
    
    
    // to delete persons
    func deletePerson(offsets: IndexSet) {
        var personsToDelete = [Person]()
        for offset in offsets {
            personsToDelete.append(persons.persons[offset])
        }
        persons.deletePersons(personsToDelete: personsToDelete)
    }
    
    // first get image data by the image path and then converted it into Image view
    func getImage(for person: Person) -> Image {
        if let imageData = person.getImage(imagePath: person.imagePath) {
            if let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        }
        return Image(systemName: "person.crop.square")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
