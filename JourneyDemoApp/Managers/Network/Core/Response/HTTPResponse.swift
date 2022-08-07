//
//  HTTPResponse.swift
//
//  Created by Harish Patidar
//

import Foundation

/// Localized response error.
public enum HTTPResponseError: LocalizedError {
    
    /// Response is not kind of `HTTPURLResponse`.
    case InvalidResponse
    
    /// Localized error message.
    public var errorDescription: String? {
        
        switch self {
            
        case .InvalidResponse:
            return "Failed to JSON encode parameters."
        }
    }
    
}

/// Class to hold and validate response object.
public struct HTTPResponse {
    
    /// Native url response object.
    public var urlResponse: URLResponse?
    
    /// Raw data received in response.
    public var data: Data?
    
    /// Return internal `data` object in response.
    public var serverResponse: Any? {
        //
        return self.getDataObject()
    }
    
    /// Initialize response object.
    /// - Parameters:
    ///   - urlResponse: Native url response object.
    ///   - data: Raw data received in response.
    public init(urlResponse: URLResponse?, data: Data?) {
        self.urlResponse = urlResponse
        self.data = data
    }
    
    /// Validates received response.
    /// - Parameter handler: Closure callback of the acknowledgement.
    internal func validate(_ handler: @escaping (Result<Void, Error>) -> Void) {
        ///
        guard let response = urlResponse as? HTTPURLResponse else {
            handler(.failure(HTTPResponseError.InvalidResponse))
            return
        }
        
        /// Validates response content-type and HTTP status code.
        if let contentType = response.allHeaderFields["Content-Type"] as? String,
            
            //contentType.contains("application/json"),
            
            let statusCode = HTTPStatusCode(rawValue: response.statusCode),
            
            (statusCode == .success || statusCode == .created),
            
            self.responseSuccess() {
            
            handler(.success(()))
            
            return
        }
        
        ///
        handler(.failure(NSError.error(response.statusCode, localizedDescription: "")))
        
    }
    
    /// Return the `data` object from response json.
    private func getDataObject() -> Any? {
        ///
        guard let json = serializeData() else { return nil }
        return json
    }
    
    /// Converts raw data to key/value object.
    private func serializeData() -> [Parameters]? {
        ///
        guard let data = data else { return nil }
        
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Parameters]
    }
    
    /// Return `success` value inside response json.
    private func responseSuccess() -> Bool {
        guard let json = serializeData() else {
            return false
        }
        return true
    }
}
