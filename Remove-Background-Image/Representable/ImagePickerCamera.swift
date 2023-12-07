//
//  ImagePickerCamera.swift
//  Remove-Background-Image
//
//  Created by Melih Çulha on 7.12.2023.
//

import Foundation
import SwiftUI

struct ImagePickerCamera: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController

    @Binding var image: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = context.coordinator
        imagePicker.allowsEditing = false
        return imagePicker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        let parent: ImagePickerCamera
        
        init(_ parent: ImagePickerCamera) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            self.parent.image = selectedImage
            picker.dismiss(animated: true)
        }
    }
}
