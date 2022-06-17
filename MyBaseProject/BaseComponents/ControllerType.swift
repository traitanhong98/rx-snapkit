//
//  ControllerType.swift
//  TawkUserManager
//
//  Created by Savvycom2021 on 14/05/2022.
//

import Foundation

protocol ControllerType {
    associatedtype ViewModelType
    func bindViewModel()
}
