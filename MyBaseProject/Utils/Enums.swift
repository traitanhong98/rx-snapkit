//
//  Enums.swift
//  MyBaseProject
//
//  Created by ECO0542-HoangNM on 15/06/2022.
//

import UIKit

// MARK: - Tabbar
enum Tabbar: Hashable {
    case market, trade, notifications, account, setting
    
    static let allCases: [Tabbar] = [.market, .trade, .account, .setting]
    
    var title: String {
        switch self {
        case .market:
            return "tabbar_market".localized
        case .trade:
            return "tabbar_trade".localized
        case .notifications:
            return "tabbar_notification".localized
        case .account:
            return "tabbar_account".localized
        case .setting:
            return "tabbar_setting".localized
        }
    }
    

    var iconName: String {
        switch self {
        case .market:
            return ""
        case .trade:
            return ""
        case .notifications:
            return ""
        case .account:
            return ""
        case .setting:
            return ""
        }
    }
}

enum Direction: String {
    case Top = "Top"
    case Bottom = "Bottom"
    case Left = "Left"
    case Right = "Right"
}
