//
//  ClientNetwork.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import Foundation
import SwiftUI

enum NetworkError: Error {
    case fail(_ message: String)
    case sessionExpire
}
