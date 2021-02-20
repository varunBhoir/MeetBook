//
//  ImagePicker.swift
//  MeetBook
//
//  Created by varun bhoir on 16/02/21.
//  Copyright © 2021 varun bhoir. All rights reserved.
//
import SwiftUI
import Foundation

enum ImageSourceType {
    case camera, library
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    var sourceType: ImageSourceType = .library
    
    static func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            parent.image = image
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        switch sourceType {
        case .library:
            imagePicker.sourceType = .photoLibrary
        case .camera:
            // camera only if available, otherwise use photo library
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePicker.sourceType = .camera
            } else {
                imagePicker.sourceType = .photoLibrary
            }
        }
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
}
