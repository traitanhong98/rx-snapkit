//
//  Double+Extensions.swift
//  OSEIOS (iOS)
//
//  Created by ECO0542-HoangNM on 01/11/2021.
//

import UIKit

extension Double {
    var w: CGFloat {
        get {
            return UIScreen.main.bounds.width * CGFloat(self)
        }
    }
    
    var h: CGFloat {
        get {
            return UIScreen.main.bounds.height * CGFloat(self)
        }
    }
    
    func format(digitsAfterColon: Int) -> String {
        return String(format: "%.\(digitsAfterColon)f", self)
    }
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    func numberOfDigitsAfterColon() -> Int {
        let stringAfterColon = "\(self)".split(separator: ".")[1]
        return stringAfterColon.count
    }
}
