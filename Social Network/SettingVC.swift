//
//  SettingVC.swift
//  Social Network
//
//  Created by Spencer Forrest on 25/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImgWidth: NSLayoutConstraint!
    @IBOutlet weak var profileImgHeight: NSLayoutConstraint!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usrNameTxtField: UITextField!
    
    private var _profileImgWidth = NSLayoutConstraint()
    private var _profileImgHeight = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        _profileImgWidth = profileImgWidth
        _profileImgHeight = profileImgHeight
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingVC.keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingVC.keyboardWillHideNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
        print("spencer: Keyboard showing")
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
        print("spencer: Keyboard hiding")
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        
        // Substract the max Y of the view with min Y of the KeyboardFrame
        bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        
        updateLayoutConstraints()
        
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        let viewAnimationCurve = UIViewAnimationCurve(rawValue: rawAnimationCurve)!
        let animationCurve = FormatCheckers.animationOptionsWithCurve(curve: viewAnimationCurve)
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState, animationCurve],animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // Update profile image constraints on height and width
    private func updateLayoutConstraints(){
        if let _ = profileImgWidth, let _ = profileImgHeight {
            let constraints = [_profileImgWidth, _profileImgHeight]
            
            if profileImg.constraints.contains(_profileImgWidth) && profileImg.constraints.contains(_profileImgWidth) {
                profileImg.removeConstraints(constraints)
                print("spencer: Constraints removed")
            } else {
                profileImg.addConstraints(constraints)
                print("spencer: Constraints added")
            }
        }
    }
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
        //alertMessage("Profile Image", "You cliked on it")
        print("spencer: You Clicked on Profile Image")
    }
    
    @IBAction func mainViewTapped(_ sender: UITapGestureRecognizer) {
        dismissKeayboard()
    }
    
    private func dismissKeayboard(){
        view.endEditing(true)
    }
    
    // For testing purposed only
    private func alertMessage(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
