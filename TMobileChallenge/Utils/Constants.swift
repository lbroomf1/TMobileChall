//
//  Constants.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import Foundation

enum URLs {
    static let urlBase = "https://www.reddit.com/.json"
    static let keyAfter = "$AFTER_KEY"
    static let redditFeedURL = "\(urlBase)?after=\(keyAfter)"
}
