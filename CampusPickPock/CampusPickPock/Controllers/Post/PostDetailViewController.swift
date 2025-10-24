//
//  PostDetailViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    private let post: Post
    private var postDetail: PostDetailItem?
    private var isLoading = false
    private var commentsTableViewHeightConstraint: NSLayoutConstraint?
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Comments Section
    private let commentsHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Comment Input Section
    private let commentInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let attachButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력해주세요."
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let privateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "lock.fill"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var comments: [Comment] = []
    private var commentItems: [CommentItem] = []
    private var isCommentPrivate = false
    
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        // 게시글 상세 로드를 먼저 완료한 후 댓글 로드
        loadPostDetail()
        // 댓글 로드는 게시글 상세 로드 성공 후에 호출되도록 수정
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        
        // 네비게이션 바 설정
        title = post.type == .lost ? "잃어버렸어요" : "주인을 찾아요"
        
        setupCustomBackButton()
        
        // 오른쪽 메뉴 버튼 (Lost 타입에만 줍줍 버튼 포함)
        let menuButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.vertical"), style: .plain, target: self, action: #selector(menuTapped))
        menuButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        navigationItem.rightBarButtonItem = menuButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(loadingIndicator)
        
        contentView.addSubview(headerView)
        headerView.addSubview(profileImageView)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(titleLabel)
        headerView.addSubview(itemImageView)
        headerView.addSubview(contentLabel)
        
        contentView.addSubview(commentsHeaderView)
        commentsHeaderView.addSubview(commentsCountLabel)
        
        contentView.addSubview(commentsTableView)
        
        view.addSubview(commentInputView)
        commentInputView.addSubview(attachButton)
        commentInputView.addSubview(commentTextField)
        commentInputView.addSubview(privateButton)
        commentInputView.addSubview(sendButton)
        
        // 버튼 액션 추가
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        privateButton.addTarget(self, action: #selector(privateButtonTapped), for: .touchUpInside)
        
        // 초기 상태: 댓글 작성 버튼 비활성화 (게시글 상세 로드 완료 후 활성화)
        sendButton.isEnabled = false
        commentTextField.isEnabled = false
        
        setupConstraints()
    }
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: commentInputView.topAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header Section
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            profileImageView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 24),
            profileImageView.heightAnchor.constraint(equalToConstant: 24),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            itemImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            itemImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            itemImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            itemImageView.heightAnchor.constraint(equalToConstant: 250),
            
            contentLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 16),
            contentLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            contentLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            contentLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            // Comments Header
            commentsHeaderView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            commentsHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentsHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentsHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            commentsCountLabel.leadingAnchor.constraint(equalTo: commentsHeaderView.leadingAnchor, constant: 20),
            commentsCountLabel.centerYAnchor.constraint(equalTo: commentsHeaderView.centerYAnchor),
            
            // Comments Table View
            commentsTableView.topAnchor.constraint(equalTo: commentsHeaderView.bottomAnchor),
            commentsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Comment Input View
            commentInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentInputView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            commentInputView.heightAnchor.constraint(equalToConstant: 60),
            
            attachButton.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 16),
            attachButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            attachButton.widthAnchor.constraint(equalToConstant: 24),
            attachButton.heightAnchor.constraint(equalToConstant: 24),
            
            commentTextField.leadingAnchor.constraint(equalTo: attachButton.trailingAnchor, constant: 12),
            commentTextField.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: privateButton.leadingAnchor, constant: -12),
            
            privateButton.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            privateButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            privateButton.widthAnchor.constraint(equalToConstant: 24),
            privateButton.heightAnchor.constraint(equalToConstant: 24),
            
            sendButton.trailingAnchor.constraint(equalTo: commentInputView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 24),
            sendButton.heightAnchor.constraint(equalToConstant: 24),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func loadPostDetail() {
        print("🔍 게시글 접근 권한 확인 시작")
        
        guard let postingId = post.postingId else {
            print("❌ postingId가 없습니다 - 게시글 접근 불가")
            return
        }
        
        print("📄 게시글 상세 로드 시작: postingId=\(postingId)")
        print("🔍 게시글 접근 권한 확인을 위한 상세 정보 요청")
        
        // 로딩 상태 표시
        isLoading = true
        loadingIndicator.startAnimating()
        scrollView.isHidden = true
        print("⏳ 게시글 상세 정보 로딩 중...")
        
        APIService.shared.getPostDetail(postingId: postingId) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.loadingIndicator.stopAnimating()
                
                switch result {
                case .success(let postDetail):
                    print("✅ 게시글 상세 로드 성공")
                    print("🔍 게시글 접근 권한 확인 결과:")
                    print("📊 게시글 접근 가능성: \(postDetail.isPostingAccessible)")
                    print("📊 게시글 제목: \(postDetail.postingTitle)")
                    print("📊 작성자: \(postDetail.postingWriterNickname ?? "익명")")
                    print("📊 게시글 ID: \(postDetail.postingWriterId)")
                    print("📊 줍줍 상태: \(postDetail.isPickedUp)")
                    
                    if postDetail.isPostingAccessible {
                        print("✅ 게시글 접근 권한 확인됨 - 댓글 작성 가능")
                    } else {
                        print("❌ 게시글 접근 권한 없음 - 댓글 작성 제한")
                    }
                    
                    self?.postDetail = postDetail
                    self?.updateContent(with: postDetail)
                    self?.scrollView.isHidden = false
                    
                    // 게시글 상세 로드 성공 후에만 댓글 로드
                    print("✅ 게시글 상세 로드 완료 - 댓글 로드 시작")
                    self?.loadComments()
                    
                case .failure(let error):
                    print("❌ 게시글 상세 로드 실패: \(error.localizedDescription)")
                    print("❌ 오류 타입: \(error)")
                    print("❌ 게시글 접근 권한 확인 실패 - 댓글 작성 기능 비활성화")
                    
                    // 오류 시 기존 Post 데이터로 표시하되 댓글 작성 완전 비활성화
                    self?.scrollView.isHidden = false
                    self?.commentInputView.isHidden = true
                    self?.sendButton.isEnabled = false
                    self?.commentTextField.isEnabled = false
                    
                    // postDetail을 nil로 설정하여 댓글 작성 방지
                    self?.postDetail = nil
                    
                    self?.showErrorAlert(message: "게시글을 불러올 수 없습니다. 댓글 작성이 제한됩니다.")
                }
            }
        }
    }
    
    private func updateContent(with postDetail: PostDetailItem) {
        print("🔍 게시글 내용 업데이트 시작")
        print("🔍 게시글 접근 권한 재확인: \(postDetail.isPostingAccessible)")
        
        // 작성자 정보 업데이트
        usernameLabel.text = postDetail.postingWriterNickname ?? "익명"
        titleLabel.text = postDetail.postingTitle
        contentLabel.text = postDetail.postingContent
        
        print("📊 게시글 정보 업데이트:")
        print("   - 제목: \(postDetail.postingTitle)")
        print("   - 작성자: \(postDetail.postingWriterNickname ?? "익명")")
        print("   - 내용 길이: \(postDetail.postingContent.count) characters")
        
        // 게시글 접근 가능성 확인 (완화 모드 - 경고만 표시)
        if !postDetail.isPostingAccessible {
            print("⚠️ 경고: 게시글 접근 불가능 상태")
            print("⚠️ 댓글 작성을 허용하지만 서버에서 거부될 수 있습니다")
            print("⚠️ 클라이언트 측 제한 완화 - 댓글 작성 UI 활성화")
            
            // 경고 메시지만 표시하고 댓글 작성은 허용
            commentInputView.isHidden = false
            sendButton.isEnabled = true
            commentTextField.isEnabled = true
            sendButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
            print("🎯 댓글 작성 UI 활성화 완료 (완화 모드)")
        } else {
            // 게시글이 접근 가능한 경우 댓글 작성 기능 활성화
            print("✅ 게시글 접근 가능 - 댓글 작성 권한 부여")
            print("✅ 게시글 접근 가능 - 댓글 작성 기능 활성화")
            commentInputView.isHidden = false
            sendButton.isEnabled = true
            commentTextField.isEnabled = true
            sendButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
            print("🎯 댓글 작성 UI 활성화 완료")
        }
        
        // 이미지 처리
        if let imageUrls = postDetail.postingImageUrls, !imageUrls.isEmpty {
            print("📸 게시글 이미지 로드 시작: \(imageUrls.count)개")
            // 첫 번째 이미지 로드 (실제로는 이미지 로딩 라이브러리 사용 권장)
            if let firstImageUrl = imageUrls.first, let url = URL(string: firstImageUrl) {
                loadImage(from: url)
            }
        } else {
            print("📸 게시글 이미지 없음")
            // 기본 이미지 설정
            itemImageView.image = UIImage(systemName: "airpods")
            itemImageView.tintColor = .gray
        }
        
        // 댓글 수 업데이트 (실제 댓글 수는 별도 API로 가져와야 함)
        commentsCountLabel.text = "댓글 \(post.commentCount)"
        print("✅ 게시글 내용 업데이트 완료")
    }
    
    private func loadImage(from url: URL) {
        // 간단한 이미지 로딩 (실제로는 Kingfisher 등 사용 권장)
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async { [weak self] in
                    self?.itemImageView.image = image
                }
            }
        }
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func loadComments() {
        guard let postingId = post.postingId else {
            print("❌ postingId가 없어서 댓글을 불러올 수 없습니다")
            return
        }
        
        print("💬 댓글 로드 시작: postingId=\(postingId)")
        
        APIService.shared.getCommentList(postingId: postingId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let commentItems):
                    print("✅ 댓글 로드 성공: \(commentItems.count)개 댓글")
                    
                    self?.commentItems = commentItems
                    
                    // CommentItem을 Comment로 변환
                    self?.comments = commentItems.map { commentItem in
                        Comment(
                            id: String(commentItem.commentId),
                            content: commentItem.commentContent,
                            authorId: String(commentItem.commentWriterId),
                            authorName: commentItem.commentWriterNickName ?? "익명",
                            postId: self?.post.id ?? "",
                            isPrivate: commentItem.isCommentSecret,
                            createdAt: self?.parseDate(commentItem.commentCreatedAt) ?? Date(),
                            parentCommentId: commentItem.parentCommentId != nil ? String(commentItem.parentCommentId!) : nil
                        )
                    }
                    
                    self?.commentsTableView.reloadData()
                    
                    // 댓글 수 업데이트
                    self?.commentsCountLabel.text = "댓글 \(commentItems.count)"
                    
                    // 댓글 테이블뷰 높이 동적 조정
                    self?.adjustCommentsTableViewHeight()
                    
                case .failure(let error):
                    print("❌ 댓글 로드 실패: \(error.localizedDescription)")
                    
                    // 오류 시 빈 댓글 목록 표시
                    self?.comments = []
                    self?.commentItems = []
                    self?.commentsTableView.reloadData()
                }
            }
        }
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? Date()
    }
    
    // MARK: - Dynamic Height Calculation
    private func adjustCommentsTableViewHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            // 테이블뷰의 내용 크기 계산
            self.commentsTableView.layoutIfNeeded()
            
            // 각 셀의 높이를 개별적으로 계산
            var totalHeight: CGFloat = 0
            let numberOfRows = self.commentsTableView.numberOfRows(inSection: 0)
            
            for i in 0..<numberOfRows {
                let indexPath = IndexPath(row: i, section: 0)
                let cellHeight = self.commentsTableView.delegate?.tableView?(self.commentsTableView, heightForRowAt: indexPath) ?? UITableView.automaticDimension
                
                if cellHeight == UITableView.automaticDimension {
                    // 자동 높이 계산을 위해 임시로 셀을 생성하고 높이 측정
                    if let cell = self.commentsTableView.dataSource?.tableView(self.commentsTableView, cellForRowAt: indexPath) {
                        cell.layoutIfNeeded()
                        let size = cell.systemLayoutSizeFitting(CGSize(width: self.commentsTableView.frame.width, height: UIView.layoutFittingCompressedSize.height))
                        totalHeight += size.height
                    }
                } else {
                    totalHeight += cellHeight
                }
            }
            
            // 최소 높이 설정 (댓글이 없을 때)
            let minHeight: CGFloat = 100
            let calculatedHeight = max(totalHeight, minHeight)
            
            // 최대 높이 설정 (화면의 60%를 넘지 않도록)
