//
//  CustomView.swift
//  Social Network
//
//  Created by Spencer Forrest on 14/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

@IBDesignable
class CustomView: UIView, ShadowDelegate {
    @IBInspectable var shadow: Bool = true {
        didSet {
            setShadow(shadow)
        }
    }
}
