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
            
            //let userSnapshot = snapshot.childSnapshot(forPath: "users")
            self.observeUsers(snapshot: snapshot)
            
            self.tableView.reloadData()
        })
        
        DataService.singleton.postRef.observe(.value, with: {
            (snapshot) in
            
            //let postSnapshot = snapshot.childSnapshot(forPath: "posts")
            self.obervePosts(snapshot: snapshot)
            
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
            }
        }
    }
    
    @IBAction func signOutBtnTapped(_ sender: UIButton) {
        let keyChainResult = KeychainWrapper.standard.removeObject(forKey: KEY_UID)
        print("spencer: 'Remove uid from KeyChain' status - \(keyChainResult)")
        try! FIRAuth.auth()?.signOut()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraImgTapped(_ sender: UITapGestureRecognizer) {
        captionTxtField.placeholder = ""
        
        // Add an image to post
        present(imgPC, animated: true, completion: nil)
    }
    
    @IBAction func likeImgTapped(_ sender: UITapGestureRecognizer) {
        print("spencer: like image tapped")
    }
    
    @IBAction func addPostBtnTapped(_ sender: UIButton) {
        
        print("spencer: post btn tapped")
        
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
                        
                        //Update Post and User object in Firebase database
                        DataService.singleton.postRef.child(imgId).updateChildValues(postAttributes)
                        DataService.singleton.userRef.child(mainUserID).child("posts").updateChildValues([imgId:true])
                        
                        print("spencer: Updated imgUrl in Firebase database")
                        
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


// TableView Part
extension PostVC {
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
            cell.updateUI(postAuthor.id, postTxt: post.caption, likeNumber: post.likes, heartImg: heartImg)
            
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
    
    private func getHeartImg(postId: String) -> UIImage {
        // Does mainUser like this post ?
        var heartImg: UIImage
        
        if let mainUsrLike = mainUser.likes, mainUsrLike.contains(postId) {
            heartImg = UIImage(named: "filled-heart")!
        } else {
            heartImg = UIImage(named: "empty-heart")!
        }
        
        return heartImg
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
            //print("spencer: Firebase used to set image")
        } else {
            print("Spencer: Cell at index '\(indexPath.row)' is not available anymore")
        }
    }
}


// PickerView Part
extension PostVC {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage {
            addImg.image = img
            isDefaultCameraImg = false
        } else {
            print("spencer: Invalid image selected")
            isDefaultCameraImg = true
        }
        
        imgPC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Put back default image
        addImg.image = UIImage(named: "add-image")
        isDefaultCameraImg = true
        
        // Clear caption text and placeholder
        captionTxtField.text = ""
        captionTxtField.placeholder = ""
        
        imgPC.dismiss(animated: true, completion: nil)
    }
}










