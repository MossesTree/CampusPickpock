//
//  PostDetailViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit
import PhotosUI

class PostDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    private let post: Post
    private var postDetail: PostDetailItem?
    private var isLoading = false
    private var commentsTableViewHeightConstraint: NSLayoutConstraint?
    private var commentImages: [UIImage] = []
    
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
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")
        return collectionView
    }()
    
    private var postImages: [UIImage] = []
    
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
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
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
        headerView.addSubview(imagesCollectionView)
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
        attachButton.addTarget(self, action: #selector(attachButtonTapped), for: .touchUpInside)
        
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
            
            imagesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imagesCollectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            imagesCollectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            imagesCollectionView.heightAnchor.constraint(equalToConstant: 250),
            
            contentLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 16),
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
            loadAllImages(from: imageUrls)
        } else {
            print("📸 게시글 이미지 없음 - 기본 이미지 표시")
            // 기본 이미지 설정
            let defaultImage = UIImage(systemName: "airpods")
            postImages = [defaultImage].compactMap { $0 }
            updateCollectionViewLayout()
            imagesCollectionView.reloadData()
        }
        
        // 댓글 수 업데이트 (실제 댓글 수는 별도 API로 가져와야 함)
        commentsCountLabel.text = "댓글 \(post.commentCount)"
        print("✅ 게시글 내용 업데이트 완료")
    }
    
    private func loadAllImages(from imageUrls: [String]) {
        postImages = []
        imagesCollectionView.reloadData()
        
        for (index, imageUrl) in imageUrls.enumerated() {
            guard let url = URL(string: imageUrl) else { continue }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.postImages.append(image)
                        self?.updateCollectionViewLayout()
                        self?.imagesCollectionView.reloadData()
                        print("✅ 이미지 로드 완료: \(index + 1)/\(imageUrls.count)")
                    }
                }
            }
        }
    }
    
    private func updateCollectionViewLayout() {
        if let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if postImages.count <= 1 {
                // 이미지가 하나면 스크롤 비활성화
                layout.scrollDirection = .vertical
                imagesCollectionView.isScrollEnabled = false
            } else {
                // 여러 개면 가로 스크롤 활성화
                layout.scrollDirection = .horizontal
                imagesCollectionView.isScrollEnabled = true
            }
        }
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
        
        // 수정 버튼 추가
        alert.addAction(UIAlertAction(title: "수정", style: .default) { _ in
            self.handleEditAction()
        })
        
        // 삭제 버튼 추가
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.handleDeleteAction()
        })
        
        // Lost 타입에만 줍줍 완료 버튼 추가
        if post.type == .lost {
            alert.addAction(UIAlertAction(title: "줍줍 완료", style: .default) { _ in
                self.handleJoopjoopAction()
            })
        }
        
        present(alert, animated: true)
    }
    
    private func handleEditAction() {
        guard let postingId = post.postingId else {
            print("❌ postingId가 없습니다.")
            let alert = UIAlertController(title: "오류", message: "게시글 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("📝 게시글 수정 버튼 클릭: postingId = \(postingId)")
        
        // 게시글 수정 화면으로 이동
        let editViewController = PostCreateViewController()
        editViewController.configureForEdit(post: post, postDetail: postDetail)
        
        let navigationController = UINavigationController(rootViewController: editViewController)
        present(navigationController, animated: true)
    }
    
    private func handleDeleteAction() {
        guard let postingId = post.postingId else {
            print("❌ postingId가 없습니다.")
            let alert = UIAlertController(title: "오류", message: "게시글 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("🗑️ 게시글 삭제 버튼 클릭: postingId = \(postingId)")
        
        // 삭제 확인 다이얼로그
        let confirmAlert = UIAlertController(title: "게시글 삭제", message: "정말로 이 게시글을 삭제하시겠습니까?\n삭제된 게시글은 복구할 수 없습니다.", preferredStyle: .alert)
        
        confirmAlert.addAction(UIAlertAction(title: "취소", style: .cancel))
        confirmAlert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.performDelete(postingId: postingId)
        })
        
        present(confirmAlert, animated: true)
    }
    
    private func performDelete(postingId: Int) {
        // 로딩 표시
        let loadingAlert = UIAlertController(title: "삭제 중...", message: "잠시만 기다려주세요.", preferredStyle: .alert)
        present(loadingAlert, animated: true)
        
        APIService.shared.deletePost(postingId: postingId) { [weak self] result in
            DispatchQueue.main.async {
                loadingAlert.dismiss(animated: true) {
                    switch result {
                    case .success(let response):
                        print("✅ 게시글 삭제 성공: \(response.message)")
                        
                        // 성공 알림
                        let alert = UIAlertController(title: "삭제 완료", message: "게시글이 성공적으로 삭제되었습니다.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
                            // 이전 화면으로 돌아가기
                            self?.navigationController?.popViewController(animated: true)
                        })
                        self?.present(alert, animated: true)
                        
                    case .failure(let error):
                        print("❌ 게시글 삭제 실패: \(error.localizedDescription)")
                        
                        // 실패 알림
                        let alert = UIAlertController(title: "삭제 실패", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "확인", style: .default))
                        self?.present(alert, animated: true)
                    }
                }
            }
        }
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
    
    private func handleCommentMenuTapped(_ commentItem: CommentItem) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 대댓글 달기
        alert.addAction(UIAlertAction(title: "대댓글 달기", style: .default) { _ in
            self.handleReplyToComment(commentItem)
        })
        
        // 수정 (본인 댓글인 경우만)
        if commentItem.commentWriterId == getCurrentUserId() {
            alert.addAction(UIAlertAction(title: "수정", style: .default) { _ in
                self.handleEditComment(commentItem)
            })
            
            // 삭제 (본인 댓글인 경우만)
            alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
                self.handleDeleteComment(commentItem)
            })
        }
        
        // 테스트를 위해 모든 댓글에 수정/삭제 버튼 표시
        alert.addAction(UIAlertAction(title: "수정", style: .default) { _ in
            self.handleEditComment(commentItem)
        })
        
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.handleDeleteComment(commentItem)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func handleReplyToComment(_ commentItem: CommentItem) {
        print("📝 대댓글 작성 시작: 부모 댓글 ID \(commentItem.commentId)")
        
        let alert = UIAlertController(title: "대댓글 작성", message: "\(commentItem.commentWriterNickName ?? "익명")님의 댓글에 답글을 작성합니다.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "대댓글을 입력하세요..."
            textField.text = ""
        }
        
        let writeAction = UIAlertAction(title: "작성", style: .default) { _ in
            guard let textField = alert.textFields?.first,
                  let content = textField.text,
                  !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                print("❌ 대댓글 내용이 비어있음")
                return
            }
            
            self.performReplyToComment(parentCommentId: commentItem.commentId, content: content)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(writeAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func performReplyToComment(parentCommentId: Int, content: String) {
        print("📝 대댓글 작성 API 호출: 부모 댓글 ID \(parentCommentId), 내용: \(content)")
        
        let replyData = CreateCommentRequest(
            parentCommentId: parentCommentId,
            isCommentSecret: false,
            commentContent: content,
            commentImageUrls: []
        )
        
        APIService.shared.createComment(postingId: post.postingId ?? 0, commentData: replyData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                print("✅ 대댓글 작성 성공: \(response.commentId)")
                DispatchQueue.main.async {
                    self.showSuccessAlert(message: "대댓글이 성공적으로 작성되었습니다.")
                    // 댓글 목록 새로고침
                    self.loadComments()
                }
            case .failure(let error):
                print("❌ 대댓글 작성 실패: \(error)")
                DispatchQueue.main.async {
                    self.showErrorAlert(message: "대댓글 작성에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func handleEditComment(_ commentItem: CommentItem) {
        let alert = UIAlertController(title: "댓글 수정", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.text = commentItem.commentContent
            textField.placeholder = "댓글을 입력하세요"
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "수정", style: .default) { _ in
            guard let newContent = alert.textFields?.first?.text, !newContent.isEmpty else { return }
            self.performEditComment(commentItem, newContent: newContent)
        })
        
        present(alert, animated: true)
    }
    
    private func handleDeleteComment(_ commentItem: CommentItem) {
        let alert = UIAlertController(title: "댓글 삭제", message: "정말로 이 댓글을 삭제하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "삭제", style: .destructive) { _ in
            self.performDeleteComment(commentItem)
        })
        
        present(alert, animated: true)
    }
    
    private func performEditComment(_ commentItem: CommentItem, newContent: String) {
        let updateData = UpdateCommentRequest(
            isCommentSecret: commentItem.isCommentSecret,
            commentContent: newContent,
            commentImageUrls: commentItem.commentImageUrls ?? []
        )
        
        APIService.shared.updateComment(commentId: commentItem.commentId, updateData: updateData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ 댓글 수정 성공: \(response.message)")
                    self?.loadComments()
                case .failure(let error):
                    print("❌ 댓글 수정 실패: \(error.localizedDescription)")
                    self?.showErrorAlert(message: "댓글 수정에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func performDeleteComment(_ commentItem: CommentItem) {
        APIService.shared.deleteComment(commentId: commentItem.commentId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    print("✅ 댓글 삭제 성공: \(response.message)")
                    self?.loadComments()
                case .failure(let error):
                    print("❌ 댓글 삭제 실패: \(error.localizedDescription)")
                    self?.showErrorAlert(message: "댓글 삭제에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func getCurrentUserId() -> Int? {
        // DataManager에서 현재 사용자 ID 가져오기
        guard let userIdString = DataManager.shared.currentUser?.id,
              let userId = Int(userIdString) else {
            print("❌ 현재 사용자 ID를 가져올 수 없음")
            return nil
        }
        print("✅ 현재 사용자 ID: \(userId)")
        return userId
    }
    
    private func showSuccessAlert(message: String) {
        let alert = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
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
            cell.configure(with: commentItems[indexPath.row], onMenuTapped: handleCommentMenuTapped)
        } else {
            cell.configure(with: comments[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
        
        // 이미지가 있으면 먼저 업로드
        if !commentImages.isEmpty {
            uploadCommentImages { [weak self] imageUrls in
                self?.createCommentWithImages(imageUrls: imageUrls, commentText: commentText)
            }
        } else {
            createCommentWithImages(imageUrls: [], commentText: commentText)
        }
    }
    
    private func uploadCommentImages(completion: @escaping ([String]) -> Void) {
        print("📷 댓글 이미지 업로드 시작: \(commentImages.count)개")
        
        let group = DispatchGroup()
        var uploadedUrls: [String] = []
        
        for (index, image) in commentImages.enumerated() {
            group.enter()
            
            // presigned URL 요청
            let fileName = "comment_\(Int(Date().timeIntervalSince1970))_\(index).jpg"
            APIService.shared.getPresignedUrls(fileNames: [fileName]) { result in
                switch result {
                case .success(let presignedUrls):
                    guard let presignedUrl = presignedUrls.first else {
                        print("❌ 이미지 \(index) presigned URL이 비어있음")
                        group.leave()
                        return
                    }
                    
                    // S3에 업로드
                    APIService.shared.uploadImageToS3(image: image, presignedUrl: presignedUrl) { uploadResult in
                        switch uploadResult {
                        case .success(let imageUrl):
                            uploadedUrls.append(imageUrl)
                            print("✅ 이미지 \(index) 업로드 성공: \(imageUrl)")
                        case .failure(let error):
                            print("❌ 이미지 \(index) 업로드 실패: \(error)")
                        }
                        group.leave()
                    }
                case .failure(let error):
                    print("❌ 이미지 \(index) presigned URL 요청 실패: \(error)")
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            print("📷 댓글 이미지 업로드 완료: \(uploadedUrls.count)개")
            completion(uploadedUrls)
        }
    }
    
    private func createCommentWithImages(imageUrls: [String], commentText: String) {
        guard let postingId = post.postingId else { return }
        
        let commentRequest = CreateCommentRequest(
            parentCommentId: 0, // API 스펙에 따라 일반 댓글은 0
            isCommentSecret: isCommentPrivate,
            commentContent: commentText.trimmingCharacters(in: .whitespacesAndNewlines),
            commentImageUrls: imageUrls.isEmpty ? nil : imageUrls
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
                    self?.commentImages.removeAll()
                    self?.updateAttachButtonAppearance()
                    
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
                    
                    if case .unauthorized(let _) = error {
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
    
    @objc private func attachButtonTapped() {
        print("📷 댓글 사진 첨부 버튼 클릭")
        
        let alert = UIAlertController(title: "사진 첨부", message: "사진을 선택하세요", preferredStyle: .actionSheet)
        
        // 카메라 옵션
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "카메라", style: .default) { _ in
                self.presentImagePicker(sourceType: .camera)
            })
        }
        
        // 사진 라이브러리 옵션
        alert.addAction(UIAlertAction(title: "사진 라이브러리", style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        })
        
        // 선택된 이미지가 있으면 제거 옵션
        if !commentImages.isEmpty {
            alert.addAction(UIAlertAction(title: "첨부된 사진 제거", style: .destructive) { _ in
                self.commentImages.removeAll()
                self.updateAttachButtonAppearance()
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        // iPad에서 actionSheet가 크래시되지 않도록 설정
        if let popover = alert.popoverPresentationController {
            popover.sourceView = attachButton
            popover.sourceRect = attachButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        if #available(iOS 14.0, *) {
            // iOS 14+ 에서는 PHPicker 사용 (여러장 선택 가능)
            var config = PHPickerConfiguration()
            config.selectionLimit = 5 // 최대 5장까지 선택 가능
            config.filter = .images
            
            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true)
        } else {
            // iOS 14 미만에서는 UIImagePickerController 사용
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true)
        }
    }
    
    private func updateAttachButtonAppearance() {
        if commentImages.isEmpty {
            attachButton.tintColor = .gray
            attachButton.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        } else {
            attachButton.tintColor = .systemBlue
            attachButton.setImage(UIImage(systemName: "photo.on.rectangle.fill"), for: .normal)
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension PostDetailViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let editedImage = info[.editedImage] as? UIImage {
            commentImages.append(editedImage)
            print("📷 댓글용 이미지 선택됨: \(commentImages.count)개")
            updateAttachButtonAppearance()
        } else if let originalImage = info[.originalImage] as? UIImage {
            commentImages.append(originalImage)
            print("📷 댓글용 이미지 선택됨: \(commentImages.count)개")
            updateAttachButtonAppearance()
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        print("📷 이미지 선택 취소됨")
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PostDetailViewController {
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard !results.isEmpty else {
            print("📷 이미지 선택 취소됨")
            return
        }
        
        print("📷 선택된 이미지 개수: \(results.count)")
        
        let group = DispatchGroup()
        
        for (index, result) in results.enumerated() {
            group.enter()
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                DispatchQueue.main.async {
                    if let image = object as? UIImage {
                        self?.commentImages.append(image)
                        print("✅ 이미지 \(index + 1) 로드 성공")
                    } else if let error = error {
                        print("❌ 이미지 \(index + 1) 로드 실패: \(error)")
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            print("📷 모든 이미지 로드 완료: \(self.commentImages.count)개")
            self.updateAttachButtonAppearance()
        }
    }
}

// MARK: - CommentCell
class CommentCell: UITableViewCell {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 1)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
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
        button.tintColor = .systemBlue
        button.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = false
        return button
    }()
    
    private let commentImagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CommentImageCell.self, forCellWithReuseIdentifier: "CommentImageCell")
        collectionView.isHidden = true
        return collectionView
    }()
    
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(profileImageView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(privateIconImageView)
        containerView.addSubview(contentLabel)
        containerView.addSubview(menuButton)
        containerView.addSubview(commentImagesCollectionView)
        
        // 메뉴 버튼 액션 추가
        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        
        // 컬렉션뷰 설정
        commentImagesCollectionView.delegate = self
        commentImagesCollectionView.dataSource = self
        commentImagesCollectionView.isHidden = true
        
        // 높이 제약조건 설정
        collectionViewHeightConstraint = commentImagesCollectionView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            containerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
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
            
            contentLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            contentLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            contentLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -8),
            
            commentImagesCollectionView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 12),
            commentImagesCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            commentImagesCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            menuButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            menuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 32),
            menuButton.heightAnchor.constraint(equalToConstant: 32)
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
    
    private var commentItem: CommentItem?
    private var onMenuTapped: ((CommentItem) -> Void)?
    private var commentImages: [UIImage] = []
    
    func configure(with commentItem: CommentItem, onMenuTapped: @escaping (CommentItem) -> Void) {
        self.commentItem = commentItem
        self.onMenuTapped = onMenuTapped
        
        usernameLabel.text = commentItem.commentWriterNickName ?? "익명"
        timeLabel.text = formatDate(commentItem.commentCreatedAt)
        contentLabel.text = commentItem.commentContent
        privateIconImageView.isHidden = !commentItem.isCommentSecret
        
        // 대댓글인 경우 들여쓰기
        if commentItem.parentCommentId != nil {
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40).isActive = true
        }
        
        // 댓글 이미지 처리
        loadCommentImages(from: commentItem.commentImageUrls ?? [])
    }
    
    private func loadCommentImages(from imageUrls: [String]) {
        print("🖼️ 댓글 이미지 로드 시작: \(imageUrls.count)개")
        commentImages.removeAll()
        
        if imageUrls.isEmpty {
            print("🖼️ 이미지 URL이 없음 - 컬렉션뷰 숨김")
            commentImagesCollectionView.isHidden = true
            collectionViewHeightConstraint?.constant = 0
            return
        }
        
        print("🖼️ 이미지 URL 있음 - 컬렉션뷰 표시")
        commentImagesCollectionView.isHidden = false
        collectionViewHeightConstraint?.constant = 80
        
        let group = DispatchGroup()
        
        for imageUrl in imageUrls {
            group.enter()
            
            guard let url = URL(string: imageUrl) else {
                group.leave()
                continue
            }
            
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        self?.commentImages.append(image)
                    }
                    group.leave()
                }
            }.resume()
        }
        
        group.notify(queue: .main) { [weak self] in
            print("🖼️ 댓글 이미지 로드 완료: \(self?.commentImages.count ?? 0)개")
            self?.commentImagesCollectionView.reloadData()
        }
    }
    
    @objc private func menuButtonTapped() {
        guard let commentItem = commentItem else { return }
        onMenuTapped?(commentItem)
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

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension PostDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCollectionViewCell
        cell.configure(with: postImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 이미지가 하나만 있으면 전체 너비로 표시
        if postImages.count == 1 {
            let collectionViewWidth = collectionView.frame.width
            return CGSize(width: collectionViewWidth, height: 200)
        } else {
            // 여러 개면 작은 크기로 가로 스크롤
            return CGSize(width: 200, height: 200)
        }
    }
}

// MARK: - CommentImageCell
class CommentImageCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
        
        // 시스템 이미지인 경우 회색으로 설정
        if image.isSymbolImage {
            imageView.tintColor = .gray
        } else {
            imageView.tintColor = nil
        }
    }
}

// MARK: - ImageCollectionViewCell
class ImageCollectionViewCell: UICollectionViewCell {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func configure(with image: UIImage) {
        imageView.image = image
        
        // 시스템 이미지인 경우 회색으로 설정
        if image.isSymbolImage {
            imageView.tintColor = .gray
        } else {
            imageView.tintColor = nil
        }
    }
}

// MARK: - CommentCell CollectionView Extensions
extension CommentCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return commentImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CommentImageCell", for: indexPath) as! CommentImageCell
        cell.configure(with: commentImages[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 80)
    }
}
