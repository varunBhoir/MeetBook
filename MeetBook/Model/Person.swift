//
//  Person.swift
//  MeetBook
//
//  Created by varun bhoir on 16/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import Foundation

struct Person: Codable, Identifiable, Comparable {
    
    var id = UUID()
    var imagePath: String?
    var name: String
    var date: Date
    var location: Location?
    
    mutating func setImage(image: Data) {
        imagePath = ImageUtilities().setImage(image: image)
    }
    
    func getImage(imagePath: String?) -> Data? {
        return ImageUtilities().getImage(imagePath: imagePath)
    }
    
    func removeImage(imagePath: String?) {
        ImageUtilities().removeImage(imagePath: imagePath)
    }
    
    mutating func setLocation(title: String, latitude: Double, longitude: Double) {
        location = LocationUtilities().setLocation(title: title, latitude: latitude, longitude: longitude)
    }
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.date < rhs.date
    }
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    struct Location: Codable {
        var title: String
        var latitude: Double
        var longitude: Double
    }
}
