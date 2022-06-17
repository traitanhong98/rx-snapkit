//
//  GradientLabel.swift
//  OSEIOS
//
//  Created by ECO0542-HoangNM on 31/05/2022.
//

import UIKit

@IBDesignable
public class GradientLabel: UILabel, Gradientable {
    @IBInspectable var startColor:   UIColor = .white { didSet { setNeedsDisplay() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { setNeedsDisplay() }}
    @IBInspectable var startLocation: Double =   0.0  { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   1.0  { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { setNeedsDisplay() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { setNeedsDisplay() }}
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    public override func drawText(in rect: CGRect) {
        if let gradientColor = UIColor.drawGradientColor(in: rect,
                                                         colors: [startColor, endColor].map({$0.cgColor}),
                                                         locations: [startLocation, endLocation]) {
            self.textColor = gradientColor
        }
        super.drawText(in: rect)
    }
}
