//
//  UIApplication.swift
//  DeepProProd
//
//  Created by Mushtaque Ahmed on 1/11/18.
//  Copyright © 2018 Mushtaque Ahmed. All rights reserved.
//

import Foundation
import UIKit

extension UIApplication {
    
    class func topViewController(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        if let mainVC = viewController as? MainViewController {
            return topViewController(mainVC.currentViewController)
        }
        return viewController
    }
    
    class func rootViewController() -> UIViewController
    {
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    
}
