//
//  PostVC.swift
//  Social Network
//
//  Created by Spencer Forrest on 16/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var captionTxtField: UITextField!
    @IBOutlet weak var addImg: CircleImageView!
    @IBOutlet weak var tableView: UITableView!
    
    // mainUser is initialized in LoginVC using the "PostVC" segue
    internal var mainUser: User!
    internal var posts = [Post]()
    
    internal var allPosts = [Post]()
    internal var users = [User]()
    
    // Check if default image for adding post
    internal var isDefaultCameraImg = true
    
    var imgPC: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        imgPC = UIImagePickerController()
        imgPC.allowsEditing = true
        imgPC.delegate = self
        
        DataService.singleton.userRef.observe(.value, with: {
            (snapshot) in
            
            print("spencer: 'Users' oberver triggered")
            
            self.observeUsers(snapshot: snapshot)
        })
        
        DataService.singleton.postRef.observe(.value, with: {
            (snapshot) in
            
            print("spencer: 'Post' oberver triggered")
            
            self.obervePosts(snapshot: snapshot)
        })
    }
    
    private func observeUsers(snapshot: FIRDataSnapshot){
        if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
            // Clear older users
            self.users = []
            
            for data in snaps {
                if let userContent = data.value as? [String:AnyObject] {
                    
                    let id = data.key
                    let user = User(id: id, postData: userContent)
                    
                    // Update mainUser
                    if id == self.mainUser.id {
                        self.mainUser = user
                    } else {
                        self.users.append(user)
                    }
                }
            }
            
            // Cleared Posts
            self.posts = []
            
            // Add Posts
            if let userPosts = self.mainUser.posts {
                
                for post in self.allPosts {
                    if userPosts.contains(post.id) {
                       self.posts.append(post)
                    }
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func obervePosts(snapshot: FIRDataSnapshot){
        if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
            // Clear older posts
            self.posts = []
            self.allPosts = []
            
            // Check if mainUser can access at least one post
            if let userPost = self.mainUser.posts {
                for data in snaps {
                    if let postContent = data.value as? [String:AnyObject] {
                        let id = data.key
                        
                        // Append into allPosts[Post]
                        let post = Post(id: id, postData: postContent)
                        self.allPosts.append(post)
                        
                        // If post not for MainUser go to next one
                        if userPost.contains(id){
                            self.posts.append(post)
                        }
                    }
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func signOutBtnTapped(_ sender: UIButton) {
        // Remove all Firebase database obervers before logging out
        DataService.singleton.dbRef.removeAllObservers()
        DataService.singleton.userRef.removeAllObservers()
        DataService.singleton.postRef.removeAllObservers()
        
        // Remove UID from Keychain
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("spencer: 'Remove uid from KeyChain' status - \(keyChainResult)")
        
        // Sign out Firebase
        try! FIRAuth.auth()?.signOut()
        
        // Go back to LoginVC
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraImgTapped(_ sender: UITapGestureRecognizer) {
        captionTxtField.placeholder = ""
        
        // Add an image to post
        present(imgPC, animated: true, completion: nil)
    }
    
    @IBAction func addPostBtnTapped(_ sender: UIButton) {
        
        if isDefaultCameraImg {
            captionTxtField.placeholder = "Please select first an image"
        } else {
            if captionTxtField.text == "" {
                captionTxtField.placeholder = "Write caption for the image"
            } else {
                // Submit post and image
                pushPostToFirebase(image: addImg.image!, caption: captionTxtField.text!, mainUserID: mainUser.id)
            }
        }
    }
    
    private func pushPostToFirebase(image: UIImage, caption: String, mainUserID: String) {
        print("spencer: Pushing post to Firebase")
        
        if let imgData = UIImageJPEGRepresentation(image, 0.2) {
            let imgId = NSUUID().uuidString
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpeg"
            
            // Upload Post image to Firebase storage
            DataService.singleton.uploadPostImage(name: imgId, data:imgData, metadata: metaData, completed: {
                (metaData, error) in
                if error == nil {
                    
                    print("spencer: Uploaded post image to Firebase storage")
                    
                    if let downloadUrl = metaData?.downloadURL()?.absoluteString {
                        
                        var postAttributes = [String:AnyObject]()
                        postAttributes["imgUrl"] = downloadUrl as AnyObject?
                        postAttributes["caption"] = caption as AnyObject?
                        postAttributes["senderId"] = mainUserID as AnyObject?
                        postAttributes["likes"] = 0 as AnyObject?
                        
                        //Update Post object in Firebase database
                        DataService.singleton.postRef.child(imgId).updateChildValues(postAttributes, withCompletionBlock: {
                            error, postRef in
                            
                            if error == nil {
                                print("spencer: New post added into Firebase database")
                                
                                //Update User object in Firebase database
                                let userPosts = DataService.singleton.userRef.child(mainUserID).child("posts")
                                userPosts.updateChildValues([imgId:true],  withCompletionBlock: {
                                    error, postRef in
                                    
                                    if error == nil {
                                        print("spencer: User.imgUrl added into Firebase database")
                                        
                                    } else {
                                        print("spencer: Failed to add User.imgUrl into Firebase database")
                                    }
                                })
                                
                            } else {
                                print("spencer: Failed to add new post into Firebase database")
                            }
                        })
                        
                        // Update UI for next post
                        self.addImg.image = UIImage(named: "add-image")
                        self.captionTxtField.text = ""
                        self.dismissKeyboard()
                    }
                    
                } else {
                    print("spencer: Problem uploading post image to Firebase storage")
                }
            })
        }
    }
    
    private func dismissKeyboard(){
        view.endEditing(true)
    }
}










