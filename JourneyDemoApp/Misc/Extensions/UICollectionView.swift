//
//  UICollectionView+ReloadData.swift
//
//

import UIKit

extension UICollectionView {
    
    func dequeueCell<T: UICollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as! T
        return cell
    }
    
    func registerCell<T: UICollectionViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: String(describing: cellType.self), bundle: nil)
        let reuseIdentifier = String(describing: cellType.self)
        self.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func reloadDataInMain() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
