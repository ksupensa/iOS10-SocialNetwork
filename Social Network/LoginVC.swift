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
import SwiftKeychainWrapper

class LoginVC: UIViewController {

    @IBOutlet weak var emailField: CustomTF!
    @IBOutlet weak var passwordField: CustomTF!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let uid = KeychainWrapper.standard.string(forKey: KEY_UID){
            goToPostVC(uid)
        }
    }
    
    // Calls this function when the tap is recognized
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        dismissKeyBoard()
    }
    
    private func dismissKeyBoard(){
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
                let msg = "spencer: Facebook authentication with Firebase"
                self.successfulAuthentication(msg, user)
            } else {
                let errorMsg = "spencer: Facebook authentication failed with Firebase - \((error?.localizedDescription)!)"
                self.failedAuthentication(errorMsg, usingFacebook: true)
            }
        })
    }
    
    @IBAction func test(_ sender: CustomTF) {
        if FormatCheckers.isValidEmail(testStr: sender.text!){
            // Set focus to the text field.
            sender.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else {
            print("spencer: Invalid email format")
        }
    }
    
    @IBAction func signinBtnPressed(_ sender: CustomBtn) {
        signWithEmail()
    }
    
    @IBAction func pwdFieldRKTapped(_ sender: CustomTF) {
        signWithEmail()
    }
    
    private func signWithEmail(){
        if FormatCheckers.isValidEmail(testStr: emailField.text!) {
            if let email = emailField.text, let pwd = passwordField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: pwd) {
                    (user, error) in
                    if error == nil {
                        let msg = "spencer: Email authenticated with Firebase"
                        self.successfulAuthentication(msg, user)
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd) {
                            (user, error) in
                            if error == nil {
                                let msg = "spencer: New Email authenticated with Firebase"
                                self.successfulAuthentication(msg, user)
                            } else {
                                let errorMsg = "spencer: Email authentication failed with Firebase - \((error?.localizedDescription)!)"
                                self.failedAuthentication(errorMsg)
                            }
                        }
                    }
                }
            }
        } else {
            print("spencer: Email authentication failed - Invalid email format")
            passwordField.becomeFirstResponder()
        }
    }
    
    private func successfulAuthentication(_ message: String = "spencer: Default Success", _ user: FIRUser?){
        
        print(message + "\n")
        
        dismissKeyBoard()
        
        if let usr = user {
            let result = KeychainWrapper.standard.set(usr.uid, forKey: KEY_UID)
            print("spencer: 'Data saved in Keychain' status - \(result)")
        } else {
            print("spencer: KeychainWrapper failed since 'user' is nil")
        }
        
        goToPostVC(user?.uid)
    }
    
    private func failedAuthentication(_ message: String = "spencer: Default Fail", usingFacebook: Bool = false){
        print(message + "\n")
        
        guard usingFacebook else {
            passwordField.becomeFirstResponder()
            return
        }
    }
    
    private func goToPostVC(_ uid: String?){
        performSegue(withIdentifier: "PostVC", sender: uid)
    }
}
