//
//  HomeViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class HomeViewController: UIViewController {
    
//    private let scrollView: UIScrollView = {
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.backgroundColor = .backgroundColor
//        return scrollView
//    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍에서\n발견하세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .primaryTextColor
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myPageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("MY PAGE", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .primaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bell"), for: .normal)
        button.tintColor = .primaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notificationBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .dangerColor
        view.layer.cornerRadius = 4
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alertCard: UIView = {
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
    
    private let alertIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "speaker.wave.2")
        imageView.tintColor = .primaryColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let alertUserIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.lightGray
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let alertTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "에어팟찾아삼만리"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let alertSubtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "에어팟 왼쪽 찾아요 ㅠㅠ! 어제 학관 앞에서 10시쯤 잃어버렸습니다 ㅠㅠㅠㅠㅠㅠㅠ 찾으신 분들 있으실까요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let alertButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("바로 보기", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["FOUND", "LOST"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .secondaryBackgroundColor
        control.selectedSegmentTintColor = .primaryColor
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.secondaryTextColor], for: .normal)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let lostBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .dangerColor
        view.layer.cornerRadius = 4
        view.isHidden = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("더 보기 >", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .backgroundColor
        table.separatorStyle = .none
        return table
    }()
    
    private let bottomButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let writeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("글쓰기", for: .normal)
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.backgroundColor = .secondaryBackgroundColor
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let storageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("분실물 보관함", for: .normal)
        button.setImage(UIImage(systemName: "archivebox"), for: .normal)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bottomBar: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomBarLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 학교 분실물 보관함"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomBarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "archivebox")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var posts: [Post] = []
    private var myPagePopover: PopoverMenuView?
    private var writePopover: PopoverMenuView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        loadPosts()
        updateNotificationBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
        updateNotificationBadge()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
