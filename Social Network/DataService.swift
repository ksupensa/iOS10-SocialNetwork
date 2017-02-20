//
//  DataService.swift
//  Social Network
//
//  Created by Spencer Forrest on 18/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    static let singleton = DataService()
    
    // Cache for images
    var imgCache: NSCache<NSString, UIImage> = NSCache()
    
    private let _POST_REF = DB_REF.child("posts")
    private let _USER_REF = DB_REF.child("users")
    private let _IMG_REF = STORAGE_REF.child("post-img")
    private let _FACE_REF = STORAGE_REF.child("user-img")
    
    var dbRef: FIRDatabaseReference {
        return DB_REF
    }
    
    var userRef: FIRDatabaseReference {
        return _USER_REF
    }
    
    var postRef: FIRDatabaseReference {
        return _POST_REF
    }
    
    var strRef: FIRStorageReference {
        return STORAGE_REF
    }
    
    func createDBUser(uid: String, usrData: [String:String]) {
       userRef.child("\(uid)").updateChildValues(usrData)
    }
    
    func createPostImg(){
        
    }
    
    func createUsrImg(){
        
    }
}

// Trying to implement a FecthController
extension DataService {
    
}
