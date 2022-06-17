//
//  CurrencyTableViewCell.swift
//  Pmobile3
//
//  Created by ECO0542-HoangNM on 29/12/2021.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var currencyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        currencyLabel.textColor = .white
        currencyLabel.font = .systemFont(ofSize: 14)
    }

    func bindData(currency: String) {
        currencyLabel.text = currency
        contentImageView.image = UIImage(named: currency)
    }
    
}
