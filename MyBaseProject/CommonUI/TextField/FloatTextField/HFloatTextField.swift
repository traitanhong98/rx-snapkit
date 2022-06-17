//
//  HFloatTextField.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class HFloatTextField: UIView {
    // Items
    private var placeHolderLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(hex: "999999")
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    var contentTextField: HTextField = {
        let textField = HTextField()
        return textField
    }()
    
    private var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    // Properties
    private let disposeBag = DisposeBag()
    lazy var placeHolder: String = "" {
        didSet {
            placeHolderLabel.text = placeHolder
        }
    }
    
    init() {
        super.init(frame: .zero)
        drawView()
        setupView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawView()
        setupView()
    }

    func setupView() {
        contentTextField.rx.text
            .orEmpty
            .subscribe { [weak self] _ in
                self?.updateViewBaseOnContent(isFocusing: self?.contentTextField.isFirstResponder ?? false)
            }
            .disposed(by: disposeBag)
        contentTextField.textFieldDelegate = self
    }
    
    func drawView() {
        addSubview(placeHolderLabel)
        addSubview(contentTextField)
        addSubview(underlineView)
        
        placeHolderLabel
            .snp
            .makeConstraints { make in
                make.top.equalTo(0)
                make.height.equalTo(30)
                make.leading.equalTo(0)
            }
        
        contentTextField
            .snp
            .makeConstraints { make in
                make.center.equalTo(snp.center)
                make.height.equalTo(30)
                make.trailing.leading.equalTo(0)
            }
        
        underlineView
            .snp
            .makeConstraints { make in
                make.height.equalTo(1)
                make.trailing.leading.equalTo(0)
                make.bottom.equalTo(0)
            }
        
        snp.makeConstraints { make in
            make.height.equalTo(42)
        }
    }
    
    func updateViewBaseOnContent(isFocusing: Bool) {
        if !(contentTextField.text ?? "").isEmpty || isFocusing {
            placeHolderLabel.font = .systemFont(ofSize: 16 * 0.8, weight: .medium)
            placeHolderLabel.textColor = .white
            placeHolderLabel
                .snp
                .updateConstraints { make in
                    make.top.equalTo(-30)
            }
        } else {
            placeHolderLabel.font = .systemFont(ofSize: 16, weight: .medium)
            placeHolderLabel.textColor = .lightGray
            placeHolderLabel
                .snp
                .updateConstraints { make in
                    make.top.equalTo(0)
                }
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
}

extension HFloatTextField: HTextFieldDelegate {
    func textField(_ textField: HTextField, changeFirstResponderState isFirstResponder: Bool) {
        updateViewBaseOnContent(isFocusing: isFirstResponder)
    }
}
