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
    
    internal var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DataService.singleton.postRef.observe(.value, with: {
            (snapshot) in
            
            if let snaps = snapshot.children.allObjects as? [FIRDataSnapshot] {
                // Clear older posts
                self.posts = []
                
                for data in snaps {
                    if let postContent = data.value as? [String:AnyObject] {
                        let id = data.key
                        let post = Post(id: id, postData: postContent)
                        self.posts.append(post)
                    }
                }
                self.tableView.reloadData()
            }
        })
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        return cell
    }
}
