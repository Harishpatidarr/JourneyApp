//
//  UIViewController.swift
//  Harish Patidar
//

import Foundation
import UIKit

extension UIViewController {
    
    var appVersion : String {
        Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    func removeNotificationObserver(_ rawValue: String) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: rawValue), object: nil)
    }
    
    func addNotificationObserver(_ rawValue: String, selector : Selector) {
        self.removeNotificationObserver(rawValue)
        NotificationCenter.default.addObserver(self,
                                               selector: selector,
                                               name: NSNotification.Name(rawValue: rawValue),
                                               object: nil)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) -> Void {
        if Thread.isMainThread {
            self.navigationController?.pushViewController(viewController, animated: animated)
        } else {
            DispatchQueue.main.sync {
                self.navigationController?.pushViewController(viewController, animated: animated)
            }
        }
    }
    
    func pop(animated: Bool = true) {
        if Thread.isMainThread {
            self.navigationController?.popViewController(animated: animated)

        } else {
            _ = DispatchQueue.main.sync {
                self.navigationController?.popViewController(animated: animated)
            }
        }
    }
    
    func present(_ viewController: UIViewController, animated: Bool = true) -> Void {
        if Thread.isMainThread {
            present(viewController, animated: animated, completion: nil)
        } else {
            DispatchQueue.main.sync {
                present(viewController, animated: animated, completion: nil)
            }
        }
    }
    
    func dismiss(animated: Bool = true) {
        dismiss(animated: animated, completion: nil)
    }
    
    func showAlertWith(message: String, cancelButtonCallback: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (action) in
            cancelButtonCallback?()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    class func isProtraitOrientation() -> Bool {
        let screenBounds = UIScreen.main.bounds
        return screenBounds.width < screenBounds.height
    }
}

@nonobjc extension UIViewController {
    
    func add(_ child: UIViewController, to view: UIView, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func removeChildController() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}


extension UIViewController {

    @IBAction func popVC() {
        if Thread.isMainThread {
            self.navigationController?.popViewController(animated: true)
        } else {
            _ = DispatchQueue.main.sync {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func popToRoot() {
        if Thread.isMainThread {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            _ = DispatchQueue.main.sync {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    @IBAction func popToSpecificController(_ viewController: Any) {
        if Thread.isMainThread {
            for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: viewController as! AnyClass) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        } else {
            DispatchQueue.main.sync {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: viewController as! AnyClass) {
                        _ =  self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
    }
    
    func pushVC(_ viewController: UIViewController, animated: Bool = true) -> Void {
        if Thread.isMainThread {
            self.navigationController?.pushViewController(viewController, animated: animated)
        } else {
            DispatchQueue.main.sync {
                self.navigationController?.pushViewController(viewController, animated: animated)
            }
        }
    }
    
    func checkControllerInNavigationStack(_ VC: AnyClass)-> Bool {
        if let viewControllers = self.navigationController?.viewControllers {
            for vc in viewControllers {
                if vc.isKind(of: VC) {
                    return true
                }
            }
        }
        return false
    }
    
    func checkAndRemoveControllerInNavigationStack(_ VC: AnyClass) -> [UIViewController] {
        if var viewControllers = self.navigationController?.viewControllers {
            var i = 0
            for vc in viewControllers {
                if vc.isKind(of: VC) {
                    viewControllers.remove(at: i)
                    return viewControllers
                }
                i += 1
            }
        }
        return self.navigationController?.viewControllers ?? []
    }
        
    @IBAction public func backtoPopViewController(_ sender: AnyObject) {
        guard self.navigationController != nil else { return }
        self.navigationController?.popViewController(animated: true)
    }
}
