//
//  Comment.swift
//  JourneyDemoApp
//
//  Created by HarishPatidar on 06/08/22.
//

import Foundation

struct Comment: Codable {
    let postID, id: Int
    let name, email, body: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case id, name, email, body
    }
}

typealias Comments = [Comment]
