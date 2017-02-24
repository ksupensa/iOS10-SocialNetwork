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
    
    private let _POST_REF = DB_REF.child(POST)
    private let _USER_REF = DB_REF.child(USER)
    private let _POST_STR_REF = STORAGE_REF.child(POST_IMG)
    private let _USER_STR_REF = STORAGE_REF.child(USER_IMG)
    
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
    
    var userImgStrRef: FIRStorageReference {
        return _USER_STR_REF
    }

    var postImgStrRef: FIRStorageReference {
        return _POST_STR_REF
    }
    
    func createDBUser(uid: String, usrData: [String:String]) {
       userRef.child("\(uid)").updateChildValues(usrData)
    }
    
    func uploadPostImage(name: String, data: Data, metadata: FIRStorageMetadata, completed: @escaping (FIRStorageMetadata?, Error?) -> Void) {
        postImgStrRef.child(name).put(data, metadata: metadata) {
            (meta, error) in
            completed(meta, error)
        }
    }
    
    func uploadUserImage(name: String, data: Data, metadata: FIRStorageMetadata, completed: @escaping (FIRStorageMetadata?, Error?) -> Void) {
        userImgStrRef.child(name).put(data, metadata: metadata) {
            (meta, error) in
            completed(meta, error)
        }
    }
}
