//
//  GradientAble.swift
//  OSEIOS
//
//  Created by ECO0542-HoangNM on 31/05/2022.
//

import UIKit

protocol Gradientable: UIView {
    var startColor:   UIColor { get set }
    var endColor:     UIColor { get set }
    var startLocation: Double { get set }
    var endLocation:   Double { get set }
    var horizontalMode:  Bool { get set }
    var diagonalMode:    Bool { get set }
    var gradientLayer: CAGradientLayer { get }
}

extension Gradientable {
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint = diagonalMode ? .init(x: 1, y: 0) : .init(x: 0, y: 0.5)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 0, y: 1) : .init(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint = diagonalMode ? .init(x: 0, y: 0) : .init(x: 0.5, y: 0)
            gradientLayer.endPoint   = diagonalMode ? .init(x: 1, y: 1) : .init(x: 0.5, y: 1)
        }
    }
    
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    
    func updateColors() {
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
    }
    
    func updateGradient() {
        updatePoints()
        updateLocations()
        updateColors()
    }
}
