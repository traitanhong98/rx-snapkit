//
//  LoginViewModel.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: ViewModelType {
    let input: Input
    let outPut: Output
    private var disposeBag = DisposeBag()
    private let onlogin = PublishSubject<(userName: String, password: String)>()
    private let onloginSuccess = PublishSubject<LoginResponse>()
    private let onReceivedError = PublishSubject<String>()
    
    struct Input {
        let onLogin: AnyObserver<(userName: String, password: String)>
    }
    
    struct Output {
        let onLoginSuccess: AnyObserver<LoginResponse>
        let onReceivedError: AnyObserver<String>
    }
    
    init() {
        input = Input(
            onLogin: onlogin.asObserver()
        )
        
        outPut = Output(
            onLoginSuccess: onloginSuccess.asObserver(),
            onReceivedError: onReceivedError.asObserver()
        )
    }
    
    func setupInput() {
        _ = onlogin.subscribe { [weak self] (userName: String, password: String) in
            self?.login(userName: userName, password: password)
        }.disposed(by: disposeBag)
    }
    
    func login(userName: String, password: String) {
        AuthenService.shared.login(userName: userName, password: password) { [weak self] result in
            switch result {
            case .success(let response):
                self?.onloginSuccess.onNext(response)
            case .failure(let err):
                self?.onReceivedError.onNext("")
            }
        }
    }
}
