//
//  PostListCell.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class PostListCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let clockIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ClockIcon1")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let locationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pickedUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 0xCE/255.0, green: 0xD6/255.0, blue: 0xE9/255.0, alpha: 1.0)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: "Pretendard Variable", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .medium)
        button.setTitleColor(UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 4)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CommentIcon3")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(red: 0xCE/255.0, green: 0xD6/255.0, blue: 0xE9/255.0, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard Variable", size: 17) ?? .systemFont(ofSize: 17)
        label.textColor = UIColor(red: 0x62/255.0, green: 0x5F/255.0, blue: 0x5F/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isFirstCell = false
    private var dividerLineTopConstraint: NSLayoutConstraint?
    private var itemImageViewTopConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(dividerLine)
        containerView.addSubview(profileImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(itemImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(clockIcon)
        containerView.addSubview(locationTimeLabel)
        containerView.addSubview(pickedUpButton)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(commentIcon)
        containerView.addSubview(commentCountLabel)
        
        dividerLineTopConstraint = dividerLine.topAnchor.constraint(equalTo: containerView.topAnchor)
        itemImageViewTopConstraint = itemImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12)
        
        var constraints = [
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            dividerLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            dividerLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            dividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 24),
            profileImageView.heightAnchor.constraint(equalToConstant: 24),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            itemImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            itemImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            itemImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: pickedUpButton.leadingAnchor, constant: -8),
            
            pickedUpButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            pickedUpButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            pickedUpButton.widthAnchor.constraint(equalToConstant: 75),
            pickedUpButton.heightAnchor.constraint(equalToConstant: 24),
            
            clockIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            clockIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            clockIcon.widthAnchor.constraint(equalToConstant: 16),
            clockIcon.heightAnchor.constraint(equalToConstant: 16),
            
            locationTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            locationTimeLabel.leadingAnchor.constraint(equalTo: clockIcon.trailingAnchor, constant: 5),
            
            descriptionLabel.topAnchor.constraint(equalTo: locationTimeLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            commentIcon.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            commentIcon.trailingAnchor.constraint(equalTo: commentCountLabel.leadingAnchor, constant: -2),
            commentIcon.widthAnchor.constraint(equalToConstant: 22),
            commentIcon.heightAnchor.constraint(equalToConstant: 20),
            commentIcon.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            
            commentCountLabel.centerYAnchor.constraint(equalTo: commentIcon.centerYAnchor),
            commentCountLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ]
        
        if let dividerLineTopConstraint = dividerLineTopConstraint {
            constraints.append(dividerLineTopConstraint)
        }
        
        if let itemImageViewTopConstraint = itemImageViewTopConstraint {
            constraints.append(itemImageViewTopConstraint)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with post: Post, isFirst: Bool = false, showProfile: Bool = true) {
        self.isFirstCell = isFirst
        
        // 프로필 표시 여부에 따라 UI 업데이트
        profileImageView.isHidden = !showProfile
        usernameLabel.isHidden = !showProfile
        
        if showProfile {
            usernameLabel.text = post.authorName
            // 프로필이 있을 때는 기존 제약조건 사용
            itemImageViewTopConstraint?.isActive = false
            itemImageViewTopConstraint = itemImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12)
            itemImageViewTopConstraint?.isActive = true
        } else {
            // 프로필이 없을 때는 이미지가 containerView.topAnchor에서 시작
            // 프로필이 있을 때와 동일한 위치(16 + 24 + 12 = 52)로 맞춤
            itemImageViewTopConstraint?.isActive = false
            itemImageViewTopConstraint = itemImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 52)
            itemImageViewTopConstraint?.isActive = true
        }
        
        titleLabel.text = post.title
        
        // post.type이 .found일 때만 위치 표시
        if post.type == .found {
            locationTimeLabel.text = "\(post.location ?? "위치 없음") | \(formatRelativeTime(post.createdAt))"
        } else {
            locationTimeLabel.text = formatRelativeTime(post.createdAt)
        }
        
        descriptionLabel.text = post.content
        commentCountLabel.text = "\(post.commentCount)"
        
        // 이미지 URL이 있으면 로드, 없으면 기본 이미지
        if let imageUrlString = post.imageUrl, let imageUrl = URL(string: imageUrlString) {
            loadImage(from: imageUrl)
        } else {
            let config = UIImage.SymbolConfiguration(weight: .light)
            itemImageView.image = UIImage(systemName: "photo", withConfiguration: config)
            itemImageView.tintColor = .gray
            itemImageView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
        }
        
        // isPickedUp 상태에 따라 버튼 표시 (found 타입일 때는 숨김)
        if post.type == .found {
            pickedUpButton.isHidden = true
        } else {
            configureJoopjoopButton(isPickedUp: post.isPickedUp)
        }
        
        // 구분선 위치 설정
        if !isFirstCell {
            dividerLine.isHidden = false
            // 프로필이 있을 때는 프로필아이콘으로부터, 없을 때는 containerView.topAnchor로부터 20 위쪽에 선 위치 설정
            dividerLineTopConstraint?.isActive = false
            if showProfile {
                dividerLineTopConstraint = dividerLine.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: -20)
            } else {
                dividerLineTopConstraint = dividerLine.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -20)
            }
            dividerLineTopConstraint?.isActive = true
        } else {
            dividerLine.isHidden = true
        }
        
        print("📅 PostListCell 포스팅 시간 정보:")
        print("   작성 시간: \(post.createdAt)")
        print("   현재 시간: \(Date())")
        print("   표시 시간: \(locationTimeLabel.text ?? "")")
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.itemImageView.image = image
                    self?.itemImageView.tintColor = nil
                    self?.itemImageView.backgroundColor = .clear
                }
            } else {
                DispatchQueue.main.async {
                    let config = UIImage.SymbolConfiguration(weight: .light)
                    self?.itemImageView.image = UIImage(systemName: "photo", withConfiguration: config)
                    self?.itemImageView.tintColor = .gray
                    self?.itemImageView.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.0)
                }
            }
        }.resume()
    }
    
    private func configureJoopjoopButton(isPickedUp: Bool) {
        let iconName = isPickedUp ? "FillStarIcon1" : "StarIcon1"
        
        // 뱃지 모양 설정 (높이 24의 절반인 12로 설정하면 둥근 사각형)
        pickedUpButton.layer.cornerRadius = 12
        
        if let originalImage = UIImage(named: iconName) {
            // 아이콘 크기를 21x21로 리사이즈
            let size = CGSize(width: 21, height: 21)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            originalImage.draw(in: CGRect(origin: .zero, size: size))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            pickedUpButton.setImage(resizedImage, for: .normal)
        }
        
        pickedUpButton.setTitle(" 줍줍", for: .normal)
        pickedUpButton.tintColor = UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0)
        pickedUpButton.isHidden = false
    }
    
    private func formatRelativeTime(_ date: Date) -> String {
        // 현재 시간 가져오기 (절대 시간, UTC 기준)
        let now = Date()
        
        // Date 객체는 절대 시간이므로, 두 Date의 차이를 직접 계산하면 정확한 시간 간격을 얻을 수 있음
        let timeInterval = now.timeIntervalSince(date)
        
        print("   시간 차이: \(timeInterval)초 (\(timeInterval/60)분, \(timeInterval/3600)시간)")
        
        return formatTimeInterval(timeInterval)
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        // 미래 시간인 경우 (음수)
        if timeInterval < 0 {
            return "방금 전"
        }
        
        if timeInterval < 60 {
            return "방금 전"
        } else if timeInterval < 3600 {
            let minutes = Int(timeInterval / 60)
            return "\(minutes)분 전"
        } else if timeInterval < 86400 {
            let hours = Int(timeInterval / 3600)
            return "\(hours)시간 전"
        } else {
            let days = Int(timeInterval / 86400)
            return "\(days)일 전"
        }
    }
}

