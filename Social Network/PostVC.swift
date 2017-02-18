//
//  PostVC.swift
//  Social Network
//
//  Created by Spencer Forrest on 16/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit
import FirebaseAuth
import SwiftKeychainWrapper

class PostVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DataService.singleton.postRef.observe(.value, with: {
            (snapshot) in
            print("spencer: \(snapshot.value!)")
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        return cell
    }
}
