//
//  CommentVC.swift
//  JourneyDemoApp
//
//  Created by HarishPatidar on 06/08/22.
//

import UIKit

class CommentVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tblView: CustomTableView!

    // MARK: - Instance Properties
    let viewModel = CommentVM()

    // MARK: - UIViewController Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    // MARK: - Private
    
    private func configure() {
        tblView.registerCell(cellType: CommentTableViewCell.self)
        tblView.customSetup()
        self.getListApi()
    }
}

//MARK:- Calling Login API
extension CommentVC {
    
    func getListApi() {
        HudView.show()
        viewModel.getCommentListAPI { [unowned self]  (success, msg) in
            HudView.kill()
            self.tblView.reloadDataInMain()
        }
    }
    
}

//MARK: - UITableViewDelegate & UITableViewDataSource Methods
extension CommentVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let comment = viewModel.comments[indexPath.row]
        
        let cell = tblView.dequeueCell(cellType: CommentTableViewCell.self)
        cell.configure(comment: comment)
        return cell
        
    }
}
