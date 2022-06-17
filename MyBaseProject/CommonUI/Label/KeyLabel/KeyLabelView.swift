//
//  KeyLabelView.swift
//  Pmobile3
//
//  Created by ECO0542-HoangNM on 28/04/2022.
//

import UIKit

class KeyLabelView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBInspectable var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable var value: String = "" {
        didSet {
            valueLabel.text = value
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()

    }
    
    init() {
        super.init(frame: .zero)
        loadViewFromNib()
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
    }
}
