//
//  LostPostListViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

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
        label.font = UIFont(name: "Pretendard Variable", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍이 찾아드릴게요"
        label.font = UIFont(name: "Pretendard Variable", size: 13) ?? .systemFont(ofSize: 13, weight: .medium)
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
        view.addSubview(categoryDividerLine)
        
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
            categoryScrollView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 18),
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
            postsTableView.topAnchor.constraint(equalTo: categoryDividerLine.bottomAnchor, constant: 16),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(PostListCell.self, forCellReuseIdentifier: "PostListCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as! PostListCell
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
            type: .lost,
            isPickedUp: postingItem.isPickedUp
        )
        
        let isFirst = (indexPath.row == 0)
        cell.configure(with: post, isFirst: isFirst)
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
            type: .lost,
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
        // 시간 비교는 PostListCell의 formatRelativeTime에서 처리됨
        return date
    }
}
