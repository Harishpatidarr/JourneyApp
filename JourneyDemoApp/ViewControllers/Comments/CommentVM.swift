//
//  CommentVM.swift
//  JourneyDemoApp
//
//  Created by HarishPatidar on 06/08/22.
//

import UIKit

class CommentVM: NSObject {
   
    //MARK: - Instance Property
    var selectedPost: Post?
    var comments: Comments = []
}

//MARK: Api Calling Method

extension CommentVM {
    
    func getCommentListAPI(completion: @escaping ((ResponseType, String) -> Void)) {
        
        Manager.requestWithParameter(endPoint: .getComments) { [weak self] result in
            switch result {
            case .success(let response):
                if let data = response.data {
                    Comments.parseJSON(data) { [weak self] (parsedModel, error) in
                        guard let parsedModel = parsedModel else {
                            completion(.failure, "Parsing Error")
                            return
                        }
                        let comments = parsedModel.filter({ $0.postID == self?.selectedPost?.id})
                        self?.comments = comments
                        completion(.success, "")
                    }
                }
                
            case .failure(let error):
                completion(.failure, error.localizedDescription)
            }
        }
    }
    
}
