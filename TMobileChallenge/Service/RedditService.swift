//
//  RedditService.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import Foundation
import Combine

class RedditFeedService: RedditFeedServiceType {
    
    var networkManager: NetworkManagerType
    var decoder: JSONDecoder
    
    init(networkManager: NetworkManagerType = NetworkManager(), decoder: JSONDecoder = JSONDecoder()) {
        self.networkManager = networkManager
        self.decoder = decoder
    }
    
    func getFeeds(from urlS: String) -> AnyPublisher<RedditResponse, Error> {
        
        guard let url = URL(string: urlS) else {
            let error = NSError(domain: URLError.errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "URL error"])
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        // printing URL for demostrate the next call
        print("Fetching URL:")
        print(url.absoluteURL)
        
        return networkManager
            .get(from: url)
            .decode(type: RedditResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    func getImage(from urlS: String) -> AnyPublisher<Data, Error> {
        
        guard let url = URL(string: urlS) else {
            let error = NSError(domain: URLError.errorDomain, code: 0, userInfo: [NSLocalizedDescriptionKey: "URL error"])
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        return networkManager
            .get(from: url)
            .eraseToAnyPublisher()
    }
    
}

