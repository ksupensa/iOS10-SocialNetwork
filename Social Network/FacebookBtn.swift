//
//  FacebookBtn.swift
//  Social Network
//
//  Created by Spencer Forrest on 15/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

@IBDesignable
class FacebookBtn: UIButton, ShadowDelegate {
    
    @IBInspectable var shadow: Bool = true {
        didSet {
            setShadow(shadow)
            imageView?.contentMode = .scaleAspectFit
        }
    }
    
    @IBInspectable var roundConers: Bool = true {
        didSet {
            if roundConers {
                layer.cornerRadius = self.frame.width / 2
            }
        }
    }
}
