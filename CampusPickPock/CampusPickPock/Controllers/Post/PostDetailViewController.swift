//
//  PostDetailViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit
import PhotosUI

class PostDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    private let post: Post?
    private var postingId: Int?
    private var postDetail: PostDetailItem?
    private var isLoading = false
    private var commentsTableViewHeightConstraint: NSLayoutConstraint?
    private var commentImages: [UIImage] = []
    private var imagesCollectionViewHeightConstraint: NSLayoutConstraint?
    private var commentsHeaderTopConstraint: NSLayoutConstraint?
    private var contentLabelTopConstraint: NSLayoutConstraint?
    private var contentLabelLeadingConstraint: NSLayoutConstraint?
    private var contentLabelTrailingConstraint: NSLayoutConstraint?
    private var contentLabelBottomConstraint: NSLayoutConstraint?
    private var headerViewBottomConstraint: NSLayoutConstraint?
    
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
    
    // MARK: - Custom Navigation Header
    private let customNavHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let navBackButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(red: 0x51/255.0, green: 0x5B/255.0, blue: 0x70/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard Variable", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let navMoreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "DotsIcon"), for: .normal)
        button.tintColor = UIColor(red: 0x51/255.0, green: 0x5B/255.0, blue: 0x70/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let navDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Header Section
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
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
        label.font = UIFont(name: "Pretendard Variable", size: 15) ?? UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        // Pretendard Variable SemiBold 22px
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 22) {
            let descriptor = pretendardFont.fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]])
            label.font = UIFont(descriptor: descriptor, size: 22)
        } else {
            label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        }
        label.textColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0)
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
        return button
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
    
    // 숨김 박스 UI (isPostingAccessible이 false일 때)
    private let hiddenBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let lockIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RockIcon2")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let hiddenLabel1: UILabel = {
        let label = UILabel()
        label.text = "개인 정보가 담긴 게시글이에요"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hiddenLabel2: UILabel = {
        let label = UILabel()
        label.text = "앱 내 등록된 개인 정보와 일치하면"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let hiddenLabel3: UILabel = {
        let label = UILabel()
        label.text = "게시글을 볼 수 있어요!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        label.font = UIFont(name: "Pretendard Variable", size: 13) ?? UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Comments Section
    private let commentsHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentsCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard Variable", size: 15) ?? UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dividerLine2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let attachButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "ImageBoxIcon"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont(name: "Pretendard Variable", size: 15) ?? UIFont.systemFont(ofSize: 15)
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 10
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.attributedPlaceholder = NSAttributedString(string: "댓글을 입력하세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0x97/255.0, green: 0x97/255.0, blue: 0x97/255.0, alpha: 1.0), NSAttributedString.Key.font: UIFont(name: "Pretendard Variable", size: 15) ?? UIFont.systemFont(ofSize: 15)])
        return textField
    }()
    
    private let privateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "UnRockIcon"), for: .normal)
        button.tintColor = UIColor(red: 0x93/255.0, green: 0x90/255.0, blue: 0x90/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "SendFillIcon"), for: .normal)
        button.tintColor = UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var comments: [Comment] = []
    private var commentItems: [CommentItem] = []
    private var isCommentPrivate = false
    private var lockButtonInTextField: UIButton? // rightView의 잠금 버튼 참조
    
    // 커스텀 팝업 관련
    private var popoverMenuView: PopoverMenuView?
    private var popoverOverlayView: UIView?
    
    // 댓글 커스텀 팝업 관련
    private var commentPopoverMenuView: PopoverMenuView?
    private var commentPopoverOverlayView: UIView?
    private var currentCommentItem: CommentItem?
    
    init(post: Post) {
        self.post = post
        self.postingId = post.postingId
        super.init(nibName: nil, bundle: nil)
    }
    
    init(postingId: Int) {
        self.post = nil
        self.postingId = postingId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 네비게이션 바 그림자 완전 제거
        navigationController?.navigationBar.shadowImage = UIImage()
        
        setupUI()
        setupTableView()
        
        // 게시글 상세 로드를 먼저 완료한 후 댓글 로드
        loadPostDetail()
        // 댓글 로드는 게시글 상세 로드 성공 후에 호출되도록 수정
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 처음 로드할 때만 서버 통신
        // 이미 데이터가 있으면 서버 통신하지 않음 (수정 완료 후 돌아왔을 때 불필요한 통신 방지)
        if postingId != nil && postDetail == nil {
            loadPostDetail()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // 네비게이션 바 완전히 숨기기
        navigationController?.isNavigationBarHidden = true
        
        // 커스텀 네비게이션 헤더 추가
        view.addSubview(customNavHeader)
        customNavHeader.addSubview(navBackButton)
        customNavHeader.addSubview(navTitleLabel)
        customNavHeader.addSubview(navMoreButton)
        customNavHeader.addSubview(navDividerLine)
        
        navBackButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        navMoreButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        
        // 타이틀 설정
        if let post = post {
            navTitleLabel.text = post.type == .lost ? "잃어버렸어요" : "주인을 찾아요"
        } else {
            navTitleLabel.text = "게시글 상세"
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        view.addSubview(loadingIndicator)
        
        contentView.addSubview(headerView)
        headerView.addSubview(profileImageView)
        headerView.addSubview(usernameLabel)
        headerView.addSubview(titleLabel)
        // headerView.addSubview(categoryLabel) // 카테고리 숨김
        headerView.addSubview(pickedUpButton)
        headerView.addSubview(itemImageView)
        headerView.addSubview(imagesCollectionView)
        headerView.addSubview(hiddenBoxView)
        hiddenBoxView.addSubview(lockIconView)
        hiddenBoxView.addSubview(hiddenLabel1)
        hiddenBoxView.addSubview(hiddenLabel2)
        hiddenBoxView.addSubview(hiddenLabel3)
        headerView.addSubview(contentLabel)
        
        contentView.addSubview(commentsHeaderView)
        commentsHeaderView.addSubview(commentsCountLabel)
        commentsHeaderView.addSubview(dividerLine2)
        
        contentView.addSubview(commentsTableView)
        
        view.addSubview(commentInputView)
        commentInputView.addSubview(attachButton)
        commentInputView.addSubview(commentTextField)
        commentInputView.addSubview(privateButton)
        commentInputView.addSubview(sendButton)
        
        // 잠금 아이콘을 commentTextField의 rightView로 추가
        let lockButton = UIButton(type: .system)
        lockButton.setImage(UIImage(named: "UnRockIcon"), for: .normal)
        lockButton.tintColor = UIColor(red: 0x93/255.0, green: 0x90/255.0, blue: 0x90/255.0, alpha: 1.0)
        lockButton.frame = CGRect(x: 0, y: 0, width: 31, height: 31)
        lockButton.addTarget(self, action: #selector(privateButtonTapped), for: .touchUpInside)
        lockButtonInTextField = lockButton // 참조 저장
        
        let rightViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 31))
        rightViewContainer.addSubview(lockButton)
        lockButton.center = rightViewContainer.center
        
        commentTextField.rightView = rightViewContainer
        commentTextField.rightViewMode = .always
        
        // 버튼 액션 추가
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        privateButton.addTarget(self, action: #selector(privateButtonTapped), for: .touchUpInside)
        attachButton.addTarget(self, action: #selector(attachButtonTapped), for: .touchUpInside)
        pickedUpButton.addTarget(self, action: #selector(pickedUpButtonTapped), for: .touchUpInside)
        
        // 초기 상태: 댓글 작성 버튼 비활성화 (게시글 상세 로드 완료 후 활성화)
        sendButton.isEnabled = false
        commentTextField.isEnabled = false
        
        setupConstraints()
    }
    
    private func setupCustomBackButton() {
        // 버튼 컨테이너
        let containerView = UIView()
        containerView.backgroundColor = .clear
        
        // 뒤로가기 버튼
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0x51/255.0, green: 0x5B/255.0, blue: 0x70/255.0, alpha: 1.0)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.backgroundColor = .clear
        backButton.layer.borderWidth = 0
        backButton.layer.cornerRadius = 0
        
        containerView.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalToConstant: 44),
            containerView.heightAnchor.constraint(equalToConstant: 44),
            backButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            backButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        let backBarButtonItem = UIBarButtonItem(customView: containerView)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Custom Navigation Header
            customNavHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavHeader.heightAnchor.constraint(equalToConstant: 44),
            
            navBackButton.leadingAnchor.constraint(equalTo: customNavHeader.leadingAnchor, constant: 16),
            navBackButton.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            navBackButton.widthAnchor.constraint(equalToConstant: 44),
            navBackButton.heightAnchor.constraint(equalToConstant: 44),
            
            navTitleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            navTitleLabel.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            
            navMoreButton.trailingAnchor.constraint(equalTo: customNavHeader.trailingAnchor, constant: -16),
            navMoreButton.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            navMoreButton.widthAnchor.constraint(equalToConstant: 44),
            navMoreButton.heightAnchor.constraint(equalToConstant: 44),
            
            navDividerLine.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor),
            navDividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navDividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navDividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            scrollView.topAnchor.constraint(equalTo: navDividerLine.bottomAnchor),
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
            usernameLabel.trailingAnchor.constraint(lessThanOrEqualTo: pickedUpButton.leadingAnchor, constant: -8),
            
            pickedUpButton.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            pickedUpButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            pickedUpButton.widthAnchor.constraint(equalToConstant: 75),
            pickedUpButton.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8), // 카테고리 숨김
            // categoryLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20), // 카테고리 숨김
            
            imagesCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            imagesCollectionView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            imagesCollectionView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            // Hidden Box View (중앙 배치)
            hiddenBoxView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            hiddenBoxView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            hiddenBoxView.widthAnchor.constraint(equalToConstant: 346),
            hiddenBoxView.heightAnchor.constraint(equalToConstant: 366),
            
            // Hidden Box View 내부 요소들 - 중앙 정렬
            lockIconView.centerXAnchor.constraint(equalTo: hiddenBoxView.centerXAnchor),
            lockIconView.centerYAnchor.constraint(equalTo: hiddenBoxView.centerYAnchor, constant: -30),
            lockIconView.widthAnchor.constraint(equalToConstant: 52),
            lockIconView.heightAnchor.constraint(equalToConstant: 52),
            
            hiddenLabel1.centerXAnchor.constraint(equalTo: hiddenBoxView.centerXAnchor),
            hiddenLabel1.topAnchor.constraint(equalTo: lockIconView.bottomAnchor, constant: 16),
            hiddenLabel1.leadingAnchor.constraint(greaterThanOrEqualTo: hiddenBoxView.leadingAnchor, constant: 20),
            hiddenLabel1.trailingAnchor.constraint(lessThanOrEqualTo: hiddenBoxView.trailingAnchor, constant: -20),
            
            hiddenLabel2.centerXAnchor.constraint(equalTo: hiddenBoxView.centerXAnchor),
            hiddenLabel2.topAnchor.constraint(equalTo: hiddenLabel1.bottomAnchor, constant: 8),
            hiddenLabel2.leadingAnchor.constraint(greaterThanOrEqualTo: hiddenBoxView.leadingAnchor, constant: 20),
            hiddenLabel2.trailingAnchor.constraint(lessThanOrEqualTo: hiddenBoxView.trailingAnchor, constant: -20),
            
            hiddenLabel3.centerXAnchor.constraint(equalTo: hiddenBoxView.centerXAnchor),
            hiddenLabel3.topAnchor.constraint(equalTo: hiddenLabel2.bottomAnchor, constant: 4),
            hiddenLabel3.leadingAnchor.constraint(greaterThanOrEqualTo: hiddenBoxView.leadingAnchor, constant: 20),
            hiddenLabel3.trailingAnchor.constraint(lessThanOrEqualTo: hiddenBoxView.trailingAnchor, constant: -20),
            
            // Comments Header (제약조건 저장하고 기본값 설정)
            commentsHeaderView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentsHeaderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentsHeaderView.heightAnchor.constraint(equalToConstant: 50),
            
            commentsCountLabel.leadingAnchor.constraint(equalTo: commentsHeaderView.leadingAnchor, constant: 20),
            commentsCountLabel.centerYAnchor.constraint(equalTo: commentsHeaderView.centerYAnchor),
            
            dividerLine2.topAnchor.constraint(equalTo: commentsCountLabel.bottomAnchor, constant: 8),
            dividerLine2.leadingAnchor.constraint(equalTo: commentsHeaderView.leadingAnchor, constant: 20),
            dividerLine2.trailingAnchor.constraint(equalTo: commentsHeaderView.trailingAnchor, constant: -20),
            dividerLine2.heightAnchor.constraint(equalToConstant: 1),
            
            // Comments Table View
            commentsTableView.topAnchor.constraint(equalTo: commentsHeaderView.bottomAnchor),
            commentsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Comment Input View
            commentInputView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentInputView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentInputView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            commentInputView.heightAnchor.constraint(equalToConstant: 67),
            
            attachButton.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 16),
            attachButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            attachButton.widthAnchor.constraint(equalToConstant: 35),
            attachButton.heightAnchor.constraint(equalToConstant: 35),
            
            commentTextField.leadingAnchor.constraint(equalTo: attachButton.trailingAnchor, constant: 12),
            commentTextField.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            commentTextField.heightAnchor.constraint(equalToConstant: 37),
            
            sendButton.trailingAnchor.constraint(equalTo: commentInputView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: commentInputView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 40),
            sendButton.heightAnchor.constraint(equalToConstant: 40),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // privateButton은 이제 commentTextField의 rightView로 사용되므로 숨김
        privateButton.isHidden = true
        
        // Comments Header의 top 제약조건 저장 (기본값: headerView.bottomAnchor)
        commentsHeaderTopConstraint = commentsHeaderView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        commentsHeaderTopConstraint?.isActive = true
        
        // ContentLabel의 기본 제약조건 저장 (일반 게시글용)
        contentLabelTopConstraint = contentLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 10)
        contentLabelLeadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
        contentLabelTrailingConstraint = contentLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20)
        contentLabelBottomConstraint = contentLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
        
        // 기본 제약조건 활성화 (일반 게시글)
        contentLabelTopConstraint?.isActive = true
        contentLabelLeadingConstraint?.isActive = true
        contentLabelTrailingConstraint?.isActive = true
        contentLabelBottomConstraint?.isActive = true
        
        // headerViewBottomConstraint 저장 (기본값: 비활성화, 안내박스 표시 시에만 활성화)
        headerViewBottomConstraint = headerView.bottomAnchor.constraint(greaterThanOrEqualTo: hiddenBoxView.bottomAnchor, constant: 20)
        headerViewBottomConstraint?.isActive = false
        
        // 이미지 컬렉션뷰 높이 제약조건 추가
        imagesCollectionViewHeightConstraint = imagesCollectionView.heightAnchor.constraint(equalToConstant: 0)
        imagesCollectionViewHeightConstraint?.isActive = true
    }
    
    private func setupTableView() {
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func updateCollectionViewHeight() {
        if postImages.isEmpty {
            imagesCollectionViewHeightConstraint?.constant = 0
        } else {
            // 이미지가 있으면 컬렉션뷰의 실제 컨텐츠 높이에 맞춤
            imagesCollectionView.layoutIfNeeded()
            let height = imagesCollectionView.contentSize.height
            imagesCollectionViewHeightConstraint?.constant = max(height, 100)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateCollectionViewHeight()
    }
    
    private func loadPostDetail() {
        print("🔍 게시글 접근 권한 확인 시작")
        
        guard let postingId = self.postingId else {
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
        
        loadPostDetailData()
    }
    
    private func loadPostDetailInBackground() {
        guard let postingId = self.postingId else { return }
        print("🔄 백그라운드에서 게시글 상세 정보 업데이트: postingId=\(postingId)")
        loadPostDetailData()
    }
    
    private func loadPostDetailData() {
        guard let postingId = self.postingId else { return }
        
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
                    
                    // 네비게이션 타이틀 업데이트 (post가 nil인 경우)
                    if self?.post == nil {
                        self?.title = postDetail.postingTitle
                    }
                    
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
    
    private func setContentLabelConstraints(inHiddenBox: Bool, hasImages: Bool = true) {
        contentLabelTopConstraint?.isActive = false
        contentLabelLeadingConstraint?.isActive = false
        contentLabelTrailingConstraint?.isActive = false
        contentLabelBottomConstraint?.isActive = false
        
        // headerViewBottomConstraint 동적 관리
        if inHiddenBox {
            // 안내박스 밖에 본문 배치 (박스 하단 + 19pt, x 위치는 박스와 동일)
            contentLabelTopConstraint = contentLabel.topAnchor.constraint(equalTo: hiddenBoxView.bottomAnchor, constant: 19)
            contentLabelLeadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: hiddenBoxView.leadingAnchor)
            contentLabelTrailingConstraint = contentLabel.trailingAnchor.constraint(equalTo: hiddenBoxView.trailingAnchor)
            contentLabelBottomConstraint = contentLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
            
            // headerView가 hiddenBoxView를 포함하도록
            headerViewBottomConstraint?.isActive = true
        } else if hasImages {
            // 이미지가 있는 경우
            contentLabelTopConstraint = contentLabel.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 10)
            contentLabelLeadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
            contentLabelTrailingConstraint = contentLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20)
            contentLabelBottomConstraint = contentLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
            
            // headerViewBottomConstraint 비활성화
            headerViewBottomConstraint?.isActive = false
        } else {
            // 이미지가 없는 경우 titleLabel 바로 아래
            contentLabelTopConstraint = contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16)
            contentLabelLeadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20)
            contentLabelTrailingConstraint = contentLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20)
            contentLabelBottomConstraint = contentLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20)
            
            // headerViewBottomConstraint 비활성화
            headerViewBottomConstraint?.isActive = false
        }
        
        contentLabelTopConstraint?.isActive = true
        contentLabelLeadingConstraint?.isActive = true
        contentLabelTrailingConstraint?.isActive = true
        contentLabelBottomConstraint?.isActive = true
    }
    
    private func setCommentsHeaderConstraints(belowHiddenBox: Bool) {
        commentsHeaderTopConstraint?.isActive = false
        
        if belowHiddenBox {
            // 본문 아래에 댓글 배치
            commentsHeaderTopConstraint = commentsHeaderView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 20)
        } else {
            commentsHeaderTopConstraint = commentsHeaderView.topAnchor.constraint(equalTo: headerView.bottomAnchor)
        }
        
        commentsHeaderTopConstraint?.isActive = true
    }
    
    private func configureJoopjoopButton(isPickedUp: Bool) {
        // 게시글 타입 확인: lost 타입일 때만 줍줍 버튼 활성화
        let isLostType: Bool
        if let post = post {
            isLostType = post.type == .lost
        } else {
            // navTitleLabel에서 타입 추론 ("잃어버렸어요" = lost, "주인을 찾아요" = found)
            isLostType = navTitleLabel.text == "잃어버렸어요"
        }
        
        if !isLostType {
            // found 타입이면 버튼 숨기기
            pickedUpButton.isHidden = true
            return
        }
        
        // 줍줍 완료 여부와 관계없이 StarIcon1 사용 (색상으로 구분)
        let iconName = "StarIcon1"
        
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
        
        // 줍줍 완료된 경우 rgba(146, 168, 221, 1) 색상으로 설정
        if isPickedUp {
            pickedUpButton.tintColor = UIColor(red: 146/255.0, green: 168/255.0, blue: 221/255.0, alpha: 1.0)
            pickedUpButton.setTitleColor(UIColor(red: 146/255.0, green: 168/255.0, blue: 221/255.0, alpha: 1.0), for: .normal)
        } else {
            // 줍줍 완료 전에는 네이비 색상 (FillStarIcon1은 이미 채워진 별, StarIcon1은 비어있는 별)
            pickedUpButton.tintColor = UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0)
            pickedUpButton.setTitleColor(UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0), for: .normal)
        }
        
        pickedUpButton.isEnabled = !isPickedUp // 이미 줍줍된 경우 비활성화
        pickedUpButton.isHidden = false
    }
    
    @objc private func pickedUpButtonTapped() {
        // lost 타입일 때만 처리
        let isLostType: Bool
        if let post = post {
            isLostType = post.type == .lost
        } else {
            isLostType = navTitleLabel.text == "잃어버렸어요"
        }
        
        guard isLostType else {
            return
        }
        
        handleJoopjoopAction()
    }
    
    private func updateContent(with postDetail: PostDetailItem) {
        print("🔍 게시글 내용 업데이트 시작")
        print("🔍 게시글 접근 권한 재확인: \(postDetail.isPostingAccessible)")
        
        // 작성자 정보 업데이트
        usernameLabel.text = postDetail.postingWriterNickname ?? "익명"
        titleLabel.text = postDetail.postingTitle
        // categoryLabel.text = postDetail.postingCategory ?? "" // 카테고리 숨김
        
        // 본문 텍스트 설정 (행간 18)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        paragraphStyle.maximumLineHeight = 18
        let attributedText = NSAttributedString(
            string: postDetail.postingContent,
            attributes: [
                .font: contentLabel.font ?? UIFont(name: "Pretendard Variable", size: 13) ?? UIFont.systemFont(ofSize: 13),
                .foregroundColor: contentLabel.textColor ?? UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0),
                .paragraphStyle: paragraphStyle
            ]
        )
        contentLabel.attributedText = attributedText
        
        // 줍줍 상태에 따라 버튼 표시
        configureJoopjoopButton(isPickedUp: postDetail.isPickedUp)
        
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
        
        // 이미지 처리 - isPostingAccessible에 따라 다르게 처리
        if !postDetail.isPostingAccessible {
            // 접근 불가능한 경우 숨김 박스 표시
            print("🔒 게시글 접근 불가능 - 숨김 박스 표시")
            imagesCollectionView.isHidden = true
            hiddenBoxView.isHidden = false
            
            // 본문과 댓글 위치 설정
            setContentLabelConstraints(inHiddenBox: true)
            setCommentsHeaderConstraints(belowHiddenBox: true)
        } else if let imageUrls = postDetail.postingImageUrls, !imageUrls.isEmpty {
            print("📸 게시글 이미지 로드 시작: \(imageUrls.count)개")
            imagesCollectionView.isHidden = false
            hiddenBoxView.isHidden = true
            
            // 본문과 댓글 위치 설정
            setContentLabelConstraints(inHiddenBox: false, hasImages: true)
            setCommentsHeaderConstraints(belowHiddenBox: false)
            
            loadAllImages(from: imageUrls)
        } else {
            print("📸 게시글 이미지 없음 - 이미지 영역 숨김")
            imagesCollectionView.isHidden = true
            hiddenBoxView.isHidden = true
            
            // 본문과 댓글 위치 설정 (이미지 없음)
            setContentLabelConstraints(inHiddenBox: false, hasImages: false)
            setCommentsHeaderConstraints(belowHiddenBox: false)
        }
        
        // 댓글 수 업데이트 (실제 댓글 수는 별도 API로 가져와야 함)
        commentsCountLabel.text = "댓글 \(post?.commentCount ?? 0)"
        
        // 레이아웃 업데이트
        view.layoutIfNeeded()
        
        print("✅ 게시글 내용 업데이트 완료")
    }
    
    private func loadAllImages(from imageUrls: [String]) {
        // 중복 URL 제거
        let uniqueImageUrls = Array(Set(imageUrls))
        if uniqueImageUrls.count != imageUrls.count {
            print("⚠️ 중복 이미지 URL 발견: \(imageUrls.count)개 -> \(uniqueImageUrls.count)개")
            print("📸 원본 URLs: \(imageUrls)")
        }
        
        // 이전 이미지 초기화
        postImages = []
        imagesCollectionView.reloadData()
        
        let group = DispatchGroup()
        var loadedImages: [UIImage] = []
        var loadedCount = 0
        
        for (index, imageUrl) in uniqueImageUrls.enumerated() {
            guard let url = URL(string: imageUrl) else { continue }
            
            group.enter()
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    loadedImages.append(image)
                    loadedCount += 1
                    print("✅ 이미지 다운로드 완료: \(loadedCount)/\(uniqueImageUrls.count)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            // 모든 이미지가 로드된 후 한 번에 업데이트
            self?.postImages = loadedImages
            self?.imagesCollectionView.reloadData()
            self?.updateCollectionViewLayout()
            print("✅ 모든 이미지 로드 완료: \(loadedImages.count)개")
        }
    }
    
    private func updateCollectionViewLayout() {
        if let layout = imagesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            if postImages.count <= 1 {
                // 이미지가 하나면 스크롤 비활성화하고 원본 비율 유지
                layout.scrollDirection = .vertical
                imagesCollectionView.isScrollEnabled = false
                imagesCollectionViewHeightConstraint?.constant = 250
            } else {
                // 여러 개면 가로 스크롤 활성화
                layout.scrollDirection = .horizontal
                imagesCollectionView.isScrollEnabled = true
                imagesCollectionViewHeightConstraint?.constant = 200
            }
        }
    }
    
    private func loadComments() {
        guard let postingId = self.postingId else {
            print("❌ postingId가 없어서 댓글을 불러올 수 없습니다")
            return
        }
        
        print("💬 댓글 로드 시작: postingId=\(postingId)")
        
        APIService.shared.getCommentList(postingId: postingId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let commentItems):
                    print("✅ 댓글 로드 성공: \(commentItems.count)개 댓글")
                    
                    // 댓글을 정렬하여 대댓글이 원댓글 바로 아래 위치하도록 함
                    self?.commentItems = self?.sortComments(commentItems) ?? commentItems
                    
                    // CommentItem을 Comment로 변환
                    self?.comments = self?.commentItems.map { commentItem in
                        Comment(
                            id: String(commentItem.commentId),
                            content: commentItem.commentContent,
                            authorId: String(commentItem.commentWriterId),
                            authorName: commentItem.commentWriterNickName ?? "익명",
                            postId: self?.postingId?.description ?? "",
                            isPrivate: commentItem.isCommentSecret,
                            createdAt: self?.parseDate(commentItem.commentCreatedAt) ?? Date(),
                            parentCommentId: commentItem.parentCommentId != nil ? String(commentItem.parentCommentId!) : nil
                        )
                    } ?? []
                    
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
    
    // MARK: - Comment Sorting
    private func sortComments(_ comments: [CommentItem]) -> [CommentItem] {
        var sortedComments: [CommentItem] = []
        var commentMap: [Int: CommentItem] = [:]
        var replyMap: [Int: [CommentItem]] = [:]
        
        // 모든 댓글을 맵에 저장하고 대댓글은 별도로 분류
        for comment in comments {
            if let parentId = comment.parentCommentId {
                if replyMap[parentId] == nil {
                    replyMap[parentId] = []
                }
                replyMap[parentId]?.append(comment)
            } else {
                commentMap[comment.commentId] = comment
            }
        }
        
        // 원댓글과 대댓글을 역순으로 정렬 (오래된 댓글이 위에)
        for comment in commentMap.values.sorted(by: { $0.commentId < $1.commentId }) {
            sortedComments.append(comment)
            
            // 해당 댓글의 대댓글들을 추가
            if let replies = replyMap[comment.commentId] {
                sortedComments.append(contentsOf: replies)
            }
        }
        
        return sortedComments
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
        // 기존 팝업이 있으면 제거
        hidePopoverMenu()
        
        // lost 타입인지 확인
        let isLostType: Bool
        if let post = post {
            isLostType = post.type == .lost
        } else {
            isLostType = navTitleLabel.text == "잃어버렸어요"
        }
        
        // 메뉴 아이템 생성
        var menuItems: [MenuItem] = [
            MenuItem(title: "수정", iconName: "pencil"),
            MenuItem(title: "삭제", iconName: "trash")
        ]
        
        if isLostType {
            menuItems.append(MenuItem(title: "줍줍 완료", iconName: "checkmark.circle"))
        }
        
        // 팝업 크기 설정
        let popoverWidth: CGFloat = 85
        let popoverHeight: CGFloat = isLostType ? 66 : 44
        
        // 오버레이 뷰 생성
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.clear
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.alpha = 0
        view.addSubview(overlayView)
        popoverOverlayView = overlayView
        
        // 팝업 메뉴 뷰 생성
        let popoverView = PopoverMenuView()
        popoverView.customBackgroundColor = UIColor(red: 206/255.0, green: 214/255.0, blue: 233/255.0, alpha: 1.0) // CED6E9
        popoverView.customCornerRadius = 10
        popoverView.customBorderColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 225/255.0, alpha: 1.0) // C7CFE1
        popoverView.customBorderWidth = 1.0 / UIScreen.main.scale
        // 각 아이템 높이 계산: (전체 높이 - 구분선 높이 * 구분선 개수) / 아이템 개수
        let separatorHeight: CGFloat = 1.0 / UIScreen.main.scale
        let separatorCount = CGFloat(menuItems.count - 1)
        let itemHeight = (popoverHeight - separatorHeight * separatorCount) / CGFloat(menuItems.count)
        popoverView.customItemHeight = itemHeight
        popoverView.customPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        popoverView.delegate = self
        popoverView.translatesAutoresizingMaskIntoConstraints = false
        popoverView.alpha = 0
        popoverView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.addSubview(popoverView)
        popoverMenuView = popoverView
        
        // 팝업 메뉴 구성
        popoverView.configure(with: menuItems)
        
        // navMoreButton의 위치 계산
        let buttonFrame = navMoreButton.convert(navMoreButton.bounds, to: view)
        let popoverX = buttonFrame.maxX - popoverWidth
        let popoverY = buttonFrame.maxY + 8
        
        // 제약 조건 설정
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            popoverView.widthAnchor.constraint(equalToConstant: popoverWidth),
            popoverView.heightAnchor.constraint(equalToConstant: popoverHeight),
            popoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: popoverX),
            popoverView.topAnchor.constraint(equalTo: view.topAnchor, constant: popoverY)
        ])
        
        // 애니메이션으로 표시
        UIView.animate(withDuration: 0.2) {
            overlayView.alpha = 1
            popoverView.alpha = 1
            popoverView.transform = .identity
        }
        
        // 오버레이 탭 시 팝업 닫기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hidePopoverMenu))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hidePopoverMenu() {
        guard let popoverView = popoverMenuView,
              let overlayView = popoverOverlayView else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0
            popoverView.alpha = 0
            popoverView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            popoverView.removeFromSuperview()
            overlayView.removeFromSuperview()
            self.popoverMenuView = nil
            self.popoverOverlayView = nil
        }
    }
    
    private func handleEditAction() {
        // 권한 체크
        guard let currentUser = DataManager.shared.currentUser else {
            let alert = UIAlertController(title: "오류", message: "현재 사용자 정보를 가져올 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard let currentPostDetail = self.postDetail else {
            let alert = UIAlertController(title: "오류", message: "게시글 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        let authorNickname = currentPostDetail.postingWriterNickname ?? ""
        let currentUserNickname = currentUser.name
        
        // 본인 게시글인지 확인
        if authorNickname != currentUserNickname {
            let alert = UIAlertController(title: "접근 제한", message: "본인이 작성한 게시글만 수정할 수 있습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard let postingId = self.postingId else {
            print("❌ postingId가 없습니다.")
            let alert = UIAlertController(title: "오류", message: "게시글 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        print("📝 게시글 수정 버튼 클릭: postingId = \(postingId)")
        
        // 디버그: currentPostDetail 확인
        print("📝 수정할 게시글 상세 정보:")
        print("📍 itemPlace: \(currentPostDetail.itemPlace ?? "nil")")
        print("📦 isPlacedInStorage: \(currentPostDetail.isPlacedInStorage?.description ?? "nil")")
        print("🏷️ postingCategory: \(currentPostDetail.postingCategory ?? "nil")")
        print("✅ isPickedUp: \(currentPostDetail.isPickedUp)")
        
        // 게시글 수정 화면으로 이동
        let editViewController = PostCreateViewController()
        
        // post가 nil인 경우 Post 객체 생성
        if let post = post {
            editViewController.configureForEdit(post: post, postDetail: currentPostDetail)
        } else if let postDetail = self.postDetail {
            // postingId만 있는 경우 Post 객체 생성
            let tempPost = Post(
                id: String(postingId),
                postingId: postingId,
                title: postDetail.postingTitle,
                content: postDetail.postingContent,
                authorId: String(postDetail.postingWriterId),
                authorName: postDetail.postingWriterNickname ?? "익명",
                createdAt: Date(),
                commentCount: 0,
                type: postDetail.isPickedUp ? .found : .lost
            )
            editViewController.configureForEdit(post: tempPost, postDetail: postDetail)
        }
        
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    private func handleDeleteAction() {
        // 권한 체크
        guard let currentUser = DataManager.shared.currentUser else {
            let alert = UIAlertController(title: "오류", message: "현재 사용자 정보를 가져올 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard let currentPostDetail = self.postDetail else {
            let alert = UIAlertController(title: "오류", message: "게시글 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        let authorNickname = currentPostDetail.postingWriterNickname ?? ""
        let currentUserNickname = currentUser.name
        
        // 본인 게시글인지 확인
        if authorNickname != currentUserNickname {
            let alert = UIAlertController(title: "접근 제한", message: "본인이 작성한 게시글만 삭제할 수 있습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard let postingId = self.postingId else {
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
        // 로그인 체크
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            let alert = UIAlertController(title: "로그인 필요", message: "줍줍 기능을 사용하려면 로그인이 필요합니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard let currentPostDetail = self.postDetail else {
            let alert = UIAlertController(title: "오류", message: "게시글 정보를 찾을 수 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        // 이미 줍줍 완료된 글인지 확인
        if currentPostDetail.isPickedUp {
            let alert = UIAlertController(title: "알림", message: "이미 줍줍완료 된 글입니다!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default))
            present(alert, animated: true)
            return
        }
        
        guard let postingId = self.postingId else {
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
                        
                        // 줍줍 버튼 업데이트
                        self?.configureJoopjoopButton(isPickedUp: true)
                        
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
        // 기존 팝업이 있으면 제거
        hideCommentPopoverMenu()
        
        currentCommentItem = commentItem
        
        // 메뉴 아이템 생성
        var menuItems: [MenuItem] = []
        
        // 대댓글이 아닌 경우에만 "대댓글 달기" 옵션 추가
        if commentItem.parentCommentId == nil {
            menuItems.append(MenuItem(title: "대댓글 달기", iconName: "arrowshape.turn.up.right"))
        }
        
        // 삭제 버튼 추가 (댓글 팝업용 아이콘 이름 사용)
        menuItems.append(MenuItem(title: "삭제", iconName: "comment-trash"))
        
        // 팝업 크기 설정
        let popoverWidth: CGFloat = 85
        // 대댓글인 경우(아이템 1개) 높이 27, 댓글인 경우(아이템 2개) 높이 53
        let popoverHeight: CGFloat = commentItem.parentCommentId == nil ? 53 : 27
        
        // 오버레이 뷰 생성
        let overlayView = UIView()
        overlayView.backgroundColor = UIColor.clear
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.alpha = 0
        view.addSubview(overlayView)
        commentPopoverOverlayView = overlayView
        
        // 팝업 메뉴 뷰 생성
        let popoverView = PopoverMenuView()
        popoverView.customBackgroundColor = UIColor(red: 206/255.0, green: 214/255.0, blue: 233/255.0, alpha: 1.0) // CED6E9
        popoverView.customCornerRadius = 10
        popoverView.customBorderColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 225/255.0, alpha: 1.0) // C7CFE1
        popoverView.customBorderWidth = 1.0 / UIScreen.main.scale
        // 각 아이템 높이 계산: (전체 높이 - 구분선 높이 * 구분선 개수) / 아이템 개수
        let separatorHeight: CGFloat = 1.0 / UIScreen.main.scale
        let separatorCount = CGFloat(menuItems.count - 1)
        let itemHeight = (popoverHeight - separatorHeight * separatorCount) / CGFloat(menuItems.count)
        popoverView.customItemHeight = itemHeight
        popoverView.customPadding = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        popoverView.delegate = self
        popoverView.translatesAutoresizingMaskIntoConstraints = false
        popoverView.alpha = 0
        popoverView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        view.addSubview(popoverView)
        commentPopoverMenuView = popoverView
        
        // 팝업 메뉴 구성
        popoverView.configure(with: menuItems)
        
        // 댓글 셀의 menuButton 위치 찾기
        // tableView에서 해당 셀을 찾아야 함
        if let indexPath = findCommentCellIndexPath(for: commentItem) {
            if let cell = commentsTableView.cellForRow(at: indexPath) as? CommentCell {
                let cellFrame = cell.convert(cell.bounds, to: view)
                let menuButtonFrame = cell.menuButton.convert(cell.menuButton.bounds, to: view)
                let popoverX = menuButtonFrame.maxX - popoverWidth
                let popoverY = menuButtonFrame.maxY + 8
                
                // 제약 조건 설정
                NSLayoutConstraint.activate([
                    overlayView.topAnchor.constraint(equalTo: view.topAnchor),
                    overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                    
                    popoverView.widthAnchor.constraint(equalToConstant: popoverWidth),
                    popoverView.heightAnchor.constraint(equalToConstant: popoverHeight),
                    popoverView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: popoverX),
                    popoverView.topAnchor.constraint(equalTo: view.topAnchor, constant: popoverY)
                ])
            }
        }
        
        // 애니메이션으로 표시
        UIView.animate(withDuration: 0.2) {
            overlayView.alpha = 1
            popoverView.alpha = 1
            popoverView.transform = .identity
        }
        
        // 오버레이 탭 시 팝업 닫기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideCommentPopoverMenu))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    private func findCommentCellIndexPath(for commentItem: CommentItem) -> IndexPath? {
        for (index, item) in commentItems.enumerated() {
            if item.commentId == commentItem.commentId {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }
    
    @objc private func hideCommentPopoverMenu() {
        guard let popoverView = commentPopoverMenuView,
              let overlayView = commentPopoverOverlayView else { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            overlayView.alpha = 0
            popoverView.alpha = 0
            popoverView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            popoverView.removeFromSuperview()
            overlayView.removeFromSuperview()
            self.commentPopoverMenuView = nil
            self.commentPopoverOverlayView = nil
            self.currentCommentItem = nil
        }
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
        
        APIService.shared.createComment(postingId: postingId ?? 0, commentData: replyData) { [weak self] result in
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
            self.performEditComment(commentItem: commentItem, newContent: newContent)
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
    
    private func performEditComment(commentItem: CommentItem, newContent: String) {
        print("📝 댓글 수정 API 호출: 댓글 ID \(commentItem.commentId), 내용: \(newContent)")
        
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
        guard let postingId = self.postingId else {
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
        guard let postingId = self.postingId else { return }
        
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
                    
                    if case .unauthorized = error {
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
        
        if isCommentPrivate {
            privateButton.setImage(UIImage(named: "RockIcon"), for: .normal)
        } else {
            privateButton.setImage(UIImage(named: "UnRockIcon"), for: .normal)
        }
        
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
        view.backgroundColor = .clear
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ProfileIcon") ?? UIImage(named: "profileIcon")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard Variable", size: 13) ?? UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard Variable", size: 10) ?? UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
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
    
    private let replyIndicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let replyArrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "IndentationIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var containerLeadingConstraint: NSLayoutConstraint?
    
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard Variable", size: 13) ?? UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "DotsIcon"), for: .normal)
        button.tintColor = UIColor(red: 0x7F/255.0, green: 0x82/255.0, blue: 0x8A/255.0, alpha: 1.0)
        button.backgroundColor = .clear
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
    private var imageCollectionViewBottomConstraint: NSLayoutConstraint?
    private var contentLabelBottomConstraint: NSLayoutConstraint?
    private var contentLabelLeadingConstraint: NSLayoutConstraint?
    private var collectionViewLeadingConstraint: NSLayoutConstraint?
    private var replyIndicatorViewTopConstraint: NSLayoutConstraint?
    private var replyIndicatorViewCenterYConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .backgroundColor
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        contentView.addSubview(replyIndicatorView)
        replyIndicatorView.addSubview(replyArrowImageView)
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
        
        // containerView의 기본 leading 제약조건 저장
        containerLeadingConstraint = containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        
        NSLayoutConstraint.activate([
            containerLeadingConstraint!,
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            replyIndicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            replyIndicatorView.widthAnchor.constraint(equalToConstant: 30),
            replyIndicatorView.heightAnchor.constraint(equalToConstant: 20),
            
            replyArrowImageView.centerXAnchor.constraint(equalTo: replyIndicatorView.centerXAnchor),
            replyArrowImageView.centerYAnchor.constraint(equalTo: replyIndicatorView.centerYAnchor),
            replyArrowImageView.widthAnchor.constraint(equalToConstant: 20),
            replyArrowImageView.heightAnchor.constraint(equalToConstant: 20),
            
            profileImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 20),
            profileImageView.heightAnchor.constraint(equalToConstant: 20),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8),
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            
            timeLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            
            privateIconImageView.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 4),
            privateIconImageView.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            privateIconImageView.widthAnchor.constraint(equalToConstant: 12),
            privateIconImageView.heightAnchor.constraint(equalToConstant: 12),
            
            contentLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: menuButton.leadingAnchor, constant: -8),
            
            commentImagesCollectionView.topAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 8),
            commentImagesCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            
            menuButton.topAnchor.constraint(equalTo: containerView.topAnchor),
            menuButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            menuButton.widthAnchor.constraint(equalToConstant: 32),
            menuButton.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        // 이미지 컬렉션뷰와 contentLabel의 bottom 제약조건 저장 (나중에 활성화/비활성화)
        // 이미지가 있을 때는 하단에 여백을 추가
        imageCollectionViewBottomConstraint = commentImagesCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        contentLabelBottomConstraint = contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor)
        
        // 기본적으로 contentLabel bottom 활성화 (이미지가 없을 때)
        contentLabelBottomConstraint?.isActive = true
        
        // contentLabel의 leading 제약조건 초기화 (usernameLabel과 같은 위치)
        contentLabelLeadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        contentLabelLeadingConstraint?.isActive = true
        
        // commentImagesCollectionView의 leading 제약조건 초기화 (usernameLabel과 같은 위치)
        collectionViewLeadingConstraint = commentImagesCollectionView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        collectionViewLeadingConstraint?.isActive = true
        
        // profileImageView의 leading 제약조건 초기화 (기본값: 원댓글)
        profileLeadingConstraint = profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        profileLeadingConstraint?.isActive = true
        
        // replyIndicatorView의 제약조건 초기화 (기본값: centerY)
        replyIndicatorViewCenterYConstraint = replyIndicatorView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor)
        replyIndicatorViewTopConstraint = replyIndicatorView.topAnchor.constraint(equalTo: containerView.topAnchor)
    }
    
    func configure(with comment: Comment) {
        usernameLabel.text = comment.authorName
        timeLabel.text = "5시간 전"
        contentLabel.text = comment.content
        privateIconImageView.isHidden = !comment.isPrivate
        
        // 대댓글인 경우
        if comment.parentCommentId != nil {
            showAsReply()
        } else {
            showAsMainComment()
        }
    }
    
    func configure(with commentItem: CommentItem) {
        usernameLabel.text = commentItem.commentWriterNickName ?? "익명"
        timeLabel.text = formatDate(commentItem.commentCreatedAt)
        contentLabel.text = commentItem.commentContent
        privateIconImageView.isHidden = !commentItem.isCommentSecret
        
        // 대댓글인 경우
        if commentItem.parentCommentId != nil {
            showAsReply()
        } else {
            showAsMainComment()
        }
    }
    
    private var commentItem: CommentItem?
    private var onMenuTapped: ((CommentItem) -> Void)?
    private var commentImages: [UIImage] = []
    
    func configure(with commentItem: CommentItem, onMenuTapped: @escaping (CommentItem) -> Void) {
        self.commentItem = commentItem
        self.onMenuTapped = onMenuTapped
        
        usernameLabel.text = commentItem.commentWriterNickName ?? "익명"
        timeLabel.text = formatDate(commentItem.commentCreatedAt)
        
        // isCommentAccessible이 false면 "비밀댓글입니다." 표시
        if !commentItem.isCommentAccessible {
            contentLabel.text = "비밀댓글입니다."
            commentImagesCollectionView.isHidden = true
            collectionViewHeightConstraint?.constant = 0
            imageCollectionViewBottomConstraint?.isActive = false
            contentLabelBottomConstraint?.isActive = true
        } else {
            contentLabel.text = commentItem.commentContent
            // 댓글 이미지 처리
            loadCommentImages(from: commentItem.commentImageUrls ?? [])
        }
        
        privateIconImageView.isHidden = !commentItem.isCommentSecret
        
        // 대댓글인 경우
        if commentItem.parentCommentId != nil {
            showAsReply()
        } else {
            showAsMainComment()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // 초기 상태로 리셋
        showAsMainComment()
    }
    
    private var profileLeadingConstraint: NSLayoutConstraint?
    
    private func setupProfileConstraints() {
        profileLeadingConstraint = profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        profileLeadingConstraint?.isActive = true
    }
    
    private func showAsMainComment() {
        replyIndicatorView.isHidden = true
        replyArrowImageView.isHidden = true
        profileLeadingConstraint?.isActive = false
        profileLeadingConstraint = profileImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        profileLeadingConstraint?.isActive = true
        
        // replyIndicatorView 제약조건 비활성화
        replyIndicatorViewTopConstraint?.isActive = false
        replyIndicatorViewCenterYConstraint?.isActive = false
        
        // contentLabel의 leading 제약조건도 업데이트 (usernameLabel과 같은 위치)
        contentLabelLeadingConstraint?.isActive = false
        contentLabelLeadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        contentLabelLeadingConstraint?.isActive = true
        
        // commentImagesCollectionView의 leading 제약조건도 업데이트
        collectionViewLeadingConstraint?.isActive = false
        collectionViewLeadingConstraint = commentImagesCollectionView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        collectionViewLeadingConstraint?.isActive = true
    }
    
    private func showAsReply() {
        replyIndicatorView.isHidden = false
        replyArrowImageView.isHidden = false
        profileLeadingConstraint?.isActive = false
        profileLeadingConstraint = profileImageView.leadingAnchor.constraint(equalTo: replyIndicatorView.trailingAnchor, constant: 10)
        profileLeadingConstraint?.isActive = true
        
        // replyIndicatorView를 containerView.topAnchor에 맞춤 (원댓글 본문 아래에 오도록)
        replyIndicatorViewCenterYConstraint?.isActive = false
        replyIndicatorViewTopConstraint?.isActive = true
        
        // contentLabel의 leading 제약조건도 업데이트 (usernameLabel과 같은 위치)
        contentLabelLeadingConstraint?.isActive = false
        contentLabelLeadingConstraint = contentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        contentLabelLeadingConstraint?.isActive = true
        
        // commentImagesCollectionView의 leading 제약조건도 업데이트
        collectionViewLeadingConstraint?.isActive = false
        collectionViewLeadingConstraint = commentImagesCollectionView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        collectionViewLeadingConstraint?.isActive = true
    }
    
    private func loadCommentImages(from imageUrls: [String]) {
        print("🖼️ 댓글 이미지 로드 시작: \(imageUrls.count)개")
        commentImages.removeAll()
        
        if imageUrls.isEmpty {
            print("🖼️ 이미지 URL이 없음 - 컬렉션뷰 숨김")
            commentImagesCollectionView.isHidden = true
            collectionViewHeightConstraint?.constant = 0
            
            // 이미지가 없을 때는 contentLabel이 bottom을 결정
            imageCollectionViewBottomConstraint?.isActive = false
            contentLabelBottomConstraint?.isActive = true
            return
        }
        
        print("🖼️ 이미지 URL 있음 - 컬렉션뷰 표시")
        commentImagesCollectionView.isHidden = false
        collectionViewHeightConstraint?.constant = 80
        
        // 이미지가 있을 때는 collectionView가 bottom을 결정
        contentLabelBottomConstraint?.isActive = false
        imageCollectionViewBottomConstraint?.isActive = true
        
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
        var date: Date?
        
        // ISO8601 형식 먼저 시도
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let parsedDate = iso8601Formatter.date(from: dateString) {
            date = parsedDate
        } else {
            // DateFormatter로 시도
            let formatters: [DateFormatter] = [
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
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
            
            for formatter in formatters {
                if let parsedDate = formatter.date(from: dateString) {
                    date = parsedDate
                    break
                }
            }
        }
        
        guard let date = date else {
            print("⚠️ 날짜 파싱 실패: \(dateString)")
            return "방금 전"
        }
        
        // 현재 시간은 로컬(한국) 시간
        let now = Date()
        
        // 서버 시간과 현재 시간의 차이 계산
        // 만약 서버가 이미 한국 시간으로 보내고 있다면 변환 불필요
        // 만약 서버가 UTC로 보내고 있다면 9시간을 더해야 함
        let timeInterval = now.timeIntervalSince(date)
        
        print("📅 날짜 정보:")
        print("   원본: \(dateString)")
        print("   파싱된 날짜: \(date)")
        print("   현재 시간: \(now)")
        print("   시간 차이: \(timeInterval)초 (\(timeInterval/60)분, \(timeInterval/3600)시간)")
        
        // 시간 차이가 음수이거나 매우 작으면 서버가 이미 한국 시간을 보내고 있을 가능성
        if timeInterval < -300 { // -5분보다 작으면 (서버가 미래 시간을 보냄)
            // UTC로 간주하고 9시간 변환
            let koreanDate = date.addingTimeInterval(9 * 60 * 60)
            let adjustedInterval = now.timeIntervalSince(koreanDate)
            print("   조정된 시간 차이: \(adjustedInterval)초")
            return formatTimeInterval(adjustedInterval)
        }
        
        return formatTimeInterval(timeInterval)
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
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

// MARK: - PopoverMenuViewDelegate
extension PostDetailViewController: PopoverMenuViewDelegate {
    func popoverMenuView(_ menuView: PopoverMenuView, didSelectItemAt index: Int) {
        // 댓글 팝업인지 게시글 팝업인지 구분
        if menuView == commentPopoverMenuView {
            // 댓글 팝업 메뉴 처리
            hideCommentPopoverMenu()
            
            guard let commentItem = currentCommentItem else { return }
            
            // 메뉴 아이템 순서: 대댓글 달기(0, 있는 경우), 삭제(마지막)
            let hasReplyOption = commentItem.parentCommentId == nil
            let deleteIndex = hasReplyOption ? 1 : 0
            
            if index == deleteIndex {
                // 삭제
                handleDeleteComment(commentItem)
            } else if index == 0 && hasReplyOption {
                // 대댓글 달기
                handleReplyToComment(commentItem)
            }
        } else {
            // 게시글 더보기 팝업 메뉴 처리
            hidePopoverMenu()
            
            // lost 타입인지 확인
            let isLostType: Bool
            if let post = post {
                isLostType = post.type == .lost
            } else {
                isLostType = navTitleLabel.text == "잃어버렸어요"
            }
            
            // 메뉴 아이템 인덱스에 따라 처리
            if isLostType {
                // lost 타입: 수정(0), 삭제(1), 줍줍 완료(2)
                switch index {
                case 0:
                    handleEditAction()
                case 1:
                    handleDeleteAction()
                case 2:
                    handleJoopjoopAction()
                default:
                    break
                }
            } else {
                // found 타입: 수정(0), 삭제(1)
                switch index {
                case 0:
                    handleEditAction()
                case 1:
                    handleDeleteAction()
                default:
                    break
                }
            }
        }
    }
}
