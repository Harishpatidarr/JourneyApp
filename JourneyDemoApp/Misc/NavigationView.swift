//
//  CustomNavigationBar.swift
//

import UIKit

class NavigationView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setHeight()
        drawShadow()
    }
    
    // MARK: - Helper Methods
    private func drawShadow() {
        //        layer.shadowColor = UIColor.darkGray.withAlphaComponent(0.15).cgColor
        layer.shadowColor = UIColor(named: "shadow")?.cgColor
        layer.shadowOpacity = 6
        layer.shadowOffset = .zero
        layer.shadowRadius = 6
    }
    
    private func setHeight() {
        let heightCustomNavigationBar = constraints.filter { $0.firstAttribute == .height }.first
        guard let heightConstraint = heightCustomNavigationBar else { return }
        let height = getNavigationBarHeight() ?? 64
        heightConstraint.constant = height
    }
    
    func getNavigationBarHeight() -> CGFloat? {
        guard let rootVC = UIApplication.shared.keyWindow?.rootViewController else { return nil }
        guard let navigationController = rootVC as? UINavigationController else { return nil }
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navigationBarHeight = navigationController.navigationBar.bounds.height
        let totalNavBarHeight = statusBarHeight + navigationBarHeight
        return totalNavBarHeight
    }
    
}
