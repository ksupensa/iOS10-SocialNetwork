//
//  CircleDelegate.swift
//  Social Network
//
//  Created by Spencer Forrest on 16/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import UIKit

protocol CircleDelegate {}

extension CircleDelegate where Self: UIView {
    func setCircle(_ isCircular: Bool){
        if isCircular{
            layer.cornerRadius = self.frame.width / 2
        }
    }
}
