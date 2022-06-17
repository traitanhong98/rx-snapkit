//
//  CustomUISegmentedControl.swift
//  Pmobile3
//
//  Created by ECO0599-SONNT on 30/09/2021.
//

import UIKit

class CustomUISegmentedControl: UISegmentedControl{
    let segmentXInset: CGFloat = 0       //your inset amount
    let segmentYInset: CGFloat = 3
    var selectedColors: [UIColor] = [ .red] {
        didSet {
            self.layoutIfNeeded()
        }
    }

    override func layoutSubviews(){
        super.layoutSubviews()
        //background
        layer.cornerRadius = bounds.height / 2
        //foreground
        let foregroundIndex = numberOfSegments
        if subviews.indices.contains(foregroundIndex), let foregroundImageView = subviews[foregroundIndex] as? UIImageView {
            let color = selectedColors[safe: selectedSegmentIndex] ?? selectedColors.first ?? .clear
            let segmentImage =  UIImage(color: color)
            foregroundImageView.bounds = foregroundImageView.bounds.insetBy(dx: segmentXInset, dy: segmentYInset)
            foregroundImageView.image = segmentImage
            foregroundImageView.layer.removeAnimation(forKey: "SelectionBounds")
            foregroundImageView.layer.masksToBounds = true
            foregroundImageView.layer.cornerRadius = foregroundImageView.bounds.height / 2
        }
    }
    
    func bindData(_ data: [String], selectedSegmentIndex: Int?, selectedColor: [UIColor]?){
        self.removeAllSegments()
        data.reversed().forEach { title in
            self.insertSegment(withTitle: title, at: 0, animated: false)
        }
        self.selectedSegmentIndex = selectedSegmentIndex ?? 0
        self.selectedColors = selectedColor ?? [.white]
    }
}

extension UISegmentedControl {
    // Make segment become like multitabTitle
    func removeBorders(backgroundColor: UIColor = UIColor.clear,
                       selectedColor: UIColor = .blue,
                       normalColor: UIColor = .white,
                       titleFont: UIFont = .systemFont(ofSize: 17, weight: .bold)) {
        setBackgroundImage(imageWithColor(color: backgroundColor), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: backgroundColor), for: .selected, barMetrics: .default)
        tintColor = UIColor.white
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : selectedColor,
                                .font: titleFont,
                                .underlineStyle : NSUnderlineStyle.single.rawValue],
                               for: .selected)
        setTitleTextAttributes([NSAttributedString.Key.foregroundColor : normalColor,
                                .font: titleFont],
                               for: .normal)
    }
    
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}
