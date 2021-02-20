//
//  LocationUitilities.swift
//  MeetBook
//
//  Created by varun bhoir on 20/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import Foundation

struct LocationUtilities {
    func setLocation(title: String, latitude: Double, longitude: Double) -> Person.Location {
        return Person.Location(title: title, latitude: latitude, longitude: longitude)
    }
}
