//
//  PersonDetailView.swift
//  MeetBook
//
//  Created by varun bhoir on 19/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import SwiftUI

struct PersonDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    let person: Person
    let persons: PersonViewModel
    @State private var personDeletionAlert = false
    var body: some View {
        VStack {
            self.getImage(for: person)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .shadow(color: .gray, radius: 3, x: 1, y: 3)
                .padding(.bottom)
            Text("Meeted at: ")
                .bold() +
                Text("\(FormattedDate(date: person.date))")
            if isPersonLocationPresent() {
                MapView(location: person.location!)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.top)
            } else {
                Text("Location was not recorded for this contact")
            }
            Spacer()
        }
        .padding()
        .navigationBarTitle("\(person.name)", displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.personDeletionAlert = true
        }) {
            Text("Delete")
        })
            .alert(isPresented: $personDeletionAlert) {
                return Alert(title: Text("Are you sure?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Delete"), action: {
                    self.deletePerson(person: self.person)
                    self.presentationMode.wrappedValue.dismiss()
                }))
        }
    }
    
    
    private func deletePerson(person: Person) {
        var personTodelete = [Person]()
        personTodelete.append(person)
        persons.deletePersons(personsToDelete: personTodelete)
    }
    // first get image data by the image path and then converted it into Image view
    private func getImage(for person: Person) -> Image {
        if let imageData = person.getImage(imagePath: person.imagePath) {
            if let uiImage = UIImage(data: imageData) {
                return Image(uiImage: uiImage)
            }
        }
        return Image(systemName: "person.crop.square")
    }
    
    func FormattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
        
    }
    
    func isPersonLocationPresent() -> Bool {
        if person.location != nil {
            print("location is present and is ready to pass to mapview")
            return true
        }
        print("location is not present and can't pass to mapview")
        return false
        
    }
}

struct PersonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PersonDetailView(person: Person(id: UUID(), imagePath: "", name: "varun bhoir", date: Date(), location: Person.Location(title: "Varun Bhoir", latitude: 19.076, longitude: 72.8777)), persons: PersonViewModel())
    }
}
