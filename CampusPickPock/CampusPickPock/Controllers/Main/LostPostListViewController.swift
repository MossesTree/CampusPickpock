//
//  LostPostListViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

protocol LostPostCellDelegate: AnyObject {
    func lostPostCellDidTapJoopjoop(_ cell: LostPostCell, post: Post)
}

class LostPostListViewController: UIViewController {
    
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
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(red: 0x51/255.0, green: 0x5B/255.0, blue: 0x70/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "잃어버렸어요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍이 찾아드릴게요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
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
        loadLostPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLostPosts()
    }
    
    private func loadLostPosts() {
        APIService.shared.getPostingList(type: "LOST", page: currentPage, pageSize: pageSize) { [weak self] result in
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
                    print("❌ 분실물 게시물 로드 실패: \(error.localizedDescription)")
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
        
        view.addSubview(postsTableView)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Custom navigation header
            customNavHeader.topAnchor.constraint(equalTo: view.topAnchor),
            customNavHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavHeader.heightAnchor.constraint(equalToConstant: 100),
            
            backButton.leadingAnchor.constraint(equalTo: customNavHeader.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: customNavHeader.topAnchor, constant: 70),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            subtitleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            
            // Category Section
            categoryScrollView.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor, constant: 16),
            categoryScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
            
            // Posts Table View
            postsTableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 16),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(LostPostCell.self, forCellReuseIdentifier: "LostPostCell")
    }
    
    private func setupCategoryButtons() {
        let categories = ["전체", "전자제품", "지갑·카드", "의류·잡화", "학용품", "생활용품", "기타"]
        
        for (index, category) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
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
        print("🔙 LostPostListViewController 뒤로가기 버튼 탭됨")
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
extension LostPostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPostingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostPostCell", for: indexPath) as! LostPostCell
        let postingItem = filteredPostingItems[indexPath.row]
        
        // PostingItem을 Post로 변환
        let post = Post(
            id: String(postingItem.postingId),
            postingId: postingItem.postingId,
            title: postingItem.postingTitle,
            content: postingItem.postingContent,
            imageUrl: postingItem.postingImageUrl,
            images: [],
            authorId: postingItem.postingWriterNickName ?? "익명",
            authorName: postingItem.postingWriterNickName ?? "익명",
            isHidden: false,
            createdAt: parseDate(postingItem.postingCreatedAt),
            commentCount: postingItem.commentCount,
            type: .lost
        )
        
        cell.configure(with: post)
        cell.delegate = self
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
            imageUrl: postingItem.postingImageUrl,
            images: [],
            authorId: postingItem.postingWriterNickName ?? "익명",
            authorName: postingItem.postingWriterNickName ?? "익명",
            isHidden: false,
            createdAt: parseDate(postingItem.postingCreatedAt),
            commentCount: postingItem.commentCount,
            type: .lost
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
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
        print("📅 Lost 포스팅 파싱:")
        print("   원본: \(dateString)")
        print("   파싱된 날짜(UTC): \(date)")
        print("   현재 시간: \(now)")
        print("   시간 차이(변환 전): \(timeInterval)초 (\(timeInterval/60)분, \(timeInterval/3600)시간)")
        
        // 서버가 UTC로 보내므로 한국 시간(KST)으로 변환 (UTC+9)
        let koreanDate = date.addingTimeInterval(9 * 60 * 60)
        let adjustedInterval = now.timeIntervalSince(koreanDate)
        print("   한국 시간: \(koreanDate)")
        print("   시간 차이(변환 후): \(adjustedInterval)초 (\(adjustedInterval/60)분, \(adjustedInterval/3600)시간)")
        
        return koreanDate
    }
}

// MARK: - LostPostCellDelegate
extension LostPostListViewController: LostPostCellDelegate {
    func lostPostCellDidTapJoopjoop(_ cell: LostPostCell, post: Post) {
        // PostingItem에서 postingId 찾기
        guard let postingItem = postingItems.first(where: { $0.postingTitle == post.title }) else {
            print("❌ 해당 게시글을 찾을 수 없습니다.")
            return
        }
        
        print("🎯 줍줍 버튼 클릭: postingId = \(postingItem.postingId)")
        
        // 로딩 상태 표시
        cell.joopjoopButton.setTitle("줍줍 중...", for: .normal)
        cell.joopjoopButton.isEnabled = false
        
        APIService.shared.markPostAsPickedUp(postingId: postingItem.postingId) { [weak self] result in
            DispatchQueue.main.async {
                // 버튼 상태 복원
                cell.joopjoopButton.setTitle("줍줍", for: .normal)
                cell.joopjoopButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    print("✅ 줍줍 성공: \(response.message)")
                    
                    // 성공 알림
                    let alert = UIAlertController(title: "줍줍 완료", message: "해당 게시글이 줍줍되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                    
                    // 게시글 목록 새로고침
                    self?.currentPage = 0
                    self?.loadLostPosts()
                    
                case .failure(let error):
                    print("❌ 줍줍 실패: \(error.localizedDescription)")
                    
                    // 실패 알림
                    let alert = UIAlertController(title: "줍줍 실패", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}

// MARK: - LostPostCell
class LostPostCell: UITableViewCell {
    
    weak var delegate: LostPostCellDelegate?
    private var post: Post?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let joopjoopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("줍줍", for: .normal)
        button.setImage(UIImage(systemName: "sparkles"), for: .normal)
        button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    private let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "text.bubble"), for: .normal)
        button.setTitle("6", for: .normal)
        button.tintColor = .secondaryTextColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
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
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(itemImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(joopjoopButton)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(commentButton)
        
        // 줍줍버튼 액션 추가
        joopjoopButton.addTarget(self, action: #selector(joopjoopButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
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
            
            titleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: joopjoopButton.leadingAnchor, constant: -8),
            
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            joopjoopButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            joopjoopButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            joopjoopButton.widthAnchor.constraint(equalToConstant: 60),
            joopjoopButton.heightAnchor.constraint(equalToConstant: 32),
            
            descriptionLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            commentButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            commentButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            commentButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with post: Post) {
        self.post = post
        usernameLabel.text = post.authorName
        titleLabel.text = post.title
        timeLabel.text = formatRelativeTime(post.createdAt)
        descriptionLabel.text = post.content
        
        // 이미지 URL이 있으면 로드, 없으면 기본 이미지
        if let imageUrlString = post.imageUrl, let imageUrl = URL(string: imageUrlString) {
            loadImage(from: imageUrl)
        } else {
            itemImageView.image = UIImage(systemName: "airpods")
            itemImageView.tintColor = .gray
        }
        
        print("📅 Lost 포스팅 시간 정보:")
        print("   작성 시간: \(post.createdAt)")
        print("   현재 시간: \(Date())")
        print("   표시 시간: \(timeLabel.text ?? "")")
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self?.itemImageView.image = image
                    self?.itemImageView.tintColor = nil
                }
            } else {
                DispatchQueue.main.async {
                    self?.itemImageView.image = UIImage(systemName: "airpods")
                    self?.itemImageView.tintColor = .gray
                }
            }
        }.resume()
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
    
    @objc private func joopjoopButtonTapped() {
        guard let post = post else { return }
        delegate?.lostPostCellDidTapJoopjoop(self, post: post)
    }
}
