//
//  Post.swift
//  JourneyDemoApp
//
//  Created by HarishPatidar on 06/08/22.
//

import Foundation

struct Post: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias Posts = [Post]
