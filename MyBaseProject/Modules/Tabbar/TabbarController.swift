//
//  BbTabbarController.swift
//  BigBossIOS
//
//  Created by ECO0542-HoangNM on 28/02/2022.
//

import UIKit
import SwiftUI

class TabbarController: UITabBarController {
    var customTabBar: CustomTabBar!
    var tabBarHeight: CGFloat {
        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        return bottomPadding + 88
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadTabBar()
        additionalSafeAreaInsets.bottom = tabBarHeight
        additionalSafeAreaInsets.bottom = 88
//        NotificationCenter.default.addObserver(self, selector: #selector(updateLocalize), name: .didChangeLanguage, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(refreshFont), name: .didChangeFontSize, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(didRotateScreen), name: .didRotate, object: nil)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
    }
    
    @objc func updateLocalize() {
        view.updateLocalize()
    }

    @objc func refreshFont() {
//        view.refreshFont()
    }
    
    @objc func didRotateScreen(notification: NSNotification){
        let isPortrait = notification.object as? Bool ?? true
        self.customTabBar.isHidden = !isPortrait
        additionalSafeAreaInsets.bottom = isPortrait ? 88 : 0
    }
    
    func loadTabBar() {
        let tabbarItems: [Tabbar] = Tabbar.allCases

        setupCustomTabMenu(tabbarItems, completion: { viewControllers in
            self.viewControllers = viewControllers
        })

        selectedIndex = 0 // Set default selected index thành item đầu tiên
    }

    func setupCustomTabMenu(_ menuItems: [Tabbar], completion: @escaping ([UIViewController]) -> Void) {
        let frame = tabBar.frame
        var controllers = [UIViewController]()

        // Ẩn tab bar mặc định của hệ thống đi
        tabBar.isHidden = true
        // Khởi tạo custom tab bar
        customTabBar = CustomTabBar(menuItems: menuItems, frame: frame)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        customTabBar.clipsToBounds = true
        customTabBar.itemTapped = changeTab(tab:)
        view.addSubview(customTabBar)
        view.backgroundColor = .white

        // Auto layout cho custom tab bar
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            customTabBar.widthAnchor.constraint(equalToConstant: tabBar.frame.width),
            customTabBar.heightAnchor.constraint(equalToConstant: tabBarHeight),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Thêm các view controller tương ứng
        menuItems.forEach({
            let controller: UIViewController!
            switch $0 {
            case .market:
                controller = UIViewController()
            case .trade:
                controller = UIViewController()
            case .notifications:
                controller = UIViewController()
            case .account:
                controller = UIViewController()
            case .setting:
                controller = UIViewController()
            }
            controllers.append(controller)
        })
        
        view.layoutIfNeeded()
        completion(controllers)
    }
    
    func changeTab(tab: Int) {
        self.selectedIndex = tab
        navigationController?.navigationBar.isHidden = true
    }
    
    func switchTab(to tab: Tabbar, completion: (()->Void)? = nil) {
        let destinationIndex = { ()-> Int in
            switch tab {
            case .market:
                return 0
            case .trade:
                return 1
            case .account:
                return 2
            case .setting:
                return 3
            default:
                return -1
            }
        }()
        customTabBar.switchTab(from: selectedIndex, to: destinationIndex, completion: completion)
    }
}
