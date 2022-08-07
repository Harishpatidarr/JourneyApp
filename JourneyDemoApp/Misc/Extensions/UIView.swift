//
//  Custom+UIView.swift
//
//  Created by Harish Patidar on 10/08/17.
//

import Foundation
import AVFoundation
import UIKit

extension UIView {
    
    func constraint(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter { $0.identifier == identifier }.first
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue!.cgColor
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        set {
            self.layer.shadowColor = newValue!.cgColor
            self.layer.masksToBounds = false;
            self.clipsToBounds = false;
        }
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor:color)
            }
            else {
                return nil
            }
        }
    }
    
    
    /* The opacity of the shadow. Defaults to 0. Specifying a value outside the
     * [0,1] range will give undefined results. Animatable. */
    @IBInspectable var shadowOpacity: Float {
        set {
            self.layer.shadowOpacity = newValue
        }
        get {
            return layer.shadowOpacity
        }
    }
    
    /* The shadow offset. Defaults to (0, -3). Animatable. */
    @IBInspectable var shadowOffset: CGPoint {
        set {
            self.layer.shadowOffset = CGSize(width: newValue.x, height: newValue.y)
        }
        get {
            return CGPoint(x: layer.shadowOffset.width, y:layer.shadowOffset.height)
        }
    }
    
    /* The blur radius used to create the shadow. Defaults to 3. Animatable. */
    @IBInspectable var shadowRadius: CGFloat {
        set {
            self.layer.shadowRadius = newValue
            self.layer.masksToBounds = false;
            self.clipsToBounds = false;
        }
        get {
            return layer.shadowRadius
        }
    }
    
    // MARK: - Animation
    func pulsateAnimate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.3
        pulse.toValue = 0.6
        pulse.autoreverses = true
        pulse.repeatCount = 1
        layer.add(pulse, forKey: "pulse")
    }
    
    
    // MARK: - Gradiant View
    func addGradiantColor(isLeftRight: Bool, bound: CGRect) {
        self.removeGradiantView()
        if isLeftRight {
            let mGradient = CAGradientLayer()
            var colors = [CGColor]()
            colors.append(UIColor(red: 137.0/255.0, green: 214.0/255.0, blue: 0.0/255, alpha: 1).cgColor)
            colors.append(UIColor(red: 193.0/255.0, green: 211.0/255.0, blue: 0.0/255, alpha: 1).cgColor)
            mGradient.locations = [0.0, 0.85]
            mGradient.startPoint = CGPoint(x: 0, y: 0.5)
            mGradient.endPoint = CGPoint(x: 1, y: 0.5)
            mGradient.colors = colors
            mGradient.frame = bound
            self.layer.insertSublayer(mGradient, at: 0)
        } else {
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            var colors = [CGColor]()
            colors.append(UIColor(red: 137.0/255.0, green: 214.0/255.0, blue: 0.0/255, alpha: 1).cgColor)
            colors.append(UIColor(red: 207.0/255.0, green: 213.0/255.0, blue: 0.0/255, alpha: 1).cgColor)
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1.5, y: 2.0)
            gradientLayer.locations =  [0.0, 0.6, 0.0]
            gradientLayer.colors = colors
            self.layer.insertSublayer(gradientLayer, below: self.layer)
        }
    }
    
    func removeGradiantView() {
        guard let layers = self.layer.sublayers else { return }
        for layer in layers {
            if layer is CAGradientLayer {
                layer.removeFromSuperlayer()
            }
        }
    }
    
    
    /// Get all view controller text fileds
    func getTextfield() -> [UITextField] {
        var results = [UITextField]()
        for subview in self.subviews as [UIView] {
            if let textField = subview as? UITextField {
                results += [textField]
            } else {
                results += subview.getTextfield()
            }
        }
        return results
    }
    
    func captureScreen() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, _: true, _: 0.0)
        if let context = UIGraphicsGetCurrentContext() {
            self.layer.render(in: context)
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}

class GradiantView: UIButton {
    @IBInspectable var startColor:   UIColor = .black { didSet { updateColors() }}
    @IBInspectable var endColor:     UIColor = .white { didSet { updateColors() }}
    @IBInspectable var startLocation: Double =   0.05 { didSet { updateLocations() }}
    @IBInspectable var endLocation:   Double =   0.95 { didSet { updateLocations() }}
    @IBInspectable var horizontalMode:  Bool =  false { didSet { updatePoints() }}
    
    override class var layerClass: AnyClass { return CAGradientLayer.self }
    
    var gradientLayer: CAGradientLayer { return layer as! CAGradientLayer }
    
    func updatePoints() {
        if horizontalMode {
            gradientLayer.startPoint =  CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint   =  CGPoint(x: 1, y: 0.5)
        } else {
            gradientLayer.startPoint =  CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint   =  CGPoint(x: 0.5, y: 1)
        }
    }
    func updateLocations() {
        gradientLayer.locations = [startLocation as NSNumber, endLocation as NSNumber]
    }
    func updateColors() {
        gradientLayer.colors    = [startColor.cgColor, endColor.cgColor]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePoints()
        updateLocations()
        updateColors()
    }
}


extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
