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
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 15) {
            let descriptor = pretendardFont.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold.rawValue]])
            label.font = UIFont(descriptor: descriptor, size: 15)
        } else {
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        label.textColor = .primaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 10) {
            let descriptor = pretendardFont.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium.rawValue]])
            label.font = UIFont(descriptor: descriptor, size: 10)
        } else {
            label.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        }
        label.textColor = UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 13) {
            let descriptor = pretendardFont.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium.rawValue]])
            label.font = UIFont(descriptor: descriptor, size: 13)
        } else {
            label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        }
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
        
        // 셀 전체 배경 투명하게 설정
        backgroundColor = .clear
        selectionStyle = .none
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // contentView 스타일 설정
        contentView.backgroundColor = UIColor(red: 0xF7/255.0, green: 0xF7/255.0, blue: 0xF7/255.0, alpha: 1.0)
        contentView.layer.cornerRadius = 12
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0xDD/255.0, green: 0xDD/255.0, blue: 0xDD/255.0, alpha: 1.0).cgColor
        
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(joopjoopButton)
        
        // 줍줍버튼 액션 추가
        joopjoopButton.addTarget(self, action: #selector(joopjoopButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // contentView 높이를 81로 고정 (사진 75 + 상단 6)
            contentView.heightAnchor.constraint(equalToConstant: 81),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            
            // 왼쪽에 대표 사진 (좌단 6pt, 상단 6pt, 하단 여백 없음)
            thumbnailImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            thumbnailImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            thumbnailImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 75),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 75),
            
            // 오른쪽에 제목, 위치, 본문내용
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor, constant: 11),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1.6),
            locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            contentLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6),
            contentLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -6),
            
            // 줍줍버튼 (Lost 타입일 때만 표시)
            joopjoopButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            joopjoopButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
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
        
        // 홈에서는 줍줍버튼 안 보이게
        joopjoopButton.isHidden = true
        
        if let firstImage = post.images.first {
            thumbnailImageView.image = firstImage
            thumbnailImageView.isHidden = false
        } else {
            // 이미지가 없는 경우 기본 이미지 표시
            let config = UIImage.SymbolConfiguration(weight: .light)
            thumbnailImageView.image = UIImage(systemName: "photo", withConfiguration: config)
            thumbnailImageView.tintColor = .gray
            thumbnailImageView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
            thumbnailImageView.contentMode = .scaleAspectFit
            thumbnailImageView.isHidden = false
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

