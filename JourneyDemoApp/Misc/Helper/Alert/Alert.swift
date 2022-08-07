//
//  Alert.swift
//

import UIKit

struct Alert {
    
    var title: String?
    var message: String?
    var handler: (() -> ())?
    
    init(title: String? = Application.name, message: String?, handler: (() -> ())? = nil) {
        self.title = title
        self.message = message
        self.handler = handler
    }
    static func showAlertWithMessage(_ message: String, title: String?, buttonTitle: String = "Ok", handler:(() -> ())? = nil) {
        //** If any Alert view is alrady presented then do not show another alert
        var viewController: UIViewController!
        if Thread.isMainThread {
            if let vc = UIApplication.topViewController() {
                if (vc.isKind(of: UIAlertController.self)) {
                    return
                } else {
                    viewController = vc
                }
            } else {
                viewController = Application.delegate.window?.rootViewController!
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) { (_) in
                handler?()
            })
            viewController!.present(alert, animated: true)
        } else {
            DispatchQueue.main.sync {
                if let vc = UIApplication.topViewController() {
                    if (vc.isKind(of: UIAlertController.self)) {
                        return
                    } else {
                        viewController = vc
                    }
                } else {
                    viewController = Application.delegate.window?.rootViewController!
                }
                
                let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default) { (_) in
                    handler?()
                })
                viewController!.present(alert, animated: true)
            }
        }
    }
    
    static func alertController(title:String, message: String, firstButtonTitle: String = "Yes", secondButtonTitle: String = "No", completion:@escaping (_ result: Bool) -> Void) {
        var viewController: UIViewController!
        if let vc = UIApplication.topViewController() {
            if (vc.isKind(of: UIAlertController.self)) {
                return
            } else {
                viewController = vc
            }
        } else {
            viewController = Application.delegate.window?.rootViewController!
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        viewController!.present(alert, animated: true, completion: nil)
        
        alert.addAction(UIAlertAction(title: firstButtonTitle, style: .default, handler: { action in
            completion(true)
        }))
        
        alert.addAction(UIAlertAction(title: secondButtonTitle, style: .cancel, handler: { action in
            completion(false)
        }))
    }
    
    static func showLoginAlert(handler:(() -> ())? = nil) {
        //** If any Alert view is alrady presented then do not show another alert
        var viewController: UIViewController!
        if let vc = UIApplication.topViewController() {
            if (vc.isKind(of: UIAlertController.self)) {
                return
            } else {
                viewController = vc
            }
        } else {
            viewController = Application.delegate.window?.rootViewController!
        }
        
        
        let alertController = UIAlertController(title: Application.name, message: "Please login first!", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Login", style: .default) { _ in
            handler?()
        })
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        viewController!.present(alertController, animated: true)
    }
}
