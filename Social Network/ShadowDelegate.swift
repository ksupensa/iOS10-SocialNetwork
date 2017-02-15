//
//  ShadowDelegate.swift
//  Social Network
//
//  Created by Spencer Forrest on 15/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

protocol ShadowDelegate {}

extension ShadowDelegate where Self: UIView {
    func setShadow(_ hasShadow: Bool) {
        if hasShadow {
            layer.shadowColor = UIColor(red: SHADOW_GREY, green: SHADOW_GREY, blue: SHADOW_GREY, alpha: 1).cgColor
            layer.shadowOpacity = 1
            layer.shadowRadius = 10.0
            layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        }
    }
}
