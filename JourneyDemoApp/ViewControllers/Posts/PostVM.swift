//
//  PostVM.swift
//  JourneyDemoApp
//
//  Created by HarishPatidar on 06/08/22.
//

import UIKit

class PostVM: NSObject {
    
    //MARK: - Instance Property
    
    var postList: [Post] = []
}

//MARK: Api Calling Method

extension PostVM {
    
    func getPostListAPI(completion: @escaping ((ResponseType, String) -> Void)) {
        
        Manager.requestWithParameter(endPoint: .getPosts) { [weak self] result in
            switch result {
            case .success(let response):
                if let data = response.data {
                    Posts.parseJSON(data) { [weak self] (parsedModel, error) in
                        guard let parsedModel = parsedModel else {
                            completion(.failure, "Parsing Error")
                            return
                        }
                        self?.postList = parsedModel
                        completion(.success, "")
                    }
                }
                
            case .failure(let error):
                completion(.failure, error.localizedDescription)
            }
        }
    }
    
}
