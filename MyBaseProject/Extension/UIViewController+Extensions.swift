//
//  UIViewController+Extensions.swift
//  OSEIOS
//
//  Created by ECO0813-THANGNV on 6/1/22.
//

import UIKit

extension UIViewController {
    /// Find the topmost parent controller from a controller
    /// Ex: - This func will help popup to be shown on entire screen
    func findTopParent() -> UIViewController {
        var topMostParent = self
        while let parent = topMostParent.parent {
            topMostParent = parent
        }
        return topMostParent
    }
    /// Add tap gesture to hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
