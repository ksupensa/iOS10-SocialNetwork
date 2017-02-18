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

    private let _POST_REF = DB_REF.child("posts")
    private let _USER_REF = DB_REF.child("users")
    
    var dbRef: FIRDatabaseReference {
        return DB_REF
    }
    
    var userRef: FIRDatabaseReference {
        return _USER_REF
    }
    
    var postRef: FIRDatabaseReference {
        return _POST_REF
    }
    
    func createDBUser(uid: String, usrData: [String:String]) {
       userRef.child("\(uid)").updateChildValues(usrData)
    }
}
