//
//  BaseViewController.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit

class BaseViewController: UIViewController {
    
    private var isFirstTimeShowing: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirstTimeShowing {
            isFirstTimeShowing = false
            onFirstTimeAppear()
        }
    }

    func onFirstTimeAppear() {
        
    }
}
