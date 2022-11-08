//
//  ImageUploader.swift
//  JacketStash_PROD
//
//  Created by Adam Yao on 11/7/22.
//

import FirebaseStorage
import UIKit


struct ImageUploader {
    static func uploadImage(image: UIImage, completion: @escaping(String) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {return}
        
        let filename = NSUUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
                
        ref.putData(imageData) { _, error in
            if let error = error {
                print("DEBUG: failed to upload image with error: \(error.localizedDescription)")
                
            }
            
            ref.downloadURL { imageUrl, _ in
                guard let imageUrl = imageUrl?.absoluteString else {return}
                completion(imageUrl)
            }
            
        }
    }
}


