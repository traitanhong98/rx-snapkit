//
//  AuthenService.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 17/06/2022.
//

import Foundation

class AuthenService {
    private init() {}
    static let shared = AuthenService()
    
    func login(userName: String,
               password: String,
               completionBlock: @escaping (Result<LoginResponse, NetworkError>) -> Void) {
        
        if userName.isEmpty || password.isEmpty {
            completionBlock(.failure(.fail("User name and network must not be empty")))
        }
        DispatchQueue
            .main
            .asyncAfter (
                deadline: .now() + 0.5,
                execute: {
                    completionBlock(.success(LoginResponse()))
                }
            )
    }
}
