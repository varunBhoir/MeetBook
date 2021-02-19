//
//  ImageUtilities.swift
//  MeetBook
//
//  Created by varun bhoir on 16/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//

import Foundation

struct ImageUtilities {
    
    func setImage(image: Data) -> String? {
        let url = getDocumentsDirectory().appendingPathComponent(UUID().uuidString)
        
        do {
            try image.write(to: url, options: [.atomicWrite, .completeFileProtection])
            return url.lastPathComponent
        }
        catch {
            print("Could not write: \(error.localizedDescription)")
        }
        return nil
        
    }
    
    func getImage(imagePath: String?) -> Data? {
        guard let imagePath = imagePath else {
            print("Image path is not present")
            return nil
        }
        
        let url = getDocumentsDirectory().appendingPathComponent(imagePath)
        do {
            let data = try Data(contentsOf: url)
            return data
        }
        catch {
            print("Unable to convert into data or there is data found")
        }
        return nil
    }
    
    func removeImage(imagePath: String?) {
        guard let imagePath = imagePath else {
            print("image path is not present to delete an image/ person")
            return
        }
        let url = getDocumentsDirectory().appendingPathComponent(imagePath)
        do {
            try FileManager.default.removeItem(at: url)
        }
        catch {
            print("Unable to delete an image: \(error.localizedDescription)")
        }
    }
    
    
    
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
