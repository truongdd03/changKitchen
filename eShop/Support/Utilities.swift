//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//

import Foundation
import UIKit

class Utilities {
    
    static func styleTextField(_ textfield:UITextField) {
        
        // Create the bottom line
        let bottomLine = CALayer()
        
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        
        bottomLine.backgroundColor = UIColor.systemOrange.cgColor
        // Remove border on text field
        textfield.borderStyle = .none
        
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
        
    }
    
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        button.backgroundColor = UIColor.systemOrange
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        // Hollow rounded corner style
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleFilledLabel(_ label:UILabel) {
        
        // Filled rounded corner style
        label.backgroundColor = UIColor.systemOrange
        label.layer.cornerRadius = 25.0
        label.layer.masksToBounds = true
        label.tintColor = UIColor.white
    }
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    static func styleRoundedImageView(_ image: UIImageView) {
        image.layer.cornerRadius = 20
    }
    
    static func styleRoundedLabel(_ label: UILabel) {
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.layer.cornerRadius = 20
    }
    
    static func reformatDate(date: String) -> String {
        var tmp = date
        var id = tmp.index(tmp.startIndex, offsetBy: 2)
        tmp.insert("/", at: id)
        id = tmp.index(id, offsetBy: 3)
        tmp.insert("/", at: id)
        
        return tmp
    }
    
    static func reformatPickUpTime(pickUpTime: String) -> String {
        var result = ""
        
        var time = pickUpTime
        time.removeFirst(6)
        let index = time.index(time.startIndex, offsetBy: 2)
        time.insert(":", at: index)
        result = "\(time), "
        
        var date = pickUpTime
        date.removeLast(4)
        result += Utilities.reformatDate(date: date)
        
        return result
    }
    
    static func findYear(pickUpTime: String) -> String {
        var result = pickUpTime
        result.removeFirst(4)
        result.removeLast(4)
        return result
    }
    
    static func createAlert(title: String, message: String) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return ac
    }
}
