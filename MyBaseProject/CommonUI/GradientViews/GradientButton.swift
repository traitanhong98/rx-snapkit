//
//  GradientButton.swift
//  OSEIOS
//
//  Created by ECO0542-HoangNM on 31/05/2022.
//

import UIKit

@IBDesignable
public class GradientButton: UIButton, Gradientable {
    @IBInspectable var startColor:   UIColor = .white { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.0  { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   1.0  { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    @IBInspectable var diagonalMode:    Bool =  false { didSet { updatePoints() }}
    
    override public class var layerClass: AnyClass { CAGradientLayer.self }
    var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    
    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateGradient()
    }
}
