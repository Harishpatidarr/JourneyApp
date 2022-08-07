//
//  UIApplication.swift
//

import UIKit

extension UIApplication {
    
    static func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            if Thread.isMainThread {
                return topViewController(nav.visibleViewController)
            } else {
                _ = DispatchQueue.main.sync(execute: {
                    return topViewController(nav.visibleViewController)
                })
            }
        }
        
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            
            return topViewController(selected)
        }
        
        if let presented = base?.presentedViewController {
            
            return topViewController(presented)
        }
        return base
    }
}
