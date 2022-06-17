//
//  HTextField.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit

@objc protocol HTextFieldDelegate: AnyObject {
    @objc optional func textField(_ textField: HTextField, changeFirstResponderState isFirstResponder: Bool)
}

class HTextField: UITextField {
    weak var textFieldDelegate: HTextFieldDelegate?
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func becomeFirstResponder() -> Bool {
        textFieldDelegate?.textField?(self, changeFirstResponderState: true)
        return super.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        textFieldDelegate?.textField?(self, changeFirstResponderState: false)
        return super.resignFirstResponder()
    }
    
    func setupUI() {
        textColor = .white
        addDoneButton()
    }
}
