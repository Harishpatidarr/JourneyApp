//
//  HTTPTask.swift
// 
//
//  Created byHarish Patidar on 5/2/18.
//  Copyright © 2018Harish Patidar. All rights reserved.
//

import UIKit

// MARK: - HTTPTask Methods
public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil)
    case requestParametersAndHeaders(bodyParameters: Parameters? = nil, urlParameters: Parameters? = nil, additionHeaders: HTTPHeaders?)
    case requestParametersWithImages(bodyParameters: Parameters? = nil, images: MultipartImageParameters? = [:], urls: MultipartURLParameters = [:])
}

