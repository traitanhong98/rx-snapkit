//
//  TabItemView.swift
//  BigBossIOS
//
//  Created by ECO0542-HoangNM on 28/02/2022.
//

import UIKit

class TabItemView: UIView {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var btnTap: UIButton!
    // MARK: - Variables
    var onClick: () -> Void = {}
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupView()
    }
    
    init() {
        super.init(frame: .zero)
        loadViewFromNib()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupView()
    }
    
    func setupView() {
        backgroundColor = UIColor(named: "black_2b2b2b")
        titleLabel.font = .systemFont(ofSize: 11)
        iconImageView.tintColor = .white
        titleLabel.textColor = .white
        self.alpha = 0.4
    }
    
    // MARK: - Func
    func loadData(tabItem: Tabbar) {
        titleLabel.localizedString = tabItem.title
        iconImageView.image = UIImage(named: tabItem.iconName)!.withRenderingMode(.alwaysTemplate)
    }
    
    func changeSelection(isSelected: Bool) {
        alpha = isSelected ? 1 : 0.4
    }
    // MARK: - IBAction
    @IBAction func clickBtnTap(_ sender: Any) {
        onClick()
    }
}
