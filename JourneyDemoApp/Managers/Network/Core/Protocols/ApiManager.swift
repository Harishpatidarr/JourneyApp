//
//  ApiManager.swift
//  Harish
//
//  Created by Harish Patidar on 14/01/20.
//  Copyright © 2020 Harish Patidar. All rights reserved.
//

import Foundation

// MARK: - Protocol Declaration Manager Class
protocol ApiManager {
    func requestWithParameter(endPoint: HTTPRestApi, resultHandler: @escaping HTTPResult)
    func requestWithMultipartData(endPoint: HTTPRestApi, resultHandler: @escaping HTTPResult)
}
