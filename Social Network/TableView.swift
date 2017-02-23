//
//  TableViewProtocoles.swift
//  Social Network
//
//  Created by Spencer Forrest on 22/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit
import Firebase

// TableView Part
extension PostVC: PostCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            // Get the right post
            let post = posts[indexPath.row]
            
            // Look for the author of the post
            var postAuthor: User = mainUser
            for user in users {
                if user.id == post.senderId {
                    postAuthor = user
                }
            }
            
            // Get the right heartImg if main user like the post
            let heartImg = getHeartImg(postId: post.id)
            
            // Set all the already known pieces of Information
            cell.updateUI(postAuthor.name, postTxt: post.caption, likeNumber: post.likes, heartImg: heartImg)
            cell.setId(post.id)
            cell.delegate = self
            
            // Set the picture of the post in the cell
            setImagInCell(cell: cell, indexPath: indexPath, url: post.imgUrl, imgType: .post)
            
            // Set the picture of the author in the cell
            if let authorUrl = postAuthor.imgUrl{
                setImagInCell(cell: cell, indexPath: indexPath, url: authorUrl, imgType: .user)
            }
            
            return cell
        }
        
        return PostCell()
    }
    
    // PostCellDelegate function: Required
    func likeImgTapped(_ postId: String) {
        
        let dbMainUser = DataService.singleton.userRef.child(mainUser.id)
        
        if mainUserLikePost(postId) {
            dbMainUser.child("likes").child(postId).removeValue()
            print("spencer: Unlike picture")
        } else {
            dbMainUser.child("likes").updateChildValues([postId:true])
            print("spencer: like picture")
        }
    }
    
    private func getHeartImg(postId: String) -> UIImage {
        return mainUserLikePost(postId) ? UIImage(named: "filled-heart")! : UIImage(named: "empty-heart")!
    }
    
    private func mainUserLikePost(_ postId: String) -> Bool {
         if let mainUsrLike = mainUser.likes, mainUsrLike.contains(postId) {
            return true
         } else {
            return false
        }
    }
    
    private func setImagInCell(cell: PostCell, indexPath: IndexPath, url: String, imgType: ImageType){
        // Cache used for Downloaded picures
        let cache = DataService.singleton.imgCache
        
        // Set images if already in cache
        if let img = cache.object(forKey: url as NSString) {
            switch imgType {
            case .post:
                cell.setPostImg(img: img)
            case .user:
                cell.setUsrImage(img: img)
            }
            //print("spencer: Cache used to set image")
        } else {
            // Download images if not
            //print("spencer: Downloading image")
            downloadImg(indexPath: indexPath, imgUrl: url, imgType: imgType)
        }
    }
    
    private func downloadImg(indexPath: IndexPath, imgUrl: String?, imgType: ImageType) {
        
        let cache = DataService.singleton.imgCache
        
        // Check first if url exists
        if let url = imgUrl {
            // Download image from Firebase
            let ref = FIRStorage.storage().reference(forURL: url)
            ref.data(withMaxSize: 2 * 1024 * 1024, completion: {
                data, error in
                
                if error == nil {
                    if let imgData = data {
                        
                        if let img = UIImage(data: imgData) {
                            // Update Cell if still available
                            self.updateCellUI(indexPath: indexPath, img: img, imgType: imgType)
                            
                            // Put image in cache
                            cache.setObject(img, forKey: url as NSString)
                            //print("spencer: Downloaded Image put in Cache")
                        }
                    }
                } else {
                    print("spencer: Failed to Download image from Firebase Storage")
                }
            })
        }
    }
    
    private func updateCellUI(indexPath: IndexPath, img: UIImage, imgType: ImageType){
        
        // Image updated if cell still available
        if let cell = tableView.cellForRow(at: indexPath) as? PostCell {
            switch imgType {
            case .post:
                cell.setPostImg(img: img)
            case .user:
                cell.setUsrImage(img: img)
            }
        } else {
            print("Spencer: Cell at index '\(indexPath.row)' is not available anymore")
        }
    }
}
