//
//  RedditViewController.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import UIKit
import Combine

class RedditListViewController: UIViewController {
    
    // MARK:- privates properties
    lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(RedditCell.self, forCellReuseIdentifier: RedditCell.identifier)
        return tableview
    }()
    private let redditFeedViewModel = RedditFeedViewModel()
    private var subscribers = Set<AnyCancellable>()
    
    // MARK:- UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        setupBinding()
    }
    
    // MARK:- private func
    private func setUpUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        // configure constraint
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func setupBinding() {
        // binding for feeds
        redditFeedViewModel
            .feedsBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &subscribers)
        
        redditFeedViewModel.loadFeeds()
        
        // binding for error
        redditFeedViewModel
            .errorBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.showErrorAlert()
            }
            .store(in: &subscribers)
        
        // binding update row when get the image
        redditFeedViewModel
            .rowUpdateBinding
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] row in
                self?.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
            }
            .store(in: &subscribers)
    }
    
    private func showErrorAlert() {
        let alert = UIAlertController(title: "Error", message: redditFeedViewModel.geterrorDescription(), preferredStyle: .alert)
        let acceptButton = UIAlertAction(title: "Accept", style: .default)
        alert.addAction(acceptButton)
        present(alert, animated: true)
    }
}

// MARK:- UITableViewDataSource
extension RedditListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditFeedViewModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: RedditCell.identifier, for: indexPath) as! RedditCell
        let title = redditFeedViewModel.getTitle(at: row)
        let numComments = redditFeedViewModel.getNumComments(at: row)
        let imageData = redditFeedViewModel.getImageData(at: row)
        cell.configureCell(title: title, numComments: numComments, imageData: imageData)
        return cell
    }
    
}

// MARK:- UITableViewDelegate
extension RedditListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

// MARK:- UITableViewDelegate
extension RedditListViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexes = tableView.indexPathsForVisibleRows ?? []
        let rows = indexes.map { $0.row }
        redditFeedViewModel.visibleRows(rows)
    }
}
