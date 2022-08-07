//
//  NetworkManager.swift
// 
//
//  Created byHarish Patidar on 3/2/19.
//  Copyright © 2018Harish Patidar. All rights reserved.
//

import Foundation

var Manager: ApiManager  {
    return NetworkManager.shared
}

struct NetworkManager: ApiManager {
    
    static let shared = NetworkManager()
    private let router = Router<HTTPRestApi>()
    
    // MARK: - Generic Api Call
    /* This method is for call post api, it will return model class object, success message or erorr message and true/false. */
    func requestWithParameter(endPoint: HTTPRestApi, resultHandler: @escaping HTTPResult) {
        router.request(endPoint) { (data, response, error) in
            HTTPRestApiResponse.handleHTTPResponse(endPoint: endPoint, data: data, response: response, error: error, resultHandler: resultHandler)
        }
    }
    
    // THIS METHOD IS USED FOR UPLOAD MUILTIPART DATA, (LIKE: IMAGES, DOCUMENTS, AUDIO AND VIDEO)
    
    func requestWithMultipartData(endPoint: HTTPRestApi, resultHandler: @escaping HTTPResult) {
        router.requestFormData(endPoint) { data, response, error in
            HTTPRestApiResponse.handleHTTPResponse(endPoint: endPoint, data: data, response: response, error: error, resultHandler: resultHandler)
        }
    }
}


