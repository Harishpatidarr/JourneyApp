//
//  NetworkRouter.swift
// 
//
//  Created byHarish Patidar on 5/2/18.
//  Copyright © 2018Harish Patidar. All rights reserved.
//

import Foundation

protocol NetworkRouter {
    associatedtype EndPoint: HTTPRequestConfiguration
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func requestFormData(_ route: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancle()
}
