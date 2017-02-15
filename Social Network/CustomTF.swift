//
//  CustomTF.swift
//  Social Network
//
//  Created by Spencer Forrest on 15/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

@IBDesignable
class CustomTF: UITextField {
    
    private var insetX: CGFloat = 0
    private var insetY: CGFloat = 0
    
    @IBInspectable var customField: Bool = true {
        didSet {
            if customField {
                layer.borderColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 0.2).cgColor
                layer.borderWidth = 1.0
                insetX = 10
                insetY = 3
            }
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
}
