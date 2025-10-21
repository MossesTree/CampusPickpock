//
//  MyCommentedPostsViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class MyCommentedPostsViewController: UIViewController {
    
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
        imageView.image = UIImage(systemName: "face.smiling")
        imageView.tintColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 댓글 단 글이 없어요"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadPosts()
    }
    
    private func setupUI() {
        title = "댓글 단 글"
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        
        setupCustomBackButton()
        
        // 오른쪽에 줍줍 버튼 추가
        let joopjoopButton = UIBarButtonItem(image: UIImage(systemName: "sparkles"), style: .plain, target: self, action: #selector(joopjoopTapped))
        joopjoopButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        navigationItem.rightBarButtonItem = joopjoopButton
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(postsTableView)
        contentView.addSubview(emptyStateView)
        
        emptyStateView.addSubview(emptyIconImageView)
        emptyStateView.addSubview(emptyMessageLabel)
        emptyStateView.addSubview(emptySubMessageLabel)
        
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
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Posts Table View
            postsTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postsTableView.heightAnchor.constraint(equalToConstant: 600),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: contentView.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            emptyIconImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyIconImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -20),
            emptyIconImageView.widthAnchor.constraint(equalToConstant: 60),
            emptyIconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            emptyMessageLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyMessageLabel.topAnchor.constraint(equalTo: emptyIconImageView.bottomAnchor, constant: 16),
            
            emptySubMessageLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptySubMessageLabel.topAnchor.constraint(equalTo: emptyMessageLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupTableView() {
        postsTableView.delegate = self
        postsTableView.dataSource = self
        postsTableView.register(MyCommentedPostCell.self, forCellReuseIdentifier: "MyCommentedPostCell")
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
        // 현재 사용자가 댓글을 단 게시글만 필터링
        posts = DataManager.shared.getMyCommentedPosts()
        
        // 데이터가 있으면 테이블뷰 표시, 없으면 빈 상태 표시
        postsTableView.isHidden = posts.isEmpty
        emptyStateView.isHidden = !posts.isEmpty
        
        postsTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyCommentedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommentedPostCell", for: indexPath) as! MyCommentedPostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - MyCommentedPostCell
class MyCommentedPostCell: UITableViewCell {
    
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
    
    private let joopjoopButton: UIButton = {
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
        containerView.addSubview(locationTimeLabel)
        containerView.addSubview(joopjoopButton)
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
            itemImageView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: joopjoopButton.leadingAnchor, constant: -8),
            
            locationTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            locationTimeLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            
            joopjoopButton.topAnchor.constraint(equalTo: itemImageView.bottomAnchor, constant: 12),
            joopjoopButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            joopjoopButton.widthAnchor.constraint(equalToConstant: 60),
            joopjoopButton.heightAnchor.constraint(equalToConstant: 32),
            
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
