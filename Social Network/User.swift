//
//  User.swift
//  Social Network
//
//  Created by Spencer Forrest on 19/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import Foundation

class User {
    
    private var _id: String!
    private var _posts: [String]?
    private var _likes: [String]?
    private var _imgUrl: String?
    
    var id: String {
        get {
            return _id
        }
    }
    
    var posts: [String]? {
        get {
            return _posts
        }
    }
    
    var imgUrl: String? {
        get {
            return _imgUrl
        }
    }
    
    var likes: [String]? {
        get {
            return _likes
        }
    }
    
    init(posts: [String], imgUrl: String, likes: [String]) {
        _posts = posts
        _imgUrl = imgUrl
        _likes = likes
    }
    
    init(id: String, postData: [String:AnyObject] = [:]){
        _id = id
        
        if !postData.isEmpty {
            setUser(postData: postData)
        }
    }
    
    func setUser(postData: [String:AnyObject]){
        
        if let posts = postData["posts"] as? [String:Bool] {
            var temp = [String]()
            
            for (key,_) in posts {
                temp.append(key)
            }
            
            _posts = temp
        }
        
        if let likes = postData["likes"] as? [String:Bool] {
            var temp = [String]()
            
            for (key,_) in likes {
                temp.append(key)
            }
            
            _likes = temp
        }
        
        if let imgUrl = postData["imgUrl"] as? String {
            _imgUrl = imgUrl
        }
    }
}
