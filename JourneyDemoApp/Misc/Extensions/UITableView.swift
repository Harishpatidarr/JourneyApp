//
//  DequeueCell+UITableView.swift
//

import UIKit

extension UITableView {
    
    func dequeueCell<T: UITableViewCell>(cellType: T.Type) -> T {
        let cell = self.dequeueReusableCell(withIdentifier: String(describing: cellType)) as! T
        return cell
    }
    
    func dequeueHeaderFooter<T: UITableViewHeaderFooterView>(viewType: T.Type) -> T {
        let view = self.dequeueReusableHeaderFooterView(withIdentifier:  String(describing: viewType)) as! T
        return view
    }
    
    func reloadDataInMain() {
        if Thread.isMainThread {
            self.reloadData()
        } else {
            DispatchQueue.main.async {
                self.reloadData()
            }
        }
    }
    
    func deleteRowWithIntexPath(_ indexPath: IndexPath) {
        let dispacthGroup = DispatchGroup()
        dispacthGroup.enter()
        DispatchQueue.main.async {
            self.deleteRows(at: [indexPath], with: .fade)
            dispacthGroup.leave()
        }
    }
    
    func deleteSectionWithIntexPath(_ indexPath: IndexPath) {
        let dispacthGroup = DispatchGroup()
        dispacthGroup.notify(queue: .main) {
            self.deleteSections(IndexSet.init(integer: indexPath.section), with: .fade)
        }
    }
    
    func registerCell<T: UITableViewCell>(cellType: T.Type) {
        let nib = UINib(nibName: String(describing: cellType.self), bundle: nil)
        let reuseIdentifier = String(describing: cellType.self)
        self.register(nib, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func registerHeaderFooter<T: UITableViewHeaderFooterView>(cellType: T.Type) {
        let nib = UINib(nibName: String(describing: cellType.self), bundle: nil)
        let reuseIdentifier = String(describing: cellType.self)
        self.register(nib, forHeaderFooterViewReuseIdentifier: reuseIdentifier)
    }
    
    func hideTableInMain(isHidden: Bool) {
        DispatchQueue.main.async {
            self.isHidden = isHidden
        }
    }
}
