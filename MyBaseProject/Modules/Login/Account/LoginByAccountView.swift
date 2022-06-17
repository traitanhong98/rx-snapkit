//
//  LoginByAccountView.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit
import SnapKit

class LoginByAccountView: UIView {
    var userNameTextField: HFloatTextField = {
        let textField = HFloatTextField()
        textField.placeHolder = "POEMS Account Number"
        return textField
    }()
    
    var passwordTextField: HFloatTextField = {
        let textField = HFloatTextField()
        textField.placeHolder = "POEMS Account Password"
        return textField
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        drawView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        drawView()
    }
    
    init() {
        super.init(frame: .zero)
        drawView()
    }
    
    func drawView() {
        addSubview(userNameTextField)
        addSubview(passwordTextField)
        
        userNameTextField
            .snp
            .makeConstraints { make in
                make.top.equalTo(0)
                make.leading.equalTo(0)
                make.trailing.equalTo(0)
            }
        
        passwordTextField
            .snp
            .makeConstraints { make in
                make.top.equalTo(userNameTextField.snp.bottom).offset(40)
                make.leading.equalTo(0)
                make.trailing.equalTo(0)
                make.bottom.equalTo(0)
            }
    }
}
