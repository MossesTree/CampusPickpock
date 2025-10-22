//
//  PostCell.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

protocol PostCellDelegate: AnyObject {
    func postCellDidTapJoopjoop(_ cell: PostCell, post: Post)
}

class PostCell: UITableViewCell {
    
    weak var delegate: PostCellDelegate?
    private var post: Post?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .secondaryBackgroundColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let joopjoopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("줍줍", for: .normal)
        button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 0.1)
        button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true // 기본적으로 숨김
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(commentCountLabel)
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(joopjoopButton)
        
        // 줍줍버튼 액션 추가
        joopjoopButton.addTarget(self, action: #selector(joopjoopButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 80),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -12),
            
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            authorLabel.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            dateLabel.leadingAnchor.constraint(equalTo: authorLabel.trailingAnchor, constant: 8),
            dateLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            
            commentCountLabel.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 8),
            commentCountLabel.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            
            joopjoopButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            joopjoopButton.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -8),
            joopjoopButton.widthAnchor.constraint(equalToConstant: 60),
            joopjoopButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with post: Post) {
        self.post = post
        titleLabel.text = post.title
        contentLabel.text = post.isHidden ? "개인 정보가 포함된 게시글입니다" : post.content
        authorLabel.text = post.authorName
        dateLabel.text = formatDate(post.createdAt)
        commentCountLabel.text = "댓글 \(post.commentCount)"
        
        // Lost 타입일 때만 줍줍버튼 표시
        joopjoopButton.isHidden = post.type != .lost
        
        if let firstImage = post.images.first {
            thumbnailImageView.image = firstImage
            thumbnailImageView.isHidden = false
        } else {
            thumbnailImageView.isHidden = true
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
    
    @objc private func joopjoopButtonTapped() {
        guard let post = post else { return }
        delegate?.postCellDidTapJoopjoop(self, post: post)
    }
}

