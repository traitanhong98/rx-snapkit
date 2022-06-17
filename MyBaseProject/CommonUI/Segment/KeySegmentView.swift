//
//  KeySegmentView.swift
//  Pmobile3
//
//  Created by ECO0542-HoangNM on 28/04/2022.
//

import UIKit

class KeySegmentView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    var selectedIndex: Int { segmentView.selectedSegmentIndex }

    @IBInspectable var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    // MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViewFromNib()
        setupUI()
    }
    
    init() {
        super.init(frame: .zero)
        loadViewFromNib()
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViewFromNib()
        setupUI()
    }
    
    private func setupUI() {
        segmentView.removeAllSegments()
        segmentView
            .setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor.white,
                 .font: UIFont.systemFont(ofSize: 11)],
                for: .selected)
        segmentView
            .setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor : UIColor.white,
                 .font: UIFont.systemFont(ofSize: 11)],
                for: .normal)
    }
    
    func bindData(_ data: [String], selectedSegmentIndex: Int? = 0) {
        segmentView.removeAllSegments()
        data.reversed().forEach { title in
            segmentView.insertSegment(withTitle: title, at: 0, animated: false)
        }
        
        if let selectedSegmentIndex = selectedSegmentIndex {
            segmentView.selectedSegmentIndex = selectedSegmentIndex
        }
    }
}
