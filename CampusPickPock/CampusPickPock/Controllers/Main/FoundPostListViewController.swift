//
//  FoundPostListViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class FoundPostListViewController: UIViewController {
    
    private var postingItems: [PostingItem] = []
    private var currentPage = 0
    private let pageSize = 20
    
    // MARK: - Custom Navigation Header
    private let customNavHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        // DefaultBackIcon을 48x48 크기로 설정
        if let backIcon = UIImage(named: "DefaultBackIcon") {
            let size = CGSize(width: 48, height: 48)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            backIcon.draw(in: CGRect(origin: .zero, size: size))
            let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // 원본 색상을 유지하기 위해 renderingMode 설정
            button.setImage(resizedIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        // 색상 명시적으로 설정 (rgba(19, 45, 100, 1))
        button.tintColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주인을 찾아요"
        label.font = UIFont.pretendardBold(size: 20)
        label.textColor = UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍과 함께 찾아보세요"
        label.font = UIFont.pretendardMedium(size: 13)
        label.textColor = UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Category Filter Section
    private let categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let categoryDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Posts Section
    private let postsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var posts: [Post] = []
    private var selectedCategory = "전체"
    private var filteredPostingItems: [PostingItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupCategoryButtons()
        loadFoundPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFoundPosts()
    }
    
    private func loadFoundPosts() {
        APIService.shared.getPostingList(type: "FOUND", page: currentPage, pageSize: pageSize) { [weak self] result in
            switch result {
            case .success(let postingItems):
                DispatchQueue.main.async {
                    if self?.currentPage == 0 {
                        self?.postingItems = postingItems
                    } else {
                        self?.postingItems.append(contentsOf: postingItems)
                    }
                    self?.filterPosts()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("❌ 습득물 게시물 로드 실패: \(error.localizedDescription)")
                    self?.showAlert(message: "게시물을 불러오는데 실패했습니다.")
                }
            }
        }
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add custom header
        view.addSubview(customNavHeader)
        customNavHeader.addSubview(backButton)
        customNavHeader.addSubview(titleLabel)
        customNavHeader.addSubview(subtitleLabel)
        
        view.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        view.addSubview(categoryDividerLine)
        
        view.addSubview(postsTableView)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Custom navigation header
            customNavHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavHeader.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: customNavHeader.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Category Section
            categoryScrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 12),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
            
            categoryDividerLine.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 19),
            categoryDividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryDividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryDividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Posts Table View
            postsTableView.topAnchor.constraint(equalTo: categoryDividerLine.bottomAnchor, constant: 3),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(FoundPostCell.self, forCellReuseIdentifier: "FoundPostCell")
    }
    
    private func setupCategoryButtons() {
        let categories = ["전체", "전자제품", "지갑·카드", "의류·잡화", "학용품", "생활용품", "기타"]
        
        for (index, category) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = UIFont.pretendardMedium(size: 15)
            button.layer.cornerRadius = 10
            button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                // 첫 번째 버튼은 선택된 상태로 설정
                button.backgroundColor = UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(red: 0xCE/255.0, green: 0xD6/255.0, blue: 0xE9/255.0, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0), for: .normal)
            }
            
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            button.tag = index
            
            categoryStackView.addArrangedSubview(button)
            
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    @objc private func backTapped() {
        print("🔙 FoundPostListViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        // 모든 버튼을 기본 상태로 변경
        for subview in categoryStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.backgroundColor = UIColor(red: 0xCE/255.0, green: 0xD6/255.0, blue: 0xE9/255.0, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0), for: .normal)
            }
        }
        
        // 선택된 버튼을 활성 상태로 변경
        sender.backgroundColor = UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
        
        // 카테고리 업데이트
        let categories = ["전체", "전자제품", "지갑·카드", "의류·잡화", "학용품", "생활용품", "기타"]
        selectedCategory = categories[sender.tag]
        
        filterPosts()
    }
    
    private func filterPosts() {
        if selectedCategory == "전체" {
            filteredPostingItems = postingItems
        } else {
            // 카테고리 매핑
            let categoryMap: [String: [String]] = [
                "전자제품": ["전자제품"],
                "지갑·카드": ["지갑·카드", "지갑 및 카드"],
                "의류·잡화": ["의류·잡화", "의류 및 잡화"],
                "학용품": ["학용품"],
                "생활용품": ["생활용품"],
                "기타": []
            ]
            
            let mappedCategories = categoryMap[selectedCategory] ?? []
            
            if mappedCategories.isEmpty {
                // "기타" 카테고리인 경우, 매핑된 카테고리가 아닌 모든 항목을 표시
                let allMappedCategories = categoryMap.flatMap { $0.value }
                filteredPostingItems = postingItems.filter { item in
                    guard let category = item.postingCategory else { return true }
                    return !allMappedCategories.contains(category)
                }
            } else {
                filteredPostingItems = postingItems.filter { item in
                    guard let category = item.postingCategory else { return false }
                    return mappedCategories.contains(category)
                }
            }
        }
        
        postsTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FoundPostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPostingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundPostCell", for: indexPath) as! FoundPostCell
        let postingItem = filteredPostingItems[indexPath.row]
        
        // PostingItem을 Post로 변환
        let post = Post(
            id: String(postingItem.postingId),
            postingId: postingItem.postingId,
            title: postingItem.postingTitle,
            content: postingItem.postingContent,
            location: postingItem.itemPlace,
            imageUrl: postingItem.postingImageUrl,
            images: [],
            authorId: postingItem.postingWriterNickName ?? "익명",
            authorName: postingItem.postingWriterNickName ?? "익명",
            isHidden: false,
            createdAt: parseDate(postingItem.postingCreatedAt),
            commentCount: postingItem.commentCount,
            type: .found,
            isPickedUp: postingItem.isPickedUp
        )
        
        let isFirst = (indexPath.row == 0)
        let isLast = (indexPath.row == filteredPostingItems.count - 1)
        cell.configure(with: post, isFirst: isFirst, isLast: isLast)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let postingItem = filteredPostingItems[indexPath.row]
        
        // PostingItem을 Post로 변환
        let post = Post(
            id: String(postingItem.postingId),
            postingId: postingItem.postingId,
            title: postingItem.postingTitle,
            content: postingItem.postingContent,
            location: postingItem.itemPlace,
            imageUrl: postingItem.postingImageUrl,
            images: [],
            authorId: postingItem.postingWriterNickName ?? "익명",
            authorName: postingItem.postingWriterNickName ?? "익명",
            isHidden: false,
            createdAt: parseDate(postingItem.postingCreatedAt),
            commentCount: postingItem.commentCount,
            type: .found,
            isPickedUp: postingItem.isPickedUp
        )
        
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func parseDate(_ dateString: String) -> Date {
        var date: Date?
        
        // ISO8601DateFormatter 시도 (fractional seconds 포함)
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let parsedDate = iso8601Formatter.date(from: dateString) {
            date = parsedDate
        } else {
            // DateFormatter들로 시도
            let dateFormatters: [DateFormatter] = [
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
                    f.timeZone = TimeZone(abbreviation: "UTC")
                    return f
                }(),
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    f.timeZone = TimeZone(abbreviation: "UTC")
                    return f
                }(),
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
                    f.timeZone = TimeZone(abbreviation: "UTC")
                    return f
                }()
            ]
            
            for formatter in dateFormatters {
                if let parsedDate = formatter.date(from: dateString) {
                    date = parsedDate
                    break
                }
            }
        }
        
        guard let date = date else {
            print("⚠️ 날짜 파싱 실패: \(dateString), 현재 시간 반환")
            return Date()
        }
        
        // Date 객체는 절대 시간이므로 UTC로 파싱한 Date를 그대로 반환
        // 시간 비교는 FoundPostCell의 formatRelativeTime에서 처리됨
        return date
    }
}
// MARK: - FoundPostCell
class FoundPostCell: UITableViewCell {
    
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
        // Pretendard Variable Regular 15px (17px에서 2px 감소)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 15) {
            label.font = UIFont(descriptor: pretendardFont.fontDescriptor, size: 15)
        } else {
            label.font = UIFont.systemFont(ofSize: 15)
        }
        label.textColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
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
        // Pretendard Variable SemiBold 18px (20px에서 2px 감소)
        label.font = UIFont.pretendardSemibold(size: 18)
        label.textColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
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
        button.titleLabel?.font = UIFont.pretendardMedium(size: 14)
        button.setTitleColor(UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 4)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 8)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        // Pretendard Variable Regular 14px (16px에서 2px 감소)
        label.font = UIFont.pretendardMedium(size: 14)
        label.textColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        label.adjustsFontSizeToFitWidth = false
        label.minimumScaleFactor = 1.0  // 폰트 크기 자동 조정 방지
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
        label.font = UIFont.pretendardMedium(size: 17)
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
    private var isLastCell = false
    private var dividerLineTopConstraint: NSLayoutConstraint?
    
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
            
            itemImageView.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            itemImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            itemImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            itemImageView.heightAnchor.constraint(equalToConstant: 200),
            
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: pickedUpButton.leadingAnchor, constant: -8),
            titleLabel.centerYAnchor.constraint(equalTo: pickedUpButton.centerYAnchor),
            
            pickedUpButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 20),
            pickedUpButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            pickedUpButton.widthAnchor.constraint(equalToConstant: 75),
            pickedUpButton.heightAnchor.constraint(equalToConstant: 24),
            
            clockIcon.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            clockIcon.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            clockIcon.widthAnchor.constraint(equalToConstant: 16),
            clockIcon.heightAnchor.constraint(equalToConstant: 16),
            
            locationTimeLabel.centerYAnchor.constraint(equalTo: clockIcon.centerYAnchor),
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
            commentCountLabel.leadingAnchor.constraint(equalTo: commentIcon.trailingAnchor, constant: 5)
        ]
        
        if let dividerLineTopConstraint = dividerLineTopConstraint {
            constraints.append(dividerLineTopConstraint)
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with post: Post, isFirst: Bool = false, isLast: Bool = false) {
        self.isFirstCell = isFirst
        self.isLastCell = isLast
        
        usernameLabel.text = post.authorName
        titleLabel.text = post.title
        locationTimeLabel.text = "\(post.location ?? "위치 없음") | \(formatRelativeTime(post.createdAt))"
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
        
        // Found 타입일 때는 줍줍 버튼 숨김
        if post.type == .found {
            pickedUpButton.isHidden = true
        } else {
            // Lost 타입일 때만 isPickedUp 상태에 따라 버튼 표시
            configureJoopjoopButton(isPickedUp: post.isPickedUp)
        }
        
        // 구분선 위치 설정 - 마지막 셀이 아닐 때만 댓글 아이콘 아래 15pt 위치에 표시
        if isLastCell {
            dividerLine.isHidden = true
        } else {
            dividerLine.isHidden = false
            dividerLineTopConstraint?.isActive = false
            dividerLineTopConstraint = dividerLine.topAnchor.constraint(equalTo: commentIcon.bottomAnchor, constant: 15)
            dividerLineTopConstraint?.isActive = true
        }
        
        print("📅 Found 포스팅 시간 정보:")
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
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        print("   시간 차이: \(timeInterval)초 (\(timeInterval/60)분, \(timeInterval/3600)시간)")
        
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

