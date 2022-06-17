//
//  DropdownCell.swift
//  Pmobile3
//
//  Created by Lê Trung Kiên on 8/19/21.
//

import UIKit

class TextDropdownCell: UITableViewCell {
    
    private let contentLbl = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(contentLbl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLbl.frame = CGRect(x: 16, y: 0, width: bounds.width - 32, height: bounds.height)
    }
    
    func configCell(font: UIFont, textAlignment: NSTextAlignment, textColor: UIColor) {
        contentLbl.font = font
        contentLbl.textAlignment = textAlignment
        contentLbl.textColor = textColor
        contentLbl.numberOfLines = 0
    }
    
    func bindData(text: String) {
        contentLbl.text = text
    }
}
