//
//  RedditDataResponse.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import Foundation

struct RedditDataResponse: Decodable {
    let after: String
    let children: [RedditFeed]
}
