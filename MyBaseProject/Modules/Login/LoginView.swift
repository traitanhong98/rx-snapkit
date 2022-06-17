//
//  LoginView.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit
import SnapKit

class LoginView: UIView {
    var announcementView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        return view
    }()
    
    var headerSegment: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    var accountLoginView: LoginByAccountView = {
        let view = LoginByAccountView()
        return view
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
        addSubview(announcementView)
        addSubview(headerSegment)
        addSubview(accountLoginView)
        
        announcementView
            .snp
            .makeConstraints { make in
                make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(16)
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
                make.height.equalTo(16)
            }
        
        headerSegment
            .snp
            .makeConstraints { make in
                make.top.equalTo(announcementView.snp.bottom).offset(16)
                make.leading.equalTo(16)
                make.height.equalTo(32)
            }
        
        accountLoginView
            .snp
            .makeConstraints { make in
                make.top.equalTo(headerSegment.snp.bottom).offset(16)
                make.leading.equalTo(16)
                make.trailing.equalTo(-16)
            }
    }
}
