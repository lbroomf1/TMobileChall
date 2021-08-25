//
//  NetworkManagerType.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import Foundation
import Combine

protocol NetworkManagerType {
    func get(from url: URL) -> AnyPublisher<Data, Error>
}
