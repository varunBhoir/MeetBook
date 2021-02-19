//
//  PersonsViewModel.swift
//  MeetBook
//
//  Created by varun bhoir on 17/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import Foundation

class PersonViewModel: ObservableObject {
    @Published var persons = [Person]().sorted() {
        didSet {
            saveData()
        }
    }
    
    // add new person to the persons array
    func add(person: Person) {
        if let index = persons.firstIndex(where: {
            $0.name > person.name
        }) {
            persons.insert(person, at: index)
        }
        else {
            persons.append(person)
        }
    }
    
    
    init() {
        loadData()
    }
    
    // to delete a person from the permanent storage and persons array
    func deletePersons(personsToDelete: [Person]) {
        for (index, person) in persons.enumerated() {
            if personsToDelete.contains(person) {
                person.removeImage(imagePath: person.imagePath)
                persons.remove(at: index)
            }
        }
    }
    
    
    // save the person into permanent storage
    func saveData() {
        let fileName = ImageUtilities().getDocumentsDirectory().appendingPathComponent("SavedPersons")
        do {
            let data = try JSONEncoder().encode(persons)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        }
        catch {
            print("Unable to save persons")
        }
    }
    
    // load persons array from the permanent storage
    func loadData() {
        let fileName = ImageUtilities().getDocumentsDirectory().appendingPathComponent("SavedPersons")
        do {
            let data = try Data(contentsOf: fileName)
            persons = try JSONDecoder().decode([Person].self, from: data)
        }
        catch {
            print("Unable to load persons")
        }
    }
    
    
}
