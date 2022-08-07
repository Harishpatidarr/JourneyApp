//
//  Codable.swift
//  Harish
//
//  Created by Harish Patidar on 27/11/19.
//  Copyright © 2019 Harish Patidar. All rights reserved.
//

import Foundation
import CocoaLumberjack

extension Decodable {
    
    //To parse JSON data
    static func parseJSON(_ data: Data, completion: (Self?, Error?) -> ()) {
        do {
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase            
            let parsedData = try jsonDecoder.decode(self, from: data)
            completion(parsedData, nil)
        } catch {
            DDLogError("json error = \(error)")
            completion(nil, error)
        }
    }
}

extension Encodable {
    static func encodeJSON(_ dataArray: [Self], completion: (Data?, Error?) -> ()) {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
            let parsedData = try jsonEncoder.encode(dataArray)
            completion(parsedData, nil)
        } catch {
            DDLogError("json error = \(error)")
            completion(nil, error)
        }
    }
}
extension JSONEncoder {
    static func encode<T: Encodable>(from data: T) {
        do {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .prettyPrinted
            let json = try jsonEncoder.encode(data)
            let jsonString = String(data: json, encoding: .utf8)
            
            // iOS/Mac: Save to the App's documents directory
            //saveToDocumentDirectory(jsonString)
            
            // Mac: Output to file on the user's Desktop
            //saveToDesktop(jsonString)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
//    static private func saveToDocumentDirectory(_ jsonString: String?) {
//            guard let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
//            let fileURL = path.appendingPathComponent("Output.json")
//
//            do {
//                try jsonString?.write(to: fileURL, atomically: true, encoding: .utf8)
//            } catch {
//                print(error.localizedDescription)
//            }
//
//        }
        
//        static private func saveToDesktop(_ jsonString: String?) {
//            let homeURL = FileManager.default.homeDirectoryForCurrentUser
//            let desktopURL = homeURL.appendingPathComponent("Desktop")
//            let fileURL = desktopURL.appendingPathComponent("Output.json")
//
//            do {
//                try jsonString?.write(to: fileURL, atomically: true, encoding: .utf8)
//            } catch {
//                print(error.localizedDescription)
//            }
//        }
    }
