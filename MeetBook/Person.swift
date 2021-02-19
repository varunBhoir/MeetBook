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
    
    mutating func setImage(image: Data) {
        imagePath = ImageUtilities().setImage(image: image)
    }
    
    func getImage(imagePath: String?) -> Data? {
        return ImageUtilities().getImage(imagePath: imagePath)
    }
    
    func removeImage(imagePath: String?) {
        ImageUtilities().removeImage(imagePath: imagePath)
    }
    
    
    
    static func < (lhs: Person, rhs: Person) -> Bool {
        lhs.date < rhs.date
    }
}



