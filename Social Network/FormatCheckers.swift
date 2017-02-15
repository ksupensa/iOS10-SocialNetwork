//
//  FormatCheckers.swift
//  Social Network
//
//  Created by Spencer Forrest on 16/02/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import Foundation

class FormatCheckers {
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