//        view.addSubview(scrollView)
        view.addSubview(contentView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(alertCard)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(moreButton)
        contentView.addSubview(tableView)
        contentView.addSubview(bottomButtonContainer)
        contentView.addSubview(bottomBar)
        
        bottomButtonContainer.addSubview(writeButton)
        bottomButtonContainer.addSubview(storageButton)
        
        headerView.addSubview(titleLabel)
        headerView.addSubview(titleUnderlineView)
        headerView.addSubview(myPageButton)
        headerView.addSubview(searchButton)
        headerView.addSubview(notificationButton)
        headerView.addSubview(notificationBadge)
        
        alertCard.addSubview(alertIcon)
        alertCard.addSubview(alertUserIcon)
        alertCard.addSubview(alertTitleLabel)
        alertCard.addSubview(alertSubtitleLabel)
        alertCard.addSubview(alertButton)
        
        segmentedControl.addSubview(lostBadge)
        
        bottomBar.addSubview(bottomBarLabel)
        bottomBar.addSubview(bottomBarIcon)
        
        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: view.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 90),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 50),
            
            titleUnderlineView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleUnderlineView.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            titleUnderlineView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -8),
            titleUnderlineView.heightAnchor.constraint(equalToConstant: 3),
            
            myPageButton.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: -16),
            myPageButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 50),
            
            searchButton.trailingAnchor.constraint(equalTo: notificationButton.leadingAnchor, constant: -16),
            searchButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 50),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),
            
            notificationButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            notificationButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 50),
            notificationButton.widthAnchor.constraint(equalToConstant: 24),
            notificationButton.heightAnchor.constraint(equalToConstant: 24),
            
            notificationBadge.topAnchor.constraint(equalTo: notificationButton.topAnchor),
            notificationBadge.trailingAnchor.constraint(equalTo: notificationButton.trailingAnchor),
            notificationBadge.widthAnchor.constraint(equalToConstant: 8),
            notificationBadge.heightAnchor.constraint(equalToConstant: 8),
            
            alertCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            alertCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            alertCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            alertCard.heightAnchor.constraint(equalToConstant: 100),
            
            alertIcon.leadingAnchor.constraint(equalTo: alertCard.leadingAnchor, constant: 16),
            alertIcon.topAnchor.constraint(equalTo: alertCard.topAnchor, constant: 16),
            alertIcon.widthAnchor.constraint(equalToConstant: 24),
            alertIcon.heightAnchor.constraint(equalToConstant: 24),
            
            alertUserIcon.trailingAnchor.constraint(equalTo: alertButton.leadingAnchor, constant: -12),
            alertUserIcon.topAnchor.constraint(equalTo: alertCard.topAnchor, constant: 16),
            alertUserIcon.widthAnchor.constraint(equalToConstant: 24),
            alertUserIcon.heightAnchor.constraint(equalToConstant: 24),
            
            alertTitleLabel.trailingAnchor.constraint(equalTo: alertUserIcon.leadingAnchor, constant: -8),
            alertTitleLabel.topAnchor.constraint(equalTo: alertCard.topAnchor, constant: 16),
            
            alertSubtitleLabel.leadingAnchor.constraint(equalTo: alertIcon.trailingAnchor, constant: 12),
            alertSubtitleLabel.topAnchor.constraint(equalTo: alertIcon.bottomAnchor, constant: 8),
            alertSubtitleLabel.trailingAnchor.constraint(equalTo: alertButton.leadingAnchor, constant: -12),
            
            alertButton.trailingAnchor.constraint(equalTo: alertCard.trailingAnchor, constant: -16),
            alertButton.centerYAnchor.constraint(equalTo: alertCard.centerYAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: alertCard.bottomAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            lostBadge.topAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -4),
            lostBadge.trailingAnchor.constraint(equalTo: segmentedControl.trailingAnchor, constant: -60),
            lostBadge.widthAnchor.constraint(equalToConstant: 8),
            lostBadge.heightAnchor.constraint(equalToConstant: 8),
            
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moreButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 40),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            
            bottomButtonContainer.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            bottomButtonContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomButtonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            
            writeButton.leadingAnchor.constraint(equalTo: bottomButtonContainer.leadingAnchor, constant: 20),
            writeButton.centerYAnchor.constraint(equalTo: bottomButtonContainer.centerYAnchor),
            writeButton.widthAnchor.constraint(equalToConstant: 120),
            writeButton.heightAnchor.constraint(equalToConstant: 50),
            
            storageButton.trailingAnchor.constraint(equalTo: bottomButtonContainer.trailingAnchor, constant: -20),
            storageButton.centerYAnchor.constraint(equalTo: bottomButtonContainer.centerYAnchor),
            storageButton.widthAnchor.constraint(equalToConstant: 200),
            storageButton.heightAnchor.constraint(equalToConstant: 50),
            
            bottomBar.topAnchor.constraint(equalTo: bottomButtonContainer.bottomAnchor, constant: 20),
            bottomBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 60),
            bottomBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bottomBarLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            bottomBarLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            bottomBarIcon.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -20),
            bottomBarIcon.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            bottomBarIcon.widthAnchor.constraint(equalToConstant: 20),
            bottomBarIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }
    
    private func setupActions() {
        myPageButton.addTarget(self, action: #selector(myPageTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        alertButton.addTarget(self, action: #selector(alertTapped), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        writeButton.addTarget(self, action: #selector(writeTapped), for: .touchUpInside)
        storageButton.addTarget(self, action: #selector(storageTapped), for: .touchUpInside)
    }
    
    private func loadPosts() {
        posts = DataManager.shared.getPosts()
        tableView.reloadData()
    }
    
    private func updateNotificationBadge() {
        let unreadCount = NotificationManager.shared.getUnreadCount()
        notificationBadge.isHidden = unreadCount == 0
    }
    
    @objc private func myPageTapped() {
        showMyPagePopover()
    }
    
    @objc private func writeTapped() {
        showWritePopover()
    }
    
    @objc private func searchTapped() {
        // 검색으로 이동
        print("🔍 검색 버튼 탭됨")
        print("🔍 현재 navigationController: \(navigationController != nil ? "존재함" : "nil")")
        let searchVC = SearchViewController()
        navigationController?.pushViewController(searchVC, animated: true)
        print("🔍 SearchViewController로 이동 완료")
    }
    
    @objc private func notificationTapped() {
        let notificationVC = NotificationListViewController()
        navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    @objc private func alertTapped() {
        // 알림 카드 클릭 시 해당 게시글로 이동
        if let firstPost = posts.first {
            let detailVC = PostDetailViewController(post: firstPost)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    @objc private func segmentChanged() {
        // FOUND/LOST 토글 처리
        loadPosts()
    }
    
    @objc private func moreTapped() {
        // 더 보기 버튼 처리 - 현재 선택된 탭에 따라 다른 화면으로 이동
        if segmentedControl.selectedSegmentIndex == 0 {
            // FOUND 탭이 선택된 경우 - FoundPostListViewController로 이동
            let foundListVC = FoundPostListViewController()
            navigationController?.pushViewController(foundListVC, animated: true)
        } else {
            // LOST 탭이 선택된 경우 - LostPostListViewController로 이동
            let lostListVC = LostPostListViewController()
            navigationController?.pushViewController(lostListVC, animated: true)
        }
    }
    
    private func showMyPagePopover() {
        print("📱 showMyPagePopover 호출됨")
        hideAllPopovers()
        
        let menuItems = [
            MenuItem(title: DataManager.shared.currentUser?.name ?? "사용자", iconName: "person.circle"),
            MenuItem(title: "내가 쓴 글", iconName: "doc.text"),
            MenuItem(title: "댓글 단 글", iconName: "text.bubble"),
            MenuItem(title: "로그아웃", iconName: "rectangle.portrait.and.arrow.right")
        ]
        
        myPagePopover = PopoverMenuView()
        print("📱 PopoverMenuView 생성됨")
        myPagePopover?.delegate = self
        print("📱 delegate 설정됨: \(myPagePopover?.delegate != nil ? "성공" : "실패")")
        myPagePopover?.configure(with: menuItems)
        
        guard let popover = myPagePopover else { 
            print("❌ popover가 nil")
            return 
        }
        view.addSubview(popover)
        view.bringSubviewToFront(popover)
        print("📱 popover가 view에 추가됨")
        
        // MY PAGE 버튼 위치에 팝오버 배치
        popover.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popover.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            popover.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            popover.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        popover.alpha = 0
        popover.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2) {
            popover.alpha = 1
            popover.transform = .identity
        }
    }
    
    private func showWritePopover() {
        print("✍️ showWritePopover 호출됨")
        hideAllPopovers()
        
        let menuItems = [
            MenuItem(title: "주인을 찾아요", iconName: "magnifyingglass"),
            MenuItem(title: "잃어버렸어요", iconName: "lightbulb")
        ]
        
        writePopover = PopoverMenuView()
        print("✍️ PopoverMenuView 생성됨")
        writePopover?.delegate = self
        print("✍️ delegate 설정됨: \(writePopover?.delegate != nil ? "성공" : "실패")")
        writePopover?.configure(with: menuItems)
        
        guard let popover = writePopover else { 
            print("❌ writePopover가 nil")
            return 
        }
        view.addSubview(popover)
        view.bringSubviewToFront(popover)
        print("✍️ writePopover가 view에 추가됨")
        
        // 글쓰기 버튼 위치에 팝오버 배치
        popover.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            popover.centerXAnchor.constraint(equalTo: writeButton.centerXAnchor),
            popover.bottomAnchor.constraint(equalTo: writeButton.topAnchor, constant: -8),
            popover.widthAnchor.constraint(equalToConstant: 160)
        ])
        
        popover.alpha = 0
        popover.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2) {
            popover.alpha = 1
            popover.transform = .identity
        }
    }
    
    private func hideAllPopovers() {
        myPagePopover?.removeFromSuperview()
        writePopover?.removeFromSuperview()
        myPagePopover = nil
        writePopover = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        hideAllPopovers()
    }
    
    @objc private func storageTapped() {
        print("🏠 분실물 보관함 버튼 탭됨")
        print("🏠 현재 navigationController: \(navigationController != nil ? "존재함" : "nil")")
        let lostAndFoundVC = LostAndFoundViewController()
        navigationController?.pushViewController(lostAndFoundVC, animated: true)
        print("🏠 LostAndFoundViewController로 이동 완료")
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = posts[indexPath.row]
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: PopoverMenuViewDelegate {
    func popoverMenuView(_ menuView: PopoverMenuView, didSelectItemAt index: Int) {
        print("🔍 팝오버 메뉴 선택됨: index = \(index)")
        
        if menuView == myPagePopover {
            print("📱 MY PAGE 메뉴 선택")
            handleMyPageMenuSelection(index: index)
        } else if menuView == writePopover {
            print("✍️ 글쓰기 메뉴 선택")
            handleWriteMenuSelection(index: index)
        }
        
        hideAllPopovers()
    }
    
    func handleMyPageMenuSelection(index: Int) {
        print("📱 MY PAGE 메뉴 처리 시작: index = \(index)")
        print("📱 현재 navigationController: \(navigationController != nil ? "존재함" : "nil")")
        print("📱 현재 viewController: \(self)")
        switch index {
        case 0: // 사용자 닉네임
            print("👤 사용자 닉네임 선택 - 기능 실행")
            // 사용자 정보 표시 또는 프로필 수정 (현재는 아무 동작 없음)
            break
                case 1: // 내가 쓴 글
                    print("📝 내가 쓴 글 선택 - 기능 실행")
                    let myPostsVC = MyPostsViewController()
                    navigationController?.pushViewController(myPostsVC, animated: true)
                    print("📝 MyPostsViewController로 이동 완료")
                case 2: // 댓글 단 글
                    print("💬 댓글 단 글 선택 - 기능 실행")
                    let myCommentedPostsVC = MyCommentedPostsViewController()
                    navigationController?.pushViewController(myCommentedPostsVC, animated: true)
                    print("💬 MyCommentedPostsViewController로 이동 완료")
        case 3: // 로그아웃
            print("🚪 로그아웃 선택 - 기능 실행")
            showLogoutAlert()
        default:
            print("❌ 알 수 없는 index: \(index)")
            break
        }
        print("📱 MY PAGE 메뉴 처리 완료")
    }
    
    func showLogoutAlert() {
        print("🚪 showLogoutAlert 호출됨")
        let alert = UIAlertController(title: "로그아웃", message: "정말 로그아웃 하시겠습니까?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "로그아웃", style: .destructive) { [weak self] _ in
            self?.performLogout()
        })
        
        present(alert, animated: true)
    }
    
    func performLogout() {
        print("🚪 performLogout 호출됨")
        DataManager.shared.logout()
        
        // 스플래시 화면으로 이동
        let splashVC = SplashViewController()
        splashVC.modalPresentationStyle = .fullScreen
        splashVC.modalTransitionStyle = .crossDissolve
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = splashVC
            window.makeKeyAndVisible()
        }
    }
    
    func handleWriteMenuSelection(index: Int) {
        print("✍️ 글쓰기 메뉴 처리 시작: index = \(index)")
        switch index {
        case 0: // 주인을 찾아요 (습득물 등록)
            print("🔍 주인을 찾아요 선택 - 기능 실행")
            let createPostVC = PostCreateViewController()
            navigationController?.pushViewController(createPostVC, animated: true)
            print("🔍 PostCreateViewController로 이동 완료")
        case 1: // 잃어버렸어요 (분실물 등록)
            print("💡 잃어버렸어요 선택 - 기능 실행")
            let lostPostVC = PostLostViewController()
            navigationController?.pushViewController(lostPostVC, animated: true)
            print("💡 PostLostViewController로 이동 완료")
        default:
            print("❌ 알 수 없는 index: \(index)")
            break
        }
        print("✍️ 글쓰기 메뉴 처리 완료")
    }
}


