//
//  UITableView+Extension.swift
//  Pmobile3
//
//  Created by ECO0542-HoangNM on 23/05/2022.
//

import UIKit

extension UITableView {
    func registerCell<T: UITableViewCell>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as? T
    }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(_ type: T.Type) {
        register(UINib(nibName: String(describing: type), bundle: nil), forCellWithReuseIdentifier: String(describing: type))
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(_ type: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: String(describing: type), for: indexPath) as? T
    }
}
