//
//  RedditStreamViewModel.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import Foundation
import Combine

class RedditFeedViewModel {
    
    // MARK: - internal properties
    var feedsBinding: Published<[RedditFeedData]>.Publisher { $feeds }
    var errorBinding: Published<String>.Publisher { $errorDescription }
    var rowUpdateBinding: Published<Int>.Publisher { $rowUpdate }
    var count: Int { feeds.count }
    
    // MARK: - private properties
    private let service: RedditFeedService
    private var publishers = Set<AnyCancellable>()
    
    @Published private var feeds = [RedditFeedData]()
    @Published private var errorDescription = ""
    @Published private var rowUpdate = 0
    
    private var after = ""
    private var isLoading = false
    private var imagesCache = NSCache<NSString, NSData>()
    
    // MARK: - init
    init(service: RedditFeedService = RedditFeedService()) {
        self.service = service
    }
    
    // MARK: - private func
    private func downloadImage(urlImage: String, key: NSString, row: Int) {
        // download image
        service
            .getImage(from: urlImage)
            .sink { _ in }
            receiveValue: { [unowned self] data in
                let nsData = NSData(data: data)
                imagesCache.setObject(nsData, forKey: key)
                rowUpdate = 0
            }
            .store(in: &publishers)
    }
    
    // MARK: - internal func
    func visibleRows(_ rows: [Int]) {
        let isLastRow = rows.contains(count - 1)
        if isLastRow {
            loadFeeds()
        }
    }
    
    func loadFeeds() {
        guard !isLoading else { return }
        isLoading = true
        
        // create URL
        let newURL = URLs.redditFeedURL.replacingOccurrences(of: URLs.keyAfter, with: after)
        
        // call service
        service
            .getFeeds(from: newURL)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self?.errorDescription = error.localizedDescription
                    self?.isLoading = false
                }
            }
            receiveValue: { [weak self] response in
                self?.after = response.data.after
                let feeds = response.data.children.map { $0.data }
                self?.feeds.append(contentsOf: feeds)
                self?.isLoading = false
            }
            .store(in: &publishers)
    }
    
    func getImageData(at row: Int) -> Data? {
        
        // validate if the row has an image
        guard let urlImage = feeds[row].thumbnail,
              urlImage.contains("https://") // validate if it is an url
        else { return nil }
        
        // validate if the image is on cache
        let key = NSString(string: urlImage)
        if let data = imagesCache.object(forKey: key) {
            return data as Data
        } else {
            downloadImage(urlImage: urlImage, key: key, row: row)
            return nil
        }
    }
    
    func getTitle(at row: Int) -> String? { feeds[row].title }
    
    func getNumComments(at row: Int) -> String? { "\(feeds[row].numComments)" }
    
    func geterrorDescription() -> String? { errorDescription }
}
