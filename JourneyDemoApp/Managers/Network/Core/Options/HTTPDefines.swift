//
//  HTTPDefines.swift
//  Harish
//
//  Created by Harish Patidar on 14/01/20.
//  Copyright © 2020 Harish Patidar. All rights reserved.
//

import Foundation
import UIKit

// MARK: Global Parameters
public typealias Parameters = [String: Any]
public typealias MultipartImageParameters = [String: [UIImage]]
public typealias MultipartURLParameters = [String: [URL]]

// Headers
public typealias HTTPHeaders = [String: String]

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> ()

///
public typealias HTTPResult = (Result<HTTPResponse, Error>) -> Void

///
internal extension NSError {
    
    static func error(_ code: Int, localizedDescription: String?) -> NSError {
        
        return NSError(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: [NSLocalizedDescriptionKey: localizedDescription ?? ""])
    }
    
}
