//
//  CommonFunction.swift
//  Pmobile3
//
//  Created by ECO0527_HOANGNM on 04/06/2021.
//

import Foundation
import SwiftUI

class CommonFunction {
    static func getScreenSize() -> CGRect {
        UIScreen.main.bounds
    }
    
    static func makeStringMoney(from value: Double,
                                groupingSeparator: String = ",",
                                decimalSeparator: String = ".",
                                maximumFractionDigits: Int = 3,
                                minimumFractionDigits: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = groupingSeparator
        numberFormatter.groupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = decimalSeparator
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = maximumFractionDigits
        numberFormatter.minimumFractionDigits = minimumFractionDigits
        return numberFormatter.string(from: value as NSNumber) ?? ""
    }
    
    static func checkSaveArea(isPortrait: Bool) -> Edge.Set {
        if (isPortrait) {
            return [.leading, .top, .trailing]
        }
        return [.leading, .top, .trailing, .bottom]
    }
    
    static func checkPadding(isPortrait: Bool) -> EdgeInsets {
        if (!isPortrait) {
            return EdgeInsets(
                top: 0,
                leading: Utils.getHeightStatusBar(),
                bottom: 15,
                trailing: 10)
        }
        
        return EdgeInsets(
            top: Utils.getHeightStatusBar(),
            leading: 0,
            bottom: 0,
            trailing: 0)
    }
    
    static func getDoubleValue(_ string: String?) -> Double {
        return Double((string ?? "").replacingOccurrences(of: "[^-^.^0-9]", with: "", options: .regularExpression, range: nil)) ?? 0
    }
    
    static func formatChangePercent(_ string: String) -> String {
        if (string == "-") {
            return string
        }
        if string.contains("%") {
            return string
        }
        return "\(string)%"
    }
    
    static func formatWithoutChangePercent(_ string: String) -> String {
        if (string == "-") {
            return string
        }
        return string.replacingOccurrences(of: "%", with: "")
    }
    
    static func formatNumber(_ number: Double,
                             maximumFractionDigits: Int = 2,
                             minimumFractionDigits: Int = 0) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter.string(from: number as NSNumber) ?? "0"
    }
    
    static func checkDivisible(fromX x: NSString, whollyDividedByY y: NSString) -> Bool {
        var i1 = (x.replacingOccurrences(of: ",", with: "") as NSString).integerValue
        var i2 = (y.replacingOccurrences(of: ",", with: "") as NSString).integerValue
        
        let strX = x
        let strY = y
        
        if y.floatValue != 0 {
            var l1: Int = 0
            var l2: Int = 0
            var dec1: Int = 0
            var dec2: Int = 0
            if strX.components(separatedBy: ".").count > 1 {
                l1 = strX.components(separatedBy: ".")[1].count
                dec1 = Int(strX.components(separatedBy: ".")[1]) ?? 0
            }
            if strY.components(separatedBy: ".").count > 1 {
                l2 = strY.components(separatedBy: ".")[1].count
                dec2 = Int(strY.components(separatedBy: ".")[1]) ?? 0
            }
            
            let d: Int = max(l1, l2)
            let z: Int = Int(pow(Double(10),Double(d)))
            if z > 1 {
                if l1 <= d {
                    dec1 *= Int(pow(Double(10),Double(d - l1)))
                    i1 = (i1 * z) + dec1
                }
                if l2 <= d {
                    dec2 *= Int(pow(Double(10),Double(d - l2)))
                    i2 = (i2 * z) + dec2
                }
            }
            
            if i2 == 0 {
                return true
            }
            
            return i1 % i2 == 0
        }
        return true
    }
}
