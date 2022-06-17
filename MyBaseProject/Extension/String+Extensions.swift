//
//  String+Extensions.swift
//  CQStation
//
//  Created by trong hoang on 25/10/2021.
//

import UIKit
import Foundation

extension String {    
    var localized: String {
        let localizedText = NSLocalizedString(self, comment: "")
        return localizedText.isEmpty ? self : localizedText
    }
    
    func toDate(format: String = "dd/MM") -> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        return dateFormater.date(from: self)
    }
    
    var intValue: Int {Int(self.replacingOccurrences(of: "[^-^.^0-9]", with: "", options: .regularExpression, range: nil)) ?? 0}
    var int64Value: Int64 {Int64(self.replacingOccurrences(of: "[^-^.^0-9]", with: "", options: .regularExpression, range: nil)) ?? 0}
    var doubleValue: Double {Double(self.replacingOccurrences(of: "[^-^.^0-9]", with: "", options: .regularExpression, range: nil)) ?? 0}
    
    func makeStringMoney() -> String {
        CommonFunction.makeStringMoney(from: self.doubleValue)
    }
    /// Return true if lhs matched rhs regex
    static func ~= (lhs: String, rhs: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    /// Calculate width of view with font and fixed height
    func width(font: UIFont, height: CGFloat) -> CGFloat {
        let label = UILabel()
        label.numberOfLines = 1
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = self
        label.sizeToFit()
        return label.frame.width
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}

extension Optional where Wrapped == String {
    var value: String {self ?? ""}
    var valueDisplay: String {self ?? "_"}
    
    var isNullOrEmpty: Bool {
        guard let value = self else {
            return true
        }
        return value.isEmpty
    }
}
