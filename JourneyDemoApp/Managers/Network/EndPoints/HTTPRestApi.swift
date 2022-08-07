//
//  APIEndPoints.swift
//
//  Created by Harish Patidar on 26/02/19.
//  Copyright © 2019 Harish Patidar. All rights reserved.
//

import Foundation
import UIKit

// MARK :- EndPoint Configuration
public enum HTTPRestApi {
    case getPosts
    case getComments
    case postDetail(_ id: String)
    case commentDetail(_ id: String)

}

// MARK: Parameter Declaration
extension HTTPRestApi: HTTPRequestConfiguration {
    var encoding: ParameterEncodingType {
        switch self {
        case .getPosts, .getComments, .postDetail, .commentDetail:
            return .url
        }
    }
    
    var baseUrl: URL {
        guard let devURL = URL(string: AppHostURL.base) else {
            fatalError("Development URL not configured")
        }
        return devURL
    }
    
    var path: String {
        switch self {
        case .getPosts:
            return "posts"
        case .getComments:
            return "comments"
        case .postDetail(let id):
            return "posts/" + id
        case .commentDetail(let id):
            return "comments/" + id
        }
    }
    
    var method: HTTPMethods {
        switch self {
        case .getPosts, .getComments, .postDetail, .commentDetail:
            return .get

        }
    }
    var task: HTTPTask {
        switch self {
            
        case .getPosts, .getComments, .postDetail, .commentDetail:
            return .requestParameters(bodyParameters: [:], urlParameters: [:])
            
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return ["authorization": ""]
    }
    
    var authorizationPolicy: HTTPAuthorizationPolicy {
        return .anonymous
    }
}
