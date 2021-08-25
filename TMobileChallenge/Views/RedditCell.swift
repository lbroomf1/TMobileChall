//
//  RedditCell.swift
//  TMobileChallenge
//
//  Created by LB on 8/24/21.
//

import UIKit

class RedditCell: UITableViewCell {
    
    // MARK: - static properties
    static let identifier = "RedditCell"
    
    // MARK: - override
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private properties
    lazy private var feedImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy private var numCommentsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - internal func
    func configureCell(title: String?, numComments: String?, imageData: Data?) {
        
        setUpUI(imageData: imageData)
        
        titleLabel.text = title
        numCommentsLabel.text = "# comments: \(numComments ?? "")"
        
        feedImageView.image = nil
        if let data = imageData {
            feedImageView.image = UIImage(data: data)
        }
    }
    
    // MARK: - private func
    private func setUpUI(imageData: Data? = nil) {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(numCommentsLabel)
        // validate image constraint
        if let _ = imageData {
            stackView.addArrangedSubview(feedImageView)
        }
        
        contentView.addSubview(stackView)
        
        // setup constraint
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15.0).isActive = true
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15.0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15.0).isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15.0).isActive = true
    }
}
