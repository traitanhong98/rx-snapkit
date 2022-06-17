//
//  Coordinator.swift
//  TawkUserManager
//
//  Created by Savvycom2021 on 14/05/2022.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
