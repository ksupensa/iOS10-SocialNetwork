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
    private var _name: String!
    private var _posts: [String]?
    private var _likes: [String]?
    private var _imgUrl: String?
    
    var id: String {
        get {
            return _id
        }
    }
    
    var name: String {
        return _name
    }
    
    var posts: [String]? {
        return _posts
    }
    
    var imgUrl: String? {
        return _imgUrl
    }
    
    var likes: [String]? {
        return _likes
    }
    
    init(name: String, posts: [String], imgUrl: String, likes: [String]) {
        _name = name
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
    
    private func setUser(postData: [String:AnyObject]){
        
        if let posts = postData[POST] as? [String:Bool] {
            var temp = [String]()
            
            for (key,_) in posts {
                temp.append(key)
            }
            
            _posts = temp
        }
        
        if let likes = postData[LIKE] as? [String:Bool] {
            var temp = [String]()
            
            for (key,_) in likes {
                temp.append(key)
            }
            
            _likes = temp
        }
        
        if let imgUrl = postData[IMG_URL] as? String {
            _imgUrl = imgUrl
        }
        
        if let name = postData[NAME] as? String {
            _name = name
        }
    }
}
