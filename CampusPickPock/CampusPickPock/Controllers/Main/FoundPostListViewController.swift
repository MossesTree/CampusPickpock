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
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Header Section
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "주인을 찾아요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍과 함께 찾아보세요"
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var posts: [Post] = []
    private var selectedCategory = "전체"
    
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
                    self?.postsTableView.reloadData()
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
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        
        setupCustomBackButton()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        contentView.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        
        contentView.addSubview(postsTableView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header Section
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 100),
            
            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            // Category Section
            categoryScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            categoryScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
            
            // Posts Table View
            postsTableView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 16),
            postsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postsTableView.heightAnchor.constraint(equalToConstant: 600)
        ])
    }
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(FoundPostCell.self, forCellReuseIdentifier: "FoundPostCell")
    }
    
    private func setupCategoryButtons() {
        let categories = ["전체", "전자 제품", "카드/지갑", "기타"]
        
        for (index, category) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 20
            button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                // 첫 번째 버튼은 선택된 상태로 설정
                button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
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
                button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
            }
        }
        
        // 선택된 버튼을 활성 상태로 변경
        sender.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
        
        // 카테고리 업데이트
        let categories = ["전체", "전자 제품", "카드/지갑", "기타"]
        selectedCategory = categories[sender.tag]
        
        loadPosts()
    }
    
    private func loadPosts() {
        // 샘플 데이터 로드
        posts = DataManager.shared.posts.filter { post in
            if selectedCategory == "전체" {
                return true
            }
            // 실제로는 post에 category 필드가 있어야 함
            return true
        }
        
        postsTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FoundPostListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoundPostCell", for: indexPath) as! FoundPostCell
        let postingItem = postingItems[indexPath.row]
        
        // PostingItem을 Post로 변환
        let post = Post(
            id: String(postingItem.postingId),
            postingId: postingItem.postingId,
            title: postingItem.postingTitle,
            content: postingItem.postingContent,
            images: [],
            authorId: postingItem.postingWriterNickName ?? "익명",
            authorName: postingItem.postingWriterNickName ?? "익명",
            isHidden: false,
            createdAt: parseDate(postingItem.postingCreatedAt),
            commentCount: postingItem.commentCount,
            type: .found
        )
        
        cell.configure(with: post)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let postingItem = postingItems[indexPath.row]
        
        // PostingItem을 Post로 변환
        let post = Post(
            id: String(postingItem.postingId),
            postingId: postingItem.postingId,
            title: postingItem.postingTitle,
            content: postingItem.postingContent,
            images: [],
            authorId: postingItem.postingWriterNickName ?? "익명",
            authorName: postingItem.postingWriterNickName ?? "익명",
            isHidden: false,
            createdAt: parseDate(postingItem.postingCreatedAt),
            commentCount: postingItem.commentCount,
            type: .found
        )
        
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? Date()
    }
}

// MARK: - FoundPostCell
class FoundPostCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 4
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
    
    private let locationTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        containerView.addSubview(locationTimeLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(commentButton)
        
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
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            locationTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            locationTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: locationTimeLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            commentButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            commentButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            commentButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with post: Post) {
        usernameLabel.text = post.authorName
        titleLabel.text = post.title
        locationTimeLabel.text = "학관 앞 | 8시간 전"
        descriptionLabel.text = post.content
        
        // 샘플 이미지 설정 (실제로는 post.images 사용)
        itemImageView.image = UIImage(systemName: "airpods")
        itemImageView.tintColor = .gray
    }
}
