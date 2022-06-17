//
//  UIImage+Extensions.swift
//  OSEIOS
//
//  Created by ECO0542-HoangNM on 02/06/2022.
//

import UIKit

// MARK: - UIImage
extension UIImage {
    /// Creates a UIImage from an UIColor
    public convenience init?(color: UIColor,
                             size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
