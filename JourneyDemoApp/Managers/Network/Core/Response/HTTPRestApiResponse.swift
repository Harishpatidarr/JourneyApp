//
//  HTTPResponse.swift
//  Harish
//
//  Created by Harish Patidar on 14/01/20.
//  Copyright © 2020 Harish Patidar. All rights reserved.
//

import Foundation
import CocoaLumberjack

// MARK: - Handle Response

struct HTTPRestApiResponse {
    static func handleHTTPResponse(endPoint: HTTPRestApi?, data: Data?, response: URLResponse?, error: Error?, resultHandler: @escaping HTTPResult) {
        ///
        if let error = error {
            resultHandler(.failure(error))
            return
        }
        
        let httpResponse = HTTPResponse(urlResponse: response, data: data)
        
        NetworkLogger.log(response: response, data: data)
        
        ///
        validateResponse(httpResponse, resultHandler: resultHandler)
    }
    
    /// Performs validation on response.
    /// - Parameter response: Response object.
    static private func validateResponse(_ response: HTTPResponse, resultHandler: @escaping HTTPResult) {
        ///
        response.validate { (result) in
            ///
            switch result {
            case .success():
                resultHandler(.success(response))
                
            case .failure(let error):
                resultHandler(.failure(error))
            }
        }
    }
    
}
