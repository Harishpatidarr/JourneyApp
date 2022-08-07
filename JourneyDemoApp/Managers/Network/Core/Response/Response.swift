//
//  Response.swift
//  Harish
//
//  Created by Harish Patidar on 26/02/19.
//

import Foundation

struct Response: Decodable {
    let success: Bool
    let message: String?
    let error: [Message]?
    
    struct Message: Decodable {
        let message: String
    }
}
