//
//  UITextField+Extensions.swift
//  OSEIOS/Users/eco0813-thangnv/Desktop/OSE/OSEIOS/Extentions/UIButton+Extensions.swift
//
//  Created by ECO0542-HoangNM on 02/06/2022.
//

import UIKit

extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}
