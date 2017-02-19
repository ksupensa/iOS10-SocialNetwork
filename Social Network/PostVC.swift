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

class PostVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    // mainUser is initialized in LoginVC using the "PostVC" segue
    internal var mainUser: User!
    
    internal var posts = [Post]()
    internal var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DataService.singleton.dbRef.observe(.value, with: {
            (snapshot) in
            
            print("\nspencer: Main user id - \(self.mainUser.id)")
            
            let userSnapshot = snapshot.childSnapshot(forPath: "users")
            self.observeUsers(snapshot: userSnapshot)
            
            let postSnapshot = snapshot.childSnapshot(forPath: "posts")
            self.obervePosts(snapshot: postSnapshot)
            
            self.tableView.reloadData()
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
        }
    }
    
    private func obervePosts(snapshot: FIRDataSnapshot){
        if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
            // Clear older posts
            self.posts = []
            
            // Check if mainUser can access at least one post
            if let userPost = self.mainUser.posts {
                for data in snaps {
                    if let postContent = data.value as? [String:AnyObject] {
                        let id = data.key
                        
                        // If post not for MainUser go to next one
                        if userPost.contains(id){
                            
                            let post = Post(id: id, postData: postContent)
                            self.posts.append(post)
                        }
                    }
                }
            } else {
                return
            }
        }
    }
    
    @IBAction func signOutBtnTapped(_ sender: UIButton) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("spencer: 'Remove uid from KeyChain' status - \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        // Change Like Img + Like Score
    }
}

extension PostVC {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        print("spencer: \(post.caption)")
        
        // Look for the post author
        var postAuthor: User = mainUser
        for user in users {
            if user.id == post.senderId {
                postAuthor = user
            }
        }
        
        // Does mainUser like this post ?
        var heartImg: UIImage
        
        if let mainUsrLike = mainUser.likes, mainUsrLike.contains(post.id) {
            heartImg = UIImage(named: "filled-heart")!
        } else {
            heartImg = UIImage(named: "empty-heart")!
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            
            cell.updateUI(postAuthor.id, postTxt: post.caption, likeNumber: post.likes, profileImg: UIImage(), likeImg: heartImg, postImg: UIImage())
            
            return cell
        }
        
        return PostCell()
    }
}
