//
//  RedditServiceType.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import Foundation
import Combine

protocol RedditFeedServiceType {
    var networkManager: NetworkManagerType { get }
    var decoder: JSONDecoder { get }
    func getFeeds(from urlS: String) -> AnyPublisher<RedditResponse, Error>
    func getImage(from urlS: String) -> AnyPublisher<Data, Error>
}
