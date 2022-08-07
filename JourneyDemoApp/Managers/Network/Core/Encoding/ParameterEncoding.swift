//
//  ParameterEncoding.swift
//
//
//  Created byHarish Patidar on 5/2/18.
//  Copyright © 2018Harish Patidar. All rights reserved.
//

import UIKit
import CocoaLumberjack

public enum ParameterEncodingError: LocalizedError {
    
    case JSONSerializationFailed
    case MissingURL
    case InvalidType
    
    public var errorDescription: String? {
        switch self {
        case .JSONSerializationFailed:
            return "Failed to JSON encode parameters."
        
        case .MissingURL:
            return "URL encoding: Missing url."
            
        case .InvalidType:
            return "Passing invalid encoding type."
        }
    }
}

public enum ParameterEncoderBuilder {
    case formData(parameters: Parameters, images: MultipartImageParameters, files: MultipartURLParameters, boundary: String)
    case url(parameters: Parameters)
    case json(parameters: Parameters)
    case urlAndJson(parameters: Parameters, urlParameters: Parameters)
}

// MARK: Types of encoding
public class ParameterEncoding {
   
    static func encode(_ encoding: ParameterEncoderBuilder, urlRequest: inout URLRequest) throws {
        switch encoding {
            
        case .json(let parameters):
            guard let data = ParameterEncoding.jsonEncode(parameters) else { throw ParameterEncodingError.JSONSerializationFailed }
            urlRequest.httpBody = data
            
        case .url(let parameters):
            guard let url = urlRequest.url else { throw ParameterEncodingError.MissingURL }
            urlRequest.url = ParameterEncoding.urlEncode(url, parameters: parameters)
            
        case .urlAndJson(let parameters, let urlParameters):
            guard let data = ParameterEncoding.jsonEncode(parameters) else { throw ParameterEncodingError.JSONSerializationFailed }
            urlRequest.httpBody = data
            guard let url = urlRequest.url else { throw ParameterEncodingError.MissingURL }
            urlRequest.url = ParameterEncoding.urlEncode(url, parameters: urlParameters)

        case .formData(let parameters, let images, let files, let boundary):
            urlRequest.httpBody = ParameterEncoding.formData(parameters: parameters, images: images, files: files, boundary: boundary)
        }
    }
}

// JSON Encoding
extension ParameterEncoding {
    private static func jsonEncode(_ parameters: Parameters) -> Data? {
        return try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    }
}

// URL Encoding
extension ParameterEncoding {
    private static func urlEncode(_ url: URL, parameters: Parameters) -> URL {
        guard !parameters.isEmpty, var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return url
        }
        
        var queryItems: [URLQueryItem] = []
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            queryItems.append(queryItem)
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}

// Form Data Encoding

extension ParameterEncoding {
    
    private static func formData(parameters: Parameters, images: MultipartImageParameters, files: MultipartURLParameters, boundary: String) -> Data {
        
        var formData = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        if parameters.count > 0 {
            let fData = ParameterEncoding.encodeMultipartFormData(formData, Paramters: parameters, boundaryPrefix: boundaryPrefix)
            formData.append(fData)
        }
        
        if images.count > 0 {
            for (key, value) in images {
                for i in 0..<value.count {
                    if let imageData = value[i].jpegData(compressionQuality: 0.5) {
                        formData.append(boundaryPrefix.data(using: .utf8)!)
                        formData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"image\(i).jpeg\"\r\n".data(using: .utf8)!)
                        formData.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                        formData.append(imageData)
                        formData.append("\r\n".data(using: .utf8)!)
                    }
                }
            }
        }
        
        if files.count > 0 {
            for (key, value) in files {
                for i in 0..<value.count {
                    
                    var urlData: Data?
                    do {
                        urlData = try Data(contentsOf: value[i], options: Data.ReadingOptions.alwaysMapped)
                    } catch _ {
                        urlData = nil
                        //                        return
                    }
                    
                    // change file name whatever you want
                    let mimetype = value[i].pathExtension.mimeType() ?? ""
                    let fileExtension = value[i].pathExtension
                    let filename = "media_\(i).\(fileExtension)"
                    
                    formData.append(boundaryPrefix.data(using: .utf8)!)
                    formData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
                    formData.append("Content-Type: \(mimetype)\r\n\r\n".data(using: .utf8)!)
                    formData.append(urlData!)
                    formData.append("\r\n".data(using: .utf8)!)
                }
            }
        }
        
        formData.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return formData
    }
}
  
extension ParameterEncoding {

    //Method for endocing the multipartform data
    private static func encodeMultipartFormData(_ formData: Data, Paramters dictPost: Parameters, boundaryPrefix: String) -> Data {
        var multipartFormData: Data = formData
        var count : Int  = 0
        for (key, value) in dictPost {
            count = count + 1
            print(count)
            if let _ = value as? String {
                multipartFormData.append(boundaryPrefix.data(using: .utf8)!)
                multipartFormData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                multipartFormData.append("\(value)\r\n".data(using: .utf8)!)
            } else {
                let formData = encodeParameters(multipartFormData, fromKey: key, value: value, boundaryPrefix: boundaryPrefix)
                multipartFormData.append(formData)
            }
        }
        return multipartFormData
    }
    
    //Method for endocing the multipartform data
    private static func encodeParameters(_ formData: Data, fromKey key: String, value: Any, boundaryPrefix: String) -> Data {
        var multipartFormData: Data = formData
        var count : Int  = 0
        if let dictionary = value as? [String: Any] {
            count = count + 1
            print("Test", count)
            for (nestedKey, value) in dictionary {
                let formData = encodeParameters(multipartFormData, fromKey: "\(key)[\(nestedKey)]", value: value, boundaryPrefix: boundaryPrefix)
                multipartFormData.append(formData)
            }
        } else if let array = value as? [Any] {
            for value in array {
                if key.contains("[]") {
                    let formData = encodeParameters(multipartFormData, fromKey: key, value: value, boundaryPrefix: boundaryPrefix)
                    multipartFormData.append(formData)
                } else {
                    let formData = encodeParameters(multipartFormData, fromKey: "\(key)[]", value: value, boundaryPrefix: boundaryPrefix)
                    multipartFormData.append(formData)
                }
            }
        } else {
            multipartFormData.append(boundaryPrefix.data(using: .utf8)!)
            multipartFormData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            multipartFormData.append("\(value)\r\n".data(using: .utf8)!)
        }        
        return multipartFormData
    }
}
