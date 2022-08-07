//
//  PostVC.swift
//  JourneyDemoApp
//
//  Created by HarishPatidar on 06/08/22.
//

import UIKit

class PostVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tblView: CustomTableView!
    
    // MARK: - Instance Properties
    let viewModel = PostVM()
    
    // MARK: - UIViewController Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Private
    
    private func configure() {
        tblView.registerCell(cellType: PostListTableViewCell.self)
        tblView.customSetup()
        self.getListApi()
    }
}

//MARK:- Calling Login API
extension PostVC {
    
    func getListApi() {
        HudView.show()
        viewModel.getPostListAPI { [unowned self]  (success, msg) in
            HudView.kill()
            self.tblView.reloadDataInMain()
        }
    }
    
}
//MARK: - UITableViewDelegate & UITableViewDataSource Methods
extension PostVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.postList[indexPath.row]
        
        let cell = tblView.dequeueCell(cellType: PostListTableViewCell.self)
        cell.configure(post: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.postList[indexPath.row]
        let viewController = Storyboard.main.instantiate(vcType: CommentVC .self)
        viewController.viewModel.selectedPost = post
        self.pushVC(viewController)
    }
}
