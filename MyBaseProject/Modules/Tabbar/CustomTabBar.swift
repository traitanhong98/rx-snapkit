//
//  CustomTabBar.swift
//  CustomizedTabBar
//
//  Created by Thanh Nguyen Xuan on 08/12/2020.
//

import UIKit

class CustomTabBar: GradientView {
    let tabviewTag = 800
    var willSwitchTab: (_ from: Int, _ to: Int) -> Bool = {_, _ in true}
    var itemTapped: ((_ tab: Int) -> Void)?
    lazy var activeItem: Int = {
       800
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    convenience init(menuItems: [Tabbar], frame: CGRect) {
        self.init(frame: frame)

        layer.backgroundColor = UIColor.white.cgColor

        // Khởi tạo từng tab bar item
        for index in 0 ..< menuItems.count {

            let itemView = createTabItem(item: menuItems[index])
            itemView.translatesAutoresizingMaskIntoConstraints = false
            itemView.clipsToBounds = true
            itemView.tag = index + tabviewTag

            addSubview(itemView)
            if let previousItem = viewWithTag(index + tabviewTag - 1) {
                NSLayoutConstraint.activate([
                    itemView.heightAnchor.constraint(equalTo: heightAnchor),
                    itemView.leadingAnchor.constraint(equalTo: previousItem.trailingAnchor, constant: 0),
                    itemView.topAnchor.constraint(equalTo: topAnchor),
                    itemView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(1) / CGFloat(menuItems.count))
                ])
            } else {
                NSLayoutConstraint.activate([
                    itemView.heightAnchor.constraint(equalTo: heightAnchor),
                    itemView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
                    itemView.topAnchor.constraint(equalTo: topAnchor),
                    itemView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: CGFloat(1) / CGFloat(menuItems.count))
                ])
            }
        }
        setNeedsLayout()
        layoutIfNeeded()
        activateTab(tab: tabviewTag)
    }

    func setupUI() {
        self.startColor =  .clear
        self.endColor = .clear
        self.endLocation = 0.6
    }
    
    func createTabItem(item: Tabbar) -> UIView {
        let tabBarItem = TabItemView()
        tabBarItem.loadData(tabItem: item)
        tabBarItem.onClick = {[unowned self] in
            switchTab(from: activeItem - tabviewTag, to: tabBarItem.tag - tabviewTag)
        }

        return tabBarItem
    }

    @objc func handleTap(_ sender: UIGestureRecognizer) {
        
        switchTab(from: activeItem - tabviewTag, to: sender.view!.tag - tabviewTag)
    }

    func switchTab(from: Int, to: Int, completion: (()->Void)? = nil) {
        guard willSwitchTab(from, to) else { return }
        let group = DispatchGroup()
        group.enter()
        deactivateTab(tab: from + tabviewTag) {
            group.leave()
        }
        group.enter()
        activateTab(tab: to + tabviewTag) {
            group.leave()
        }
        
        group.notify(queue: .main) {
            completion?()
        }
    }

    func activateTab(tab: Int, completion: (()->Void)? = nil) {
        guard let tabToActivate = viewWithTag(tab) as? TabItemView else { return }
        tabToActivate.changeSelection(isSelected: true)

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.8,
                           delay: 0.0,
                           options: [.curveEaseIn, .allowUserInteraction]) {
                tabToActivate.setNeedsLayout()
                tabToActivate.layoutIfNeeded()
            } completion: { _ in
                self.itemTapped?(tab - self.tabviewTag)
                self.activeItem = tab
                completion?()
            }
        }
    }

    func deactivateTab(tab: Int, completion: (()->Void)? = nil) {
        guard let inactiveTab = viewWithTag(tab) as? TabItemView else { return }
        inactiveTab.changeSelection(isSelected: false)

        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.4, delay: 0.0, options: [.curveEaseIn, .allowUserInteraction]) {
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
            } completion: { _ in
                completion?()
            }
        }
    }
}
