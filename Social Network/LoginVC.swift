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
    
    @IBOutlet weak var bodyViewBottomLC: NSLayoutConstraint!
    @IBOutlet weak var fbHeightLC: NSLayoutConstraint!
    @IBOutlet weak var titleHeightLC: NSLayoutConstraint!
    @IBOutlet weak var orHeightLC: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let uid = KeychainWrapper.standard.string(forKey: KEY_UID){
            goToPostVC(uid)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardShowing(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginVC.keyboardHiding(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShowing(_ notification: NSNotification){
        
        UIView.animate(withDuration: 0.25) {
            self.fbHeightLC.constant = 0
            self.titleHeightLC.constant = 0
            self.orHeightLC.constant = 0
            self.view.updateConstraints()
        }
        
        keyboardAppearance(notification)
    }
    
    func keyboardHiding(_ notification: NSNotification){
        UIView.animate(withDuration: 0.25) {
            self.fbHeightLC.constant = 100
            self.titleHeightLC.constant = 22
            self.orHeightLC.constant = 22
            self.view.updateConstraints()
        }
        
        keyboardAppearance(notification)
    }
    
    // Break up this one in different functionned used differently if Keyboard Shows or Hide
    private func keyboardAppearance(_ notification: NSNotification){
        let userInfo = notification.userInfo!
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        
        // Update size of bodyView layout
        bodyViewBottomLC.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        
        // Update HeaderView
        // headerView.isHidden = !headerView.isHidden
        
        let rawAnimationCurve = (userInfo[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        let viewAnimationCurve = UIViewAnimationCurve(rawValue: rawAnimationCurve)!
        let animationCurve = FormatCheckers.animationOptionsWithCurve(curve: viewAnimationCurve)
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState,animationCurve], animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Calls this function when the tap is recognized
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Dismiss the keyboard
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
                self.successfulAuthentication(msg, user, provider: credentials.provider)
            } else {
                let errorMsg = "spencer: Facebook authentication failed with Firebase - \((error?.localizedDescription)!)"
                self.failedAuthentication(errorMsg, usingFacebook: true)
            }
        })
    }
    
    @IBAction func checkEmailFormat(_ sender: CustomTF) {
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
                        self.successfulAuthentication(msg, user, provider: (user?.providerID)!)
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: pwd) {
                            (user, error) in
                            if error == nil {
                                let msg = "spencer: New Email authenticated with Firebase"
                                self.successfulAuthentication(msg, user, provider: (user?.providerID)!)
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
    
    private func successfulAuthentication(_ message: String = "spencer: Default Success", _ user: FIRUser?, provider: String){
        
        print(message + "\n")
        
        dismissKeyBoard()
        emailField.text = ""
        passwordField.text = ""
        
        if let usr = user {
            let result = KeychainWrapper.standard.set(usr.uid, forKey: KEY_UID)
            print("spencer: 'Data saved in Keychain' status - \(result)")
        } else {
            print("spencer: KeychainWrapper failed since 'user' is nil")
        }
        
        print("spencer: uid - \((user?.uid)!)")
        
        DataService.singleton.createDBUser(uid: (user?.uid)!, usrData: ["provider": provider])
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Create mainUser and pass it to PostVC
        if segue.identifier == "PostVC" {
            if let destination = segue.destination as? PostVC {
                if let uid = sender as? String {
                    destination.mainUser = User(id: uid)
                }
            }
        }
    }
}
