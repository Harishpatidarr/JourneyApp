//
//  NetworkLogger.swift
//  NetworkLayer
//
//

import Foundation
import CocoaLumberjack

class NetworkLogger {
    static func log(request: URLRequest?) {
        
        DDLogDebug("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        
        defer {
            DDLogDebug("\n - - - - - - - - - -  END - - - - - - - - - - \n")
        }
        
        let urlAsString = request?.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request?.httpMethod != nil ? "\(request?.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key, value) in request?.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        
        if let body = request?.httpBody {
            let bodyStr = NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? ""
            logOutput += "\n \(bodyStr)"
        }
        
        DDLogDebug(logOutput)
    }
    
    static func log(request: URLRequest?, route: HTTPRequestConfiguration) {
        
        DDLogDebug("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        
        defer {
            DDLogDebug("\n - - - - - - - - - -  END - - - - - - - - - - \n")
        }
        
        let urlAsString = request?.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request?.httpMethod != nil ? "\(request?.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key, value) in request?.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        
        switch route.task {
        case .requestParameters(let bodyParameters, _):
            logOutput += "\n \(bodyParameters ?? [:])"
        case .requestParametersAndHeaders(let bodyParameters, _, _):
            logOutput += "\n \(bodyParameters ?? [:])"
        case .requestParametersWithImages(let bodyParameters, _, _):
            logOutput += "\n \(bodyParameters ?? [:])"
        default:
            break
        }
        
        DDLogDebug(logOutput)
    }
    
    static func log(response: URLResponse?, data: Data?) {
        DDLogDebug("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        
        defer {
            DDLogDebug("\n - - - - - - - - - -  END - - - - - - - - - - \n")
        }
        
        DDLogDebug("Validating request: \(response?.url?.absoluteString ?? "") with HTTP status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        
        DDLogDebug("Response: \(data?.prettyPrintedJSONString ?? "")")
    }
    
    static func log(JSONResponse: [String: Any]) {
        DDLogDebug("Response: \(JSONResponse)")
    }
    
    static func log(JSONResponse: [String: Any], name: String = "") {
      
        DDLogDebug("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")

      defer {
        DDLogDebug("\n - - - - - - - - - -  END - - - - - - - - - - \n")
      }
      
      var logOutput = """
          """
      logOutput += "Event Name: \(name) \n"
      
      for (key, value) in JSONResponse {
        logOutput += "\(key): \(value) \n"
      }
        DDLogDebug("\(logOutput)")
    }
}

extension Data {
    var prettyPrintedJSONString: String { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
            let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
                let str = String(decoding: self, as: UTF8.self)
                return str
        }
        return prettyPrintedString as String
    }
}
