//
//  MyCommentedPostsViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class MyCommentedPostsViewController: UIViewController {
    
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
    
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "댓글 단 글"
        label.font = UIFont(name: "Pretendard Variable", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let navDividerLine: UIView = {
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
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Empty State
    private let emptyStateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emptyIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "UnhappyIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 작성한 댓글이 없어요"
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 20) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 20)
        } else {
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        label.textColor = UIColor(red: 172/255.0, green: 190/255.0, blue: 226/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emptySubMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "다른 게시글에 댓글을 달아보세요!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var posts: [Post] = []
    private var postingItems: [PostingItem] = []
    private var isLoading = false
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add custom header
        view.addSubview(customNavHeader)
        customNavHeader.addSubview(backButton)
        customNavHeader.addSubview(navTitleLabel)
        view.addSubview(navDividerLine)
        
        view.addSubview(postsTableView)
        view.addSubview(emptyStateView)
        view.addSubview(loadingIndicator)
        
        emptyStateView.addSubview(emptyIconImageView)
        emptyStateView.addSubview(emptyMessageLabel)
        
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
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            navTitleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            navTitleLabel.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            
            navDividerLine.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor),
            navDividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navDividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navDividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Posts Table View
            postsTableView.topAnchor.constraint(equalTo: navDividerLine.bottomAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: navDividerLine.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyIconImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyIconImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -20),
            emptyIconImageView.widthAnchor.constraint(equalToConstant: 38),
            emptyIconImageView.heightAnchor.constraint(equalToConstant: 38),
            
            emptyMessageLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyMessageLabel.topAnchor.constraint(equalTo: emptyIconImageView.bottomAnchor, constant: 16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(PostListCell.self, forCellReuseIdentifier: "PostListCell")
    }
    
    @objc private func backTapped() {
        print("🔙 MyCommentedPostsViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    @objc private func joopjoopTapped() {
        // 줍줍 버튼 기능 (필요시 구현)
        print("줍줍 버튼 탭됨")
    }
    
    private func loadPosts() {
        print("💬 댓글 단 글 로드 시작")
        
        // 로딩 상태 표시
        isLoading = true
        loadingIndicator.startAnimating()
        postsTableView.isHidden = true
        emptyStateView.isHidden = true
        
        APIService.shared.getCommentedPostings { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.loadingIndicator.stopAnimating()
                
                switch result {
                case .success(let commentedPostings):
                    print("✅ 댓글 단 글 로드 성공: \(commentedPostings.count)개 항목")
                    
                    self?.postingItems = commentedPostings
                    
                    // PostingItem을 Post로 변환
                    self?.posts = commentedPostings.map { postingItem in
                        Post(
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
                            createdAt: self?.parseDate(postingItem.postingCreatedAt) ?? Date(),
                            commentCount: postingItem.commentCount,
                            type: postingItem.postingCategory == "LOST" ? .lost : .found,
                            isPickedUp: postingItem.isPickedUp
                        )
                    }
                    
                    // 데이터가 있으면 테이블뷰 표시, 없으면 빈 상태 표시
                    self?.postsTableView.isHidden = self?.posts.isEmpty == true
                    self?.emptyStateView.isHidden = self?.posts.isEmpty == false
                    
                    self?.postsTableView.reloadData()
                    
                case .failure(let error):
                    print("❌ 댓글 단 글 로드 실패: \(error.localizedDescription)")
                    
                    // 오류 시 빈 상태 표시
                    self?.posts = []
                    self?.postingItems = []
                    self?.postsTableView.isHidden = true
                    self?.emptyStateView.isHidden = false
                    self?.emptyMessageLabel.text = "댓글 단 글을 불러올 수 없습니다"
                    self?.postsTableView.reloadData()
                }
            }
        }
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // UTC 시간으로 파싱
        
        guard let date = dateFormatter.date(from: dateString) else {
            // ISO8601DateFormatter로 재시도
            let iso8601Formatter = ISO8601DateFormatter()
            if let parsedDate = iso8601Formatter.date(from: dateString) {
                return parsedDate
            }
            print("⚠️ 날짜 파싱 실패: \(dateString)")
            return Date()
        }
        
        return date
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyCommentedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as! PostListCell
        let post = posts[indexPath.row]
        let isFirst = indexPath.row == 0
        // 댓글 단 글이므로 프로필 표시함
        cell.configure(with: post, isFirst: isFirst, showProfile: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
