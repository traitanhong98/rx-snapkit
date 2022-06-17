//
//  Utils.swift
//  Pmobile3
//
//  Created by ECO0546-DUONGCT on 13/10/2021.
//

import SwiftUI
import LocalAuthentication
import CryptoKit
import Alamofire

class Utils: NSObject {
    static func checkBiometricType() -> LABiometryType{
        var error: NSError?
        if LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return LAContext().biometryType
        } else {
            debugPrint("checkBiometricType error: \(error?.description ?? "")")
            return .none
        }
    }
    
    static func checkNetWorkConnection() -> Bool {
        let sharedInstance = NetworkReachabilityManager()!
        return sharedInstance.isReachable
    }
    
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    static var isLandscape: Bool {
        let list = [UIInterfaceOrientationMask.landscape, UIInterfaceOrientationMask.landscapeLeft, UIInterfaceOrientationMask.landscapeRight]
        return list.contains(AppDelegate.orientationLock)
    }
    
    static var isPortrait: Bool {
        let list = [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
        return list.contains(AppDelegate.orientationLock)
    }
    
    static func getHeightStatusBar() -> CGFloat {
        let manager = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.windowScene?.statusBarManager
        return manager?.statusBarFrame.height ?? 0
    }
    
    static func getSafeAreaHeight(direction: Direction) -> CGFloat {
        switch direction {
        case Direction.Top:
            return UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.top ?? 100
        case Direction.Left:
            return UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.left ?? 100
        case Direction.Right:
            return UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.right ?? 100
        case Direction.Bottom:
            return UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 100
        }
    }
  
    static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
}
