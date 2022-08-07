//
//  LoadNib+UIView.swift
//

import UIKit

extension UINib {
    
    static func load<T: UIView>(_ nibType: T.Type) -> T {
        let identifier = "\(nibType)"
        let view = UINib(nibName: identifier, bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        return view
    }
}
