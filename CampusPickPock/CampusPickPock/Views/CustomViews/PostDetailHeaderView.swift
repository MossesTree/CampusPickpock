//
//  PostDetailHeaderView.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class PostDetailHeaderView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .backgroundColor
        
        addSubview(titleLabel)
        addSubview(authorLabel)
        addSubview(dateLabel)
        addSubview(contentLabel)
        addSubview(imageScrollView)
        addSubview(dividerView)
        
        imageScrollView.addSubview(imageStackView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            imageScrollView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 16),
            imageScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageScrollView.heightAnchor.constraint(equalToConstant: 200),
            
            imageStackView.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            imageStackView.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor, constant: 16),
            imageStackView.trailingAnchor.constraint(equalTo: imageScrollView.trailingAnchor, constant: -16),
            imageStackView.bottomAnchor.constraint(equalTo: imageScrollView.bottomAnchor),
            imageStackView.heightAnchor.constraint(equalTo: imageScrollView.heightAnchor),
            
            dividerView.topAnchor.constraint(equalTo: imageScrollView.bottomAnchor, constant: 16),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dividerView.heightAnchor.constraint(equalToConstant: 8),
            dividerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(with post: Post) {
        titleLabel.text = post.title
        authorLabel.text = post.authorName
        dateLabel.text = formatDate(post.createdAt)
        contentLabel.text = post.isHidden ? "개인 정보가 포함된 게시글입니다" : post.content
        
        imageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if post.images.isEmpty {
            imageScrollView.isHidden = true
        } else {
            imageScrollView.isHidden = false
            for image in post.images {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 8
                imageView.translatesAutoresizingMaskIntoConstraints = false
                imageView.widthAnchor.constraint(equalToConstant: 180).isActive = true
                imageStackView.addArrangedSubview(imageView)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd HH:mm"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone(secondsFromGMT: 9 * 3600)
        return formatter.string(from: date)
    }
}

