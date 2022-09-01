//
//  ImagePicker.swift
//  Recipe App
//
//  Created by Ali Earp on 01/09/2022.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    var selectedSource: UIImagePickerController.SourceType
    
    @Binding var recipeImage: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = context.coordinator
        
        if UIImagePickerController.isSourceTypeAvailable(selectedSource) {
            imagePickerController.sourceType = selectedSource
        }
        
        return imagePickerController
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.recipeImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