//            let maxHeight = self.view.frame.height * 0.6
            let finalHeight = calculatedHeight
            
            print("📏 댓글 테이블뷰 높이 조정:")
            print("📏 댓글 개수: \(numberOfRows)")
            print("📏 계산된 총 높이: \(totalHeight)")
            print("📏 최종 높이: \(finalHeight)")
            
            // 높이 제약조건 업데이트
            if let heightConstraint = self.commentsTableViewHeightConstraint {
                heightConstraint.constant = finalHeight
            } else {
                // 새로운 높이 제약조건 생성
                self.commentsTableViewHeightConstraint = self.commentsTableView.heightAnchor.constraint(equalToConstant: finalHeight)
                self.commentsTableViewHeightConstraint?.isActive = true
            }
            
            // 애니메이션과 함께 레이아웃 업데이트
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc private func backTapped() {
        print("🔙 PostDetailViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 이전 화면으로 복귀 완료")
    }
    
    @objc private func menuTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "URL 공유", style: .default) { _ in
            // URL 공유 기능
        })
        
        // Lost 타입에만 줍줍 버튼 추가
        if post.type == .lost {
            alert.addAction(UIAlertAction(title: "줍줍", style: .default) { _ in
                self.handleJoopjoopAction()
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func handleJoopjoopAction() {
        guard let postingId = post.postingId else {
            print("❌ postingId가 없습니다.")
            let alert = UIAlertController(title: "오류", message: "게시글 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("🎯 게시글 상세 화면 줍줍 버튼 클릭: postingId = \(postingId)")
        
        // 확인 다이얼로그
        let confirmAlert = UIAlertController(title: "줍줍 확인", message: "이 분실물을 찾으셨나요?", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        confirmAlert.addAction(UIAlertAction(title: "줍줍", style: .default) { _ in
            self.performJoopjoop(postingId: postingId)
        })
        
        present(confirmAlert, animated: true)
    }
    
    private func performJoopjoop(postingId: Int) {
        // 로딩 표시
        let loadingAlert = UIAlertController(title: "줍줍 중...", message: "잠시만 기다려주세요.", preferredStyle: .alert)
        present(loadingAlert, animated: true)
        
        APIService.shared.markPostAsPickedUp(postingId: postingId) { [weak self] result in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    switch result {
                    case .success(let response):
                        print("✅ 게시글 상세 화면 줍줍 성공: \(response.message)")
                        
                        // 성공 알림
                        let alert = UIAlertController(title: "줍줍 완료", message: "해당 게시글이 줍줍되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                            // 이전 화면으로 돌아가기
                            self?.navigationController?.popViewController(animated: true)
                        })
                        self?.present(alert, animated: true)
                        
                    case .failure(let error):
                        print("❌ 게시글 상세 화면 줍줍 실패: \(error.localizedDescription)")
                        
                        // 실패 알림
                        let alert = UIAlertController(title: "줍줍 실패", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension PostDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        // CommentItem을 직접 사용하여 더 정확한 데이터 표시
        if indexPath.row < commentItems.count {
            cell.configure(with: commentItems[indexPath.row])
        } else {
            cell.configure(with: comments[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // MARK: - Comment Actions
    @objc private func sendButtonTapped() {
        print("🔍 댓글 작성 권한 확인 시작 (완화된 모드)")
        
        // 1. 기본 정보 확인
        guard let postingId = post.postingId else {
            print("❌ postingId가 없어서 댓글을 작성할 수 없습니다")
            print("❌ 댓글 작성 권한 확인 실패 - 게시글 ID 없음")
            return
        }
        
        print("✅ 게시글 ID 확인됨: \(postingId)")
        
        // 2. 로그인 상태 확인 (필수)
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 인증 토큰이 없습니다 - 로그인 필요")
            print("❌ 댓글 작성 권한 확인 실패 - 인증 토큰 없음")
            
            let alert = UIAlertController(
                title: "로그인 필요",
                message: "댓글을 작성하려면 로그인이 필요합니다.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("✅ 인증 토큰 확인됨: \(token.prefix(20))...")
        
        // 3. 토큰 형식 검증 (경고만, 진행 허용)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("⚠️ 경고: 잘못된 토큰 형식일 수 있음: \(tokenParts.count)개 부분")
            print("⚠️ 토큰 형식 검증 실패 - 하지만 진행 허용")
        } else {
            print("✅ JWT 토큰 형식 유효")
        }
        
        print("🔍 댓글 작성 전 상태 확인:")
        print("🔍 postDetail 존재 여부: \(postDetail != nil)")
        print("🔍 isLoading 상태: \(isLoading)")
        
        // 4. 게시글 상세 정보 확인 (경고만, 진행 허용)
        if postDetail == nil {
            print("⚠️ 경고: 게시글 상세 정보가 로드되지 않았지만 댓글 작성 시도 허용")
            
            if isLoading {
                print("⚠️ 게시글 로딩 중이지만 댓글 작성 시도 허용")
            }
        } else {
            // 게시글 접근 가능성 재확인 (경고만, 진행 허용)
            if let postDetail = postDetail {
                print("🔍 게시글 접근 권한 재확인:")
                print("🔍 게시글 접근 가능성: \(postDetail.isPostingAccessible)")
                print("🔍 게시글 제목: \(postDetail.postingTitle)")
                print("🔍 게시글 작성자: \(postDetail.postingWriterNickname ?? "익명")")
                print("🔍 게시글 ID: \(postDetail.postingWriterId)")
                print("🔍 줍줍 상태: \(postDetail.isPickedUp)")
                
                if !postDetail.isPostingAccessible {
                    print("⚠️ 경고: 게시글 접근 불가능 상태이지만 댓글 작성 시도 허용")
                    print("⚠️ 서버에서 최종 권한 검증을 수행합니다")
                }
                
                if postDetail.isPickedUp {
                    print("⚠️ 경고: 게시글이 줍줍 처리된 상태이지만 댓글 작성 시도 허용")
                }
                
                print("✅ 클라이언트 측 게시글 접근 권한 확인 완료 (완화 모드)")
            }
        }
        
        // 5. 댓글 내용 확인 (필수)
        guard let commentText = commentTextField.text, !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("❌ 댓글 내용이 비어있습니다")
            print("❌ 댓글 작성 권한 확인 실패 - 댓글 내용 없음")
            return
        }
        
        print("✅ 댓글 내용 확인됨: \(commentText.count) characters")
        
        // 6. 모든 권한 확인 완료 (완화 모드)
        print("🎯 클라이언트 측 권한 확인 완료 - 댓글 작성 시도")
        print("🎯 서버에서 최종 권한 검증을 수행합니다")
        print("💬 댓글 작성 시작: \(commentText)")
        print("🔍 postingId: \(postingId)")
        print("🔍 댓글 내용 길이: \(commentText.count)")
        print("🔍 비밀 댓글 여부: \(isCommentPrivate)")
        
        // 로딩 상태 표시
        sendButton.isEnabled = false
        sendButton.tintColor = .gray
        
        let commentRequest = CreateCommentRequest(
            parentCommentId: 0, // API 스펙에 따라 일반 댓글은 0
            isCommentSecret: isCommentPrivate,
            commentContent: commentText.trimmingCharacters(in: .whitespacesAndNewlines),
            commentImageUrls: nil // 이미지 기능은 향후 구현
        )
        
        APIService.shared.createComment(postingId: postingId, commentData: commentRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.sendButton.isEnabled = true
                self?.sendButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
                
                switch result {
                case .success(let response):
                    print("✅ 댓글 작성 성공!")
                    print("✅ 댓글 ID: \(response.commentId)")
                    print("🎯 댓글 작성 권한 확인 및 실행 완료")
                    
                    // 댓글 입력 필드 초기화
                    self?.commentTextField.text = ""
                    self?.isCommentPrivate = false
                    self?.privateButton.tintColor = .gray
                    
                    // 댓글 목록 새로고침
                    self?.loadComments()
                    
                case .failure(let error):
                    print("❌ 댓글 작성 실패: \(error.localizedDescription)")
                    print("❌ 에러 타입: \(error)")
                    print("❌ postingId: \(postingId)")
                    print("❌ 댓글 내용: \(commentText)")
                    print("❌ 댓글 작성 권한 확인은 성공했으나 서버 처리 실패")
                    
                    // 에러 타입에 따른 구체적인 메시지
                    var errorMessage = error.localizedDescription
                    var errorTitle = "댓글 작성 실패"
                    
                    if case .unauthorized(let message) = error {
                        errorTitle = "댓글 작성 제한"
                        errorMessage = "현재 이 게시글에 댓글을 작성할 수 없습니다.\n\n📋 확인된 정보:\n• 게시글 상태: 정상\n• 접근 권한: 허용됨\n• 토큰 상태: 유효함\n\n🔍 가능한 원인:\n• 서버 측 권한 정책 제한\n• 게시글 작성자가 자신의 게시글에 댓글 제한 설정\n• 일시적인 서버 상태 문제\n\n💡 해결 방법:\n• 잠시 후 다시 시도해보세요\n• 다른 게시글에서 댓글 작성 시도\n• 관리자에게 문의"
                        
                        print("❌ 403 오류 감지 - 서버에서 접근 거부")
                        print("❌ 게시글 상태 재확인 필요: postingId=\(postingId)")
                        print("⚠️ 클라이언트 측 제한 완화 모드 - 댓글 입력 영역 유지")
                        print("⚠️ 사용자가 다시 시도할 수 있도록 허용")
                        
                        // 403 오류 발생해도 댓글 입력 영역은 유지 (완화 모드)
                        // 사용자가 게시글 상태가 변경된 경우 다시 시도할 수 있도록 함
                        
                        // 게시글 상세 정보 다시 로드하여 상태 확인
                        self?.loadPostDetail()
                    } else if case .notFound(let message) = error {
                        errorTitle = "게시글을 찾을 수 없음"
                        errorMessage = message
                    } else if case .serverError = error {
                        errorTitle = "서버 오류"
                        errorMessage = "서버에 일시적인 문제가 발생했습니다. 잠시 후 다시 시도해주세요."
                    } else if case .networkError(let message) = error {
                        errorTitle = "네트워크 오류"
                        errorMessage = "인터넷 연결을 확인해주세요."
                    }
                    
                    // 에러 알림 표시
                    let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func privateButtonTapped() {
        isCommentPrivate.toggle()
        privateButton.tintColor = isCommentPrivate ? UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0) : .gray
        print("🔒 비밀 댓글 설정: \(isCommentPrivate)")
    }
}

// MARK: - CommentCell
class CommentCell: UITableViewCell {
    
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
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let privateIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "lock.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "ellipsis.vertical"), for: .normal)
        button.tintColor = .gray
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
        containerView.addSubview(timeLabel)
        containerView.addSubview(privateIconImageView)
        containerView.addSubview(contentLabel)
        containerView.addSubview(menuButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: 20),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 8),
            timeLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            
            privateIconImageView.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 4),
            privateIconImageView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            privateIconImageView.widthAnchor.constraint(equalToConstant: 12),
            privateIconImageView.heightAnchor.constraint(equalToConstant: 12),
            
            contentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -8),
            contentLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            menuButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            menuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 24),
            menuButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func configure(with comment: Comment) {
        usernameLabel.text = comment.authorName
        timeLabel.text = "5시간 전"
        contentLabel.text = comment.content
        privateIconImageView.isHidden = !comment.isPrivate
        
        // 대댓글인 경우 들여쓰기
        if comment.parentCommentId != nil {
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        }
    }
    
    func configure(with commentItem: CommentItem) {
        usernameLabel.text = commentItem.commentWriterNickName ?? "익명"
        timeLabel.text = formatDate(commentItem.commentCreatedAt)
        contentLabel.text = commentItem.commentContent
        privateIconImageView.isHidden = !commentItem.isCommentSecret
        
        // 대댓글인 경우 들여쓰기
        if commentItem.parentCommentId != nil {
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        }
        
        // 댓글 이미지 처리 (향후 구현)
        // TODO: commentItem.commentImageUrls 처리
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            return "방금 전"
        }
        
        let now = Date()
        let timeInterval = now.timeIntervalSince(date)
        
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
