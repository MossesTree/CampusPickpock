//
//  MyPageViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .backgroundColor
        return table
    }()
    
    private let profileView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .primaryColor
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let menuItems = [
        ("내가 쓴 글", "doc.text"),
        ("댓글 단 글", "text.bubble"),
        ("분실물 보관함", "archivebox"),
        ("로그아웃", "arrow.right.square")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadUserInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserInfo()
    }
    
    private func setupUI() {
        title = "마이페이지"
        view.backgroundColor = .backgroundColor
        
        setupCustomBackButton()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        setupProfileView()
    }
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    @objc private func backTapped() {
        print("🔙 MyPageViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    private func setupProfileView() {
        profileView.addSubview(profileImageView)
        profileView.addSubview(nameLabel)
        profileView.addSubview(emailLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: profileView.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: profileView.leadingAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -20),
            nameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 12),
            
            emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            
            profileView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")
        tableView.tableHeaderView = profileView
        profileView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 120)
    }
    
    private func loadUserInfo() {
        if let user = DataManager.shared.currentUser {
            nameLabel.text = user.name
            emailLabel.text = user.email
        }
    }
    
    private func handleMenuSelection(index: Int) {
        switch index {
        case 0: // 내가 쓴 글
            showMyPosts()
        case 1: // 댓글 단 글
            showMyCommentedPosts()
        case 2: // 분실물 보관함
            showSavedPosts()
        case 3: // 로그아웃
            handleLogout()
        default:
            break
        }
    }
    
    private func showMyPosts() {
        let myPosts = DataManager.shared.getMyPosts()
        let listVC = PostListViewController(posts: myPosts, title: "내가 쓴 글")
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    private func showMyCommentedPosts() {
        let commentedPosts = DataManager.shared.getMyCommentedPosts()
        let listVC = PostListViewController(posts: commentedPosts, title: "댓글 단 글")
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    private func showSavedPosts() {
        let listVC = PostListViewController(posts: [], title: "분실물 보관함")
        navigationController?.pushViewController(listVC, animated: true)
    }
    
    private func handleLogout() {
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            DataManager.shared.logout()
            self?.navigateToLogin()
        })
        present(alert, animated: true)
    }
    
    private func navigateToLogin() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        let (title, iconName) = menuItems[indexPath.row]
        
        cell.textLabel?.text = title
        cell.imageView?.image = UIImage(systemName: iconName)
        cell.imageView?.tintColor = .primaryColor
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        handleMenuSelection(index: indexPath.row)
    }
}

