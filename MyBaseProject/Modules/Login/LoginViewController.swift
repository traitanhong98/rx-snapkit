//
//  LoginViewController.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit

class LoginViewController: UIViewController {
    var viewModel: LoginViewModel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = LoginView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
// MARK: - ControllerType
extension LoginViewController: ControllerType {
    typealias ViewModelType = LoginViewModel
    
    func bindViewModel() {
        
    }
}
