//
//  CustomBtn.swift
//  Social Network
//
//  Created by Spencer Forrest on 15/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

@IBDesignable
class CustomBtn: UIButton, ShadowDelegate {

    @IBInspectable var customButton: Bool = true {
        didSet{
            setShadow(customButton)
            
            layer.cornerRadius = customButton ? self.frame.width / 50 : 0
        }
    }
}
