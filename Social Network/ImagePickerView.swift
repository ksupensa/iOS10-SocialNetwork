//
//  ImagePickerView.swift
//  Social Network
//
//  Created by Spencer Forrest on 22/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

// PickerView Part
extension PostVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImg.image = img
            isDefaultCameraImg = false
        } else {
            print("spencer: Invalid image selected")
            isDefaultCameraImg = true
        }
        
        imgPC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Put back default image
        addImg.image = UIImage(named: "add-image")
        isDefaultCameraImg = true
        
        // Clear caption text and placeholder
        captionTxtField.text = ""
        captionTxtField.placeholder = ""
        
        imgPC.dismiss(animated: true, completion: nil)
    }
}
