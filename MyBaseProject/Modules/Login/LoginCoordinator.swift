//
//  LoginCoordinator.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit
import RxSwift
import RxCocoa

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private var dispose = DisposeBag()
    
    var childCoordinators: [Coordinator] = []
    private var viewModel: LoginViewModel?
    
    init(navigation: UINavigationController) {
        self.navigationController = navigation
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    func start() {
        let loginViewModel = LoginViewModel()
        let loginViewController = LoginViewController(
            viewModel: loginViewModel
        )
        navigationController.pushViewController(loginViewController, animated: true)
    }
}
