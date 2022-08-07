//
//  Router.swift
// 
//
//  Created byHarish Patidar on 5/2/18.
//  Copyright © 2018Harish Patidar. All rights reserved.
//

import UIKit
import CocoaLumberjack

class Router<EndPoint: HTTPRequestConfiguration>: NetworkRouter {
    
    private var task: URLSessionTask?
    
    private lazy var urlSession: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    
    // MARK: - HTTPTask Methods
    
    func request(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = urlSession
        do {
            let request = try self.buildRequest(from: route)
            if route.encoding == .formData {
                NetworkLogger.log(request: request, route: route)
            } else {
                NetworkLogger.log(request: request)
            }
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                completion(data, response, error)
            })
        }catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func requestFormData(_ route: EndPoint, completion: @escaping NetworkRouterCompletion) {
        let session = urlSession
        do {
            
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request, route: route)
            guard let data = request.httpBody else { return }
            task = session.uploadTask(with: request, from: data) { (data, response, error) in
                completion(data, response, error)
            }
            
        } catch {
            completion(nil , nil, error)
        }
        self.task?.resume()
    }
    
    func cancle() {
        self.task?.cancel()
    }
    
    // MARK: - Build URLRequest
    
    fileprivate func buildRequest(from route: EndPoint)throws -> URLRequest {
        var request = URLRequest(url: route.baseUrl.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
        request.httpMethod = route.method.rawValue
        
        if route.authorizationPolicy == .signedIn {
            self.addAdditionalHeaders(route.headers, request: &request)
        }
        
        let boundary = generateBoundry()
        
        do {
            try self.encode(&request, route: route, boundary: boundary)
            self.appendHeaders(&request, route: route, boundary: boundary)
            return request
        } catch {
            throw error
        }
    }
}


// MARK: - Parameter Encoding
extension Router {
    
    private func encode(_ request: inout URLRequest, route: EndPoint, boundary: String = "") throws {
        do {
            switch route.task {
            case .request: break
                
            case .requestParameters(let parameters, let urlParameters):
                switch route.encoding {
                case .json:
                    try ParameterEncoding.encode(.json(parameters: parameters ?? [:]), urlRequest: &request)
                    
                case .url:
                    try ParameterEncoding.encode(.url(parameters: urlParameters ?? [:]), urlRequest: &request)
                    
                case .urlAndJson:
                    try ParameterEncoding.encode(.urlAndJson(parameters: parameters ?? [:], urlParameters: urlParameters ?? [:]), urlRequest: &request)
                    
                case .formData:
                    try ParameterEncoding.encode(.formData(parameters: parameters ?? [:], images: [:], files: [:], boundary: boundary), urlRequest: &request)
                    
                default:
                    throw ParameterEncodingError.InvalidType
                }
                
            case .requestParametersAndHeaders(let parameters, let urlParameters, let additionalHeaders):
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                switch route.encoding {
                case .json:
                    try ParameterEncoding.encode(.json(parameters: parameters ?? [:]), urlRequest: &request)
                    
                case .url:
                    try ParameterEncoding.encode(.url(parameters: urlParameters ?? [:]), urlRequest: &request)
                    
                case .urlAndJson:
                    try ParameterEncoding.encode(.urlAndJson(parameters: parameters ?? [:], urlParameters: urlParameters ?? [:]), urlRequest: &request)
                    
                case .formData:
                    try ParameterEncoding.encode(.formData(parameters: parameters ?? [:], images: [:], files: [:], boundary: boundary), urlRequest: &request)
                    
                default:
                    throw ParameterEncodingError.InvalidType
                }
                
            case .requestParametersWithImages(let parameters, let images, let files):
                switch route.encoding {
                case .formData:
                    try ParameterEncoding.encode(.formData(parameters: parameters ?? [:], images: images ?? [:], files: files, boundary: boundary), urlRequest: &request)
                    
                default:
                    throw ParameterEncodingError.InvalidType
                }
            }
        } catch {
            throw error
        }
    }
}

// MARK: - HTTP Headers and Authorization
extension Router {
    private func appendHeaders(_ request: inout URLRequest, route: EndPoint, boundary: String = "") {
        let isFormData: Bool = route.encoding == .formData
        
        let contentType = isFormData ? "multipart/form-data; boundary=\(boundary)" : "application/json; charset=utf-8"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("keep-alive", forHTTPHeaderField: "Connection")
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {            
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func generateBoundry() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
}
