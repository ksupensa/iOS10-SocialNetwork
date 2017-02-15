//
//  LoginVC.swift
//  Social Network
//
//  Created by Spencer Forrest on 13/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit
import FirebaseAuth
import FacebookLogin

class LoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not to interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func facebookBtnPressed(_ sender: FacebookBtn) {
        let fbLoginManager = LoginManager()
        
        fbLoginManager.logIn([.email], viewController: self) {
            (loginResult) in
            
            print("")
            
            switch loginResult {
            case .failed(let error):
                print(error)
                break
            case .cancelled:
                print("spencer: User cancelled login.")
                break
            case .success( _, _, let accessToken):
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
                self.firebaseAuth(credential)
                break
            }
        }
    }
    
    private func firebaseAuth(_ credentials: FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error == nil {
                print("spencer: Sucessful authentication with Firebase")
            } else {
                print("spencer: Unable to authenticate with Firebase - \(error.debugDescription)")
            }
        })
    }
}

