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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(SettingVC.keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(SettingVC.keyboardWillShowNotification(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification: notification)
    }
    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        let userInfo = notification.userInfo!
        
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let convertedKeyboardEndFrame = view.convert(keyboardEndFrame, from: view.window)
        
        // Substract the max Y of the view with min Y of the KeyboardFrame
        bottomLayoutConstraint.constant = view.bounds.maxY - convertedKeyboardEndFrame.minY
        
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue
        let viewAnimationCurve = UIViewAnimationCurve(rawValue: rawAnimationCurve)!
        let animationCurve = FormatCheckers.animationOptionsWithCurve(curve: viewAnimationCurve)
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: [UIViewAnimationOptions.beginFromCurrentState, animationCurve],animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func profilePictureTapped(_ sender: UITapGestureRecognizer) {
        alertMessage("Profile Image", "You cliked on it")
    }
    
    @IBAction func mainViewTapped(_ sender: UITapGestureRecognizer) {
        dismissKeayboard()
    }
    
    private func dismissKeayboard(){
        view.endEditing(true)
    }
    
    private func alertMessage(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
