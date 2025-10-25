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
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 2
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
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(joopjoopButton)
        
        // 줍줍버튼 액션 추가
        joopjoopButton.addTarget(self, action: #selector(joopjoopButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // 왼쪽에 대표 사진
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 60),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 60),
            
            // 오른쪽에 제목, 위치, 본문내용
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 4),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            // 줍줍버튼 (Lost 타입일 때만 표시)
            joopjoopButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            joopjoopButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            joopjoopButton.widthAnchor.constraint(equalToConstant: 60),
            joopjoopButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with post: Post) {
        self.post = post
        titleLabel.text = post.title
        locationLabel.text = post.location ?? "위치 정보 없음"
        
        // 본문내용 일부분만 표시 (최대 50자)
        let content = post.isHidden ? "개인 정보가 포함된 게시글입니다" : post.content
        if content.count > 50 {
            contentLabel.text = String(content.prefix(50)) + "..."
        } else {
            contentLabel.text = content
        }
        
        // Lost 타입일 때만 줍줍버튼 표시
        joopjoopButton.isHidden = post.type != .lost
        
        if let firstImage = post.images.first {
            thumbnailImageView.image = firstImage
            thumbnailImageView.isHidden = false
        } else {
            thumbnailImageView.isHidden = true
        }
    }
    
    func setThumbnailImage(_ image: UIImage) {
        thumbnailImageView.image = image
        thumbnailImageView.isHidden = false
    }
    
    @objc private func joopjoopButtonTapped() {
        guard let post = post else { return }
        delegate?.postCellDidTapJoopjoop(self, post: post)
    }
}

