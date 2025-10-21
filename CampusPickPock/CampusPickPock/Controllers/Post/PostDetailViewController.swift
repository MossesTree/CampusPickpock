//
//  PostDetailViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    private let post: Post
    
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
        loadComments()
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
        
        setupConstraints()
        configureContent()
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
            commentsTableView.heightAnchor.constraint(equalToConstant: 400),
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
            sendButton.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupTableView() {
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        commentsTableView.register(CommentCell.self, forCellReuseIdentifier: "CommentCell")
    }
    
    private func configureContent() {
        usernameLabel.text = post.authorName
        titleLabel.text = post.title
        contentLabel.text = post.content
        commentsCountLabel.text = "댓글 \(post.commentCount)"
        
        // 샘플 이미지 설정 (실제로는 post.images 사용)
        itemImageView.image = UIImage(systemName: "airpods")
        itemImageView.tintColor = .gray
    }
    
    private func loadComments() {
        // 샘플 댓글 데이터
        comments = [
            Comment(id: "1", content: "저 그거 어제 학관 분실물 보관함 쪽지 것 같은데 한번 우리학교 분실물 보관 해보세요", authorId: "user1", authorName: "줍줍했줍", postId: post.id, isPrivate: false, createdAt: Date().addingTimeInterval(-5 * 3600)),
            Comment(id: "2", content: "분실물 보관함 확인해보세요", authorId: "user2", authorName: "이 세상은 나의 것", postId: post.id, isPrivate: true, createdAt: Date().addingTimeInterval(-5 * 3600), parentCommentId: "1")
        ]
        
        commentsTableView.reloadData()
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
                // 줍줍 기능 (분실물을 찾았을 때)
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
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
        cell.configure(with: comments[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
}