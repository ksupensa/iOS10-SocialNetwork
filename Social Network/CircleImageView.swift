//
//  CircleImageView.swift
//  Social Network
//
//  Created by Spencer Forrest on 16/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

@IBDesignable
class CircleImageView: UIImageView, CircleDelegate, ShadowDelegate {
    @IBInspectable var circle: Bool = true {
        didSet{
            setCircle(circle)
        }
    }
    
    @IBInspectable var shadow: Bool = true {
        didSet{
            setShadow(shadow)
        }
    }
}
