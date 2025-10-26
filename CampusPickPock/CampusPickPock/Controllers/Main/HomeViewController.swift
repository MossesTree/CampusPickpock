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
        label.font = UIFont(name: "Pretendard Variable", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = UIColor(red: 19/255, green: 45/255, blue: 100/255, alpha: 1.0) // 132D64
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleUnderlineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let myPageButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSAttributedString(
            string: "MY PAGE",
            attributes: [
                .font: UIFont.boldSystemFont(ofSize: 10),
                .foregroundColor: UIColor.primaryColor,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "SearchIcon"), for: .normal)
        button.tintColor = UIColor(red: 0x13/255.0, green: 0x2D/255.0, blue: 0x64/255.0, alpha: 1.0) // 132D64
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "NotificationIcon"), for: .normal)
        button.tintColor = UIColor(red: 0x4A/255.0, green: 0x4A/255.0, blue: 0x4A/255.0, alpha: 1.0) // 진한 회색 (거의 검정)
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
        view.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0) // F7F7F7
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
    
    private let alertButtonLabel: UILabel = {
        let label = UILabel()
        label.text = "바로 보기"
        label.textColor = .primaryColor
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let segmentedControlContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let foundButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("FOUND", for: .normal)
        button.backgroundColor = UIColor(red: 0x42/255.0, green: 0x85/255.0, blue: 0xF4/255.0, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let lostButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("LOST", for: .normal)
        button.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        button.setTitleColor(UIColor(red: 0x4A/255.0, green: 0x4A/255.0, blue: 0x4A/255.0, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["FOUND", "LOST"]
        let control = UISegmentedControl(items: items)
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .clear
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor(red: 0x4A/255.0, green: 0x4A/255.0, blue: 0x4A/255.0, alpha: 1.0)], for: .normal)
        control.isHidden = true  // 커스텀 버튼 사용
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var selectedSegment: Int = 0 {
        didSet {
            updateSegmentButtons()
            segmentedControl.selectedSegmentIndex = selectedSegment
        }
    }
    
    private let lostBadge: UIView = {
        let view = UIView()
        view.backgroundColor = .dangerColor
        view.layer.cornerRadius = 3
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
        button.backgroundColor = UIColor(red: 0xCE/255.0, green: 0xD6/255.0, blue: 0xE9/255.0, alpha: 1.0) // CED6E9
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let bottomBar: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .primaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let bottomBarLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 학교 분실물 보관함"
        label.textColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0) // F7F7F7
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bottomBarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "archivebox")
        imageView.tintColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0) // F7F7F7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // MARK: - JupJup Notification Popup
    private let notificationPopupView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 0.95)
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    private let notificationCloseButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let notificationStarIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "star.fill")
        imageView.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let notificationTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "줍줍 알림이 도착했어요!"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notificationMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "누군가 내가 올린 게시글에 줍줍 버튼을 눌렀어요!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let notificationActionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("게시글 확인하기", for: .normal)
        button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        button.setTitleColor(UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var pendingJupJupNotification: JupJupNotificationItem?
    
    // MARK: - Data Properties
    private var posts: [Post] = []
    private var postingItems: [PostingItem] = []
    private var homePostingItems: [HomePostingItem] = []
    private var bannerItem: BannerItem?
    private var myPagePopover: PopoverMenuView?
    private var writePopover: PopoverMenuView?
    private var backgroundTapGesture: UITapGestureRecognizer?
    private var currentPage = 0
    private let pageSize = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        
        // 토큰 상태 확인
        DataManager.shared.checkTokenStatus()
        
        // 초기 상태에서 배너 카드 숨기기
        alertCard.isHidden = true
        
        loadBannerData()
        loadPosts()
        updateNotificationBadge()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
        updateNotificationBadge()
        checkJupJupNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
//        view.addSubview(scrollView)
        view.addSubview(contentView)
        view.addSubview(notificationPopupView)
        
        contentView.addSubview(headerView)
        contentView.addSubview(alertCard)
        contentView.addSubview(segmentedControlContainer)
        contentView.addSubview(segmentedControl)
        contentView.addSubview(moreButton)
        contentView.addSubview(tableView)
        
        segmentedControlContainer.addSubview(foundButton)
        segmentedControlContainer.addSubview(lostButton)
        contentView.addSubview(bottomButtonContainer)
        contentView.addSubview(bottomBar)
        
        notificationPopupView.addSubview(notificationCloseButton)
        notificationPopupView.addSubview(notificationStarIcon)
        notificationPopupView.addSubview(notificationTitleLabel)
        notificationPopupView.addSubview(notificationMessageLabel)
        notificationPopupView.addSubview(notificationActionButton)
        
        bottomButtonContainer.addSubview(writeButton)
        
        headerView.addSubview(titleUnderlineView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(myPageButton)
        headerView.addSubview(searchButton)
        headerView.addSubview(notificationButton)
        headerView.addSubview(notificationBadge)
        
        alertCard.addSubview(alertIcon)
        alertCard.addSubview(alertTitleLabel)
        alertCard.addSubview(alertSubtitleLabel)
        alertCard.addSubview(alertButtonLabel)
        
        contentView.addSubview(lostBadge)
        
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
            headerView.heightAnchor.constraint(equalToConstant: 150),
            
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 25),
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 85),
            
            titleUnderlineView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 26),
            titleUnderlineView.widthAnchor.constraint(equalToConstant: 56),
            titleUnderlineView.heightAnchor.constraint(equalToConstant: 8),
            titleUnderlineView.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 148),
            
            myPageButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 308),
            myPageButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 62),
            
            searchButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 296),
            searchButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 92),
            searchButton.widthAnchor.constraint(equalToConstant: 24),
            searchButton.heightAnchor.constraint(equalToConstant: 24),
            
            notificationButton.leadingAnchor.constraint(equalTo: searchButton.trailingAnchor, constant: 12),
            notificationButton.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 92),
            notificationButton.widthAnchor.constraint(equalToConstant: 24),
            notificationButton.heightAnchor.constraint(equalToConstant: 24),
            
            notificationBadge.topAnchor.constraint(equalTo: notificationButton.topAnchor),
            notificationBadge.trailingAnchor.constraint(equalTo: notificationButton.trailingAnchor),
            notificationBadge.widthAnchor.constraint(equalToConstant: 8),
            notificationBadge.heightAnchor.constraint(equalToConstant: 8),
            
            alertCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            alertCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 202),
            alertCard.widthAnchor.constraint(equalToConstant: 325),
            alertCard.heightAnchor.constraint(equalToConstant: 60),
            
            // 왼쪽 아이콘 (스피커 아이콘으로 변경)
            alertIcon.leadingAnchor.constraint(equalTo: alertCard.leadingAnchor, constant: 12),
            alertIcon.centerYAnchor.constraint(equalTo: alertCard.centerYAnchor),
            alertIcon.widthAnchor.constraint(equalToConstant: 20),
            alertIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // 중앙 텍스트 영역 (닉네임과 메시지 내용)
            alertTitleLabel.leadingAnchor.constraint(equalTo: alertIcon.trailingAnchor, constant: 12),
            alertTitleLabel.topAnchor.constraint(equalTo: alertCard.topAnchor, constant: 12),
            
            alertSubtitleLabel.leadingAnchor.constraint(equalTo: alertTitleLabel.leadingAnchor),
            alertSubtitleLabel.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 4),
            alertSubtitleLabel.trailingAnchor.constraint(equalTo: alertButtonLabel.leadingAnchor, constant: -12),
            
            // 오른쪽 텍스트
            alertButtonLabel.trailingAnchor.constraint(equalTo: alertCard.trailingAnchor, constant: -12),
            alertButtonLabel.centerYAnchor.constraint(equalTo: alertCard.centerYAnchor),
            
            segmentedControlContainer.topAnchor.constraint(equalTo: alertCard.bottomAnchor, constant: 37),
            segmentedControlContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            segmentedControlContainer.widthAnchor.constraint(equalToConstant: 324),
            segmentedControlContainer.heightAnchor.constraint(equalToConstant: 48),
            
            segmentedControl.topAnchor.constraint(equalTo: alertCard.bottomAnchor, constant: 37),
            segmentedControl.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            segmentedControl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            segmentedControl.heightAnchor.constraint(equalToConstant: 40),
            
            foundButton.leadingAnchor.constraint(equalTo: segmentedControlContainer.leadingAnchor, constant: 4),
            foundButton.centerYAnchor.constraint(equalTo: segmentedControlContainer.centerYAnchor),
            foundButton.widthAnchor.constraint(equalToConstant: 160),
            foundButton.heightAnchor.constraint(equalToConstant: 38),
            
            lostButton.leadingAnchor.constraint(equalTo: foundButton.trailingAnchor, constant: 4),
            lostButton.trailingAnchor.constraint(equalTo: segmentedControlContainer.trailingAnchor, constant: -4),
            lostButton.centerYAnchor.constraint(equalTo: segmentedControlContainer.centerYAnchor),
            lostButton.heightAnchor.constraint(equalToConstant: 38),
            
            lostBadge.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 287),
            lostBadge.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 311),
            lostBadge.widthAnchor.constraint(equalToConstant: 6),
            lostBadge.heightAnchor.constraint(equalToConstant: 6),
            
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            moreButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
            
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 377),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            tableView.widthAnchor.constraint(equalToConstant: 325),
            tableView.heightAnchor.constraint(equalToConstant: 400),
            
            bottomButtonContainer.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            bottomButtonContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomButtonContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomButtonContainer.heightAnchor.constraint(equalToConstant: 60),
            
            writeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 147),
            writeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 663),
            writeButton.widthAnchor.constraint(equalToConstant: 81),
            writeButton.heightAnchor.constraint(equalToConstant: 30),
            
            bottomBar.topAnchor.constraint(equalTo: bottomButtonContainer.bottomAnchor, constant: 20),
            bottomBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 72),
            bottomBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            bottomBarLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            bottomBarLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            
            bottomBarIcon.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -20),
            bottomBarIcon.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            bottomBarIcon.widthAnchor.constraint(equalToConstant: 20),
            bottomBarIcon.heightAnchor.constraint(equalToConstant: 20),
            
            // Notification Popup Constraints
            notificationPopupView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            notificationPopupView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            notificationPopupView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notificationPopupView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notificationPopupView.heightAnchor.constraint(equalToConstant: 280),
            
            notificationCloseButton.topAnchor.constraint(equalTo: notificationPopupView.topAnchor, constant: 16),
            notificationCloseButton.trailingAnchor.constraint(equalTo: notificationPopupView.trailingAnchor, constant: -16),
            notificationCloseButton.widthAnchor.constraint(equalToConstant: 24),
            notificationCloseButton.heightAnchor.constraint(equalToConstant: 24),
            
            notificationStarIcon.topAnchor.constraint(equalTo: notificationPopupView.topAnchor, constant: 40),
            notificationStarIcon.centerXAnchor.constraint(equalTo: notificationPopupView.centerXAnchor),
            notificationStarIcon.widthAnchor.constraint(equalToConstant: 60),
            notificationStarIcon.heightAnchor.constraint(equalToConstant: 60),
            
            notificationTitleLabel.topAnchor.constraint(equalTo: notificationStarIcon.bottomAnchor, constant: 16),
            notificationTitleLabel.leadingAnchor.constraint(equalTo: notificationPopupView.leadingAnchor, constant: 20),
            notificationTitleLabel.trailingAnchor.constraint(equalTo: notificationPopupView.trailingAnchor, constant: -20),
            
            notificationMessageLabel.topAnchor.constraint(equalTo: notificationTitleLabel.bottomAnchor, constant: 8),
            notificationMessageLabel.leadingAnchor.constraint(equalTo: notificationPopupView.leadingAnchor, constant: 20),
            notificationMessageLabel.trailingAnchor.constraint(equalTo: notificationPopupView.trailingAnchor, constant: -20),
            
            notificationActionButton.topAnchor.constraint(equalTo: notificationMessageLabel.bottomAnchor, constant: 24),
            notificationActionButton.leadingAnchor.constraint(equalTo: notificationPopupView.leadingAnchor, constant: 20),
            notificationActionButton.trailingAnchor.constraint(equalTo: notificationPopupView.trailingAnchor, constant: -20),
            notificationActionButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.rowHeight = 87  // 셀 높이 87 (간격 없음)
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.sectionFooterHeight = 0
        tableView.sectionHeaderHeight = 0
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.isScrollEnabled = false
    }
    
    private func setupActions() {
        myPageButton.addTarget(self, action: #selector(myPageTapped), for: .touchUpInside)
        searchButton.addTarget(self, action: #selector(searchTapped), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        foundButton.addTarget(self, action: #selector(foundButtonTapped), for: .touchUpInside)
        lostButton.addTarget(self, action: #selector(lostButtonTapped), for: .touchUpInside)
        moreButton.addTarget(self, action: #selector(moreTapped), for: .touchUpInside)
        writeButton.addTarget(self, action: #selector(writeTapped), for: .touchUpInside)
        bottomBar.addTarget(self, action: #selector(storageTapped), for: .touchUpInside)
        notificationCloseButton.addTarget(self, action: #selector(notificationCloseTapped), for: .touchUpInside)
        notificationActionButton.addTarget(self, action: #selector(notificationActionTapped), for: .touchUpInside)
        
        // 배너 카드 액션 추가
        let bannerTapGesture = UITapGestureRecognizer(target: self, action: #selector(bannerTapped))
        alertCard.addGestureRecognizer(bannerTapGesture)
        alertCard.isUserInteractionEnabled = true
    }
    
    private func loadBannerData() {
        APIService.shared.getBannerData { [weak self] result in
            switch result {
            case .success(let bannerItem):
                DispatchQueue.main.async {
                    if let bannerItem = bannerItem {
                        print("✅ 배너 데이터 로드 성공: 1개")
                        self?.bannerItem = bannerItem
                        self?.updateBannerUI()
                    } else {
                        print("⚠️ 배너 데이터 없음")
                        self?.alertCard.isHidden = true
                    }
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("❌ 배너 데이터 로드 실패: \(error.localizedDescription)")
                    // 배너 데이터가 없어도 앱은 정상 동작
                    self?.alertCard.isHidden = true
                }
            }
        }
    }
    
    private func updateBannerUI() {
        guard let bannerItem = bannerItem else {
            print("⚠️ 배너 데이터가 없음")
            // 배너가 없으면 alertCard 숨기기
            alertCard.isHidden = true
            return
        }
        
        print("🎯 배너 업데이트: \(bannerItem.postingTitle) - \(bannerItem.postingWriterNickName)")
        
        // alertCard 표시
        alertCard.isHidden = false
        
        // 배너 데이터를 UI에 표시
        alertTitleLabel.text = bannerItem.postingWriterNickName
        alertSubtitleLabel.text = bannerItem.postingTitle
        
        // 배너 아이콘 업데이트 (스피커 아이콘으로 변경)
        alertIcon.image = UIImage(systemName: "speaker.wave.2.fill")
        alertIcon.tintColor = .primaryColor
    }
    
    private func loadPosts() {
        let postType = selectedSegment == 0 ? "FOUND" : "LOST"
        
        APIService.shared.getHomePostings(type: postType) { [weak self] result in
            switch result {
            case .success(let homePostingItems):
                DispatchQueue.main.async {
                    print("✅ 홈 게시글 로드 성공: \(homePostingItems.count)개")
                    self?.homePostingItems = homePostingItems
                    self?.tableView.reloadData()
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("❌ 홈 게시글 로드 실패: \(error.localizedDescription)")
                    // 로컬 데이터로 폴백
                    self?.posts = DataManager.shared.getPosts()
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func updateNotificationBadge() {
        let unreadCount = NotificationManager.shared.getUnreadCount()
        notificationBadge.isHidden = unreadCount == 0
    }
    
    @objc private func myPageTapped() {
        if myPagePopover != nil {
            // 이미 팝오버가 열려있으면 닫기
            hideAllPopovers()
        } else {
            // 팝오버가 없으면 열기
            showMyPagePopover()
        }
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
    
    @objc private func bannerTapped() {
        guard let bannerItem = bannerItem else {
            print("❌ 배너 데이터가 없어서 상세화면으로 이동할 수 없습니다.")
            return
        }
        
        print("🎯 배너 버튼 탭: postingId = \(bannerItem.postingId)")
        
        // 게시글 상세 정보를 가져와서 상세화면으로 이동
        APIService.shared.getPostDetail(postingId: bannerItem.postingId) { [weak self] result in
            switch result {
            case .success(let postDetail):
                DispatchQueue.main.async {
                    // PostDetailItem을 Post로 변환
                    let post = Post(
                        id: String(bannerItem.postingId),
                        postingId: bannerItem.postingId,
                        title: postDetail.postingTitle,
                        content: postDetail.postingContent,
                        images: [], // 이미지는 별도로 로드
                        authorId: String(postDetail.postingWriterId),
                        authorName: postDetail.postingWriterNickname ?? "익명",
                        isHidden: !postDetail.isPostingAccessible,
                        createdAt: self?.parseDate(from: postDetail.postingCreatedAt ?? "") ?? Date(),
                        commentCount: 0,
                        type: .found // 배너는 일반적으로 Found 타입으로 가정
                    )
                    
                    let detailVC = PostDetailViewController(post: post)
                    self?.navigationController?.pushViewController(detailVC, animated: true)
                }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    print("❌ 배너 게시글 상세 정보 로드 실패: \(error.localizedDescription)")
                    
                    // 에러 알림
                    let alert = UIAlertController(
                        title: "오류",
                        message: "게시글 정보를 불러올 수 없습니다.",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func segmentChanged() {
        // FOUND/LOST 토글 처리
        currentPage = 0
        selectedSegment = segmentedControl.selectedSegmentIndex
        loadPosts()
    }
    
    @objc private func foundButtonTapped() {
        selectedSegment = 0
        currentPage = 0
        loadPosts()
    }
    
    @objc private func lostButtonTapped() {
        selectedSegment = 1
        currentPage = 0
        loadPosts()
    }
    
    private func updateSegmentButtons() {
        if selectedSegment == 0 {
            // FOUND 선택
            foundButton.backgroundColor = UIColor(red: 0x42/255.0, green: 0x85/255.0, blue: 0xF4/255.0, alpha: 1.0)
            foundButton.setTitleColor(.white, for: .normal)
            foundButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            
            lostButton.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
            lostButton.setTitleColor(UIColor(red: 0x4A/255.0, green: 0x4A/255.0, blue: 0x4A/255.0, alpha: 1.0), for: .normal)
            lostButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            // 빨간 점 보이기
            lostBadge.isHidden = false
        } else {
            // LOST 선택
            lostButton.backgroundColor = UIColor(red: 0x42/255.0, green: 0x85/255.0, blue: 0xF4/255.0, alpha: 1.0)
            lostButton.setTitleColor(.white, for: .normal)
            lostButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            
            foundButton.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
            foundButton.setTitleColor(UIColor(red: 0x4A/255.0, green: 0x4A/255.0, blue: 0x4A/255.0, alpha: 1.0), for: .normal)
            foundButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            
            // 빨간 점 숨기기
            lostBadge.isHidden = true
        }
    }
    
    @objc private func moreTapped() {
        // 더 보기 버튼 처리 - 현재 선택된 탭에 따라 다른 화면으로 이동
        if selectedSegment == 0 {
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
        
        // 배경 터치 가능하게 만들기
        backgroundTapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        if let tapGesture = backgroundTapGesture {
            view.addGestureRecognizer(tapGesture)
        }
        
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
            popover.trailingAnchor.constraint(equalTo: myPageButton.trailingAnchor),
            popover.topAnchor.constraint(equalTo: myPageButton.bottomAnchor, constant: 7),
            popover.widthAnchor.constraint(equalToConstant: 200)
        ])
        
        popover.alpha = 0
        popover.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.2) {
            popover.alpha = 1
            popover.transform = .identity
        }
    }
    
    @objc private func backgroundTapped() {
        print("📱 배경 터치됨 - 팝오버 닫기")
        hideAllPopovers()
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
        
        // 배경 제스처 제거
        if let tapGesture = backgroundTapGesture {
            view.removeGestureRecognizer(tapGesture)
            backgroundTapGesture = nil
        }
    }
    
    // MARK: - JupJup Notification Methods
    private func checkJupJupNotifications() {
        print("🔔 줍줍 알림 확인 시작")
        
        // Found 타입 알림 확인 (분실물을 찾았다는 알림)
        APIService.shared.getJupJupNotifications(type: "Found") { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let notifications):
                    print("✅ 줍줍 알림 확인 성공: \(notifications.count)개")
                    
                    if !notifications.isEmpty {
                        // 첫 번째 알림을 표시
                        self?.pendingJupJupNotification = notifications.first
                        self?.showJupJupNotificationPopup()
                    } else {
                        print("📭 확인하지 않은 줍줍 알림 없음")
                    }
                    
                case .failure(let error):
                    print("❌ 줍줍 알림 확인 실패: \(error.localizedDescription)")
                    // 에러가 발생해도 사용자에게 알리지 않음 (백그라운드 작업)
                }
            }
        }
    }
    
    // MARK: - Image Loading
    private func loadImageFromURL(_ urlString: String, for cell: PostCell) {
        guard let url = URL(string: urlString) else {
            print("❌ 잘못된 이미지 URL: \(urlString)")
            return
        }
        
        print("🖼️ 이미지 로딩 시작: \(urlString)")
        
        URLSession.shared.dataTask(with: url) { [weak cell] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ 이미지 로딩 실패: \(error.localizedDescription)")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    print("❌ 이미지 데이터 변환 실패")
                    return
                }
                
                print("✅ 이미지 로딩 성공: \(urlString)")
                
                // 셀이 여전히 화면에 표시되고 있는지 확인
                guard let cell = cell else { return }
                
                // PostCell에 이미지 설정
                cell.setThumbnailImage(image)
            }
        }.resume()
    }
    
    private func showJupJupNotificationPopup() {
        print("🔔 줍줍 알림 팝업 표시")
        
        notificationPopupView.isHidden = false
        notificationPopupView.alpha = 0
        notificationPopupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.notificationPopupView.alpha = 1
            self.notificationPopupView.transform = .identity
        }
    }
    
    private func hideJupJupNotificationPopup() {
        print("🔔 줍줍 알림 팝업 숨김")
        
        UIView.animate(withDuration: 0.2, animations: {
            self.notificationPopupView.alpha = 0
            self.notificationPopupView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { _ in
            self.notificationPopupView.isHidden = true
            self.pendingJupJupNotification = nil
        }
    }
    
    @objc private func notificationCloseTapped() {
        print("🔔 알림 팝업 닫기 버튼 탭됨")
        hideJupJupNotificationPopup()
    }
    
    @objc private func notificationActionTapped() {
        print("🔔 알림 팝업 액션 버튼 탭됨")
        
        guard let notification = pendingJupJupNotification else {
            print("❌ 알림 정보가 없습니다")
            return
        }
        
        print("🔔 게시글 상세 화면으로 이동: postingId=\(notification.postingId)")
        
        // 팝업 숨김
        hideJupJupNotificationPopup()
        
        // 게시글 상세 정보를 가져와서 PostDetailViewController로 이동
        APIService.shared.getPostDetail(postingId: notification.postingId) { [weak self] result in
            switch result {
            case .success(let postDetail):
                print("✅ 게시글 상세 정보 로드 성공")
                
                // PostDetailItem을 Post로 변환
                let post = Post(
                    id: UUID().uuidString,
                    postingId: notification.postingId,
                    title: postDetail.postingTitle,
                    content: postDetail.postingContent,
                    images: [], // 이미지 URL을 UIImage로 변환하는 로직은 복잡하므로 빈 배열로 설정
                    authorId: String(postDetail.postingWriterId),
                    authorName: postDetail.postingWriterNickname ?? "익명",
                    isHidden: !postDetail.isPostingAccessible,
                    createdAt: self?.parseDate(from: postDetail.postingCreatedAt ?? "") ?? Date(),
                    commentCount: 0,
                    type: .found // Found 타입 알림이므로
                )
                
                let detailVC = PostDetailViewController(post: post)
                self?.navigationController?.pushViewController(detailVC, animated: true)
                
            case .failure(let error):
                print("❌ 게시글 상세 정보 로드 실패: \(error.localizedDescription)")
                
                // 에러 알림 표시
                let alert = UIAlertController(
                    title: "오류",
                    message: "게시글을 불러올 수 없습니다: \(error.localizedDescription)",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "확인", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func parseDate(from dateString: String) -> Date {
        // 빈 문자열이면 현재 날짜 반환
        guard !dateString.isEmpty else {
            return Date()
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        if let date = dateFormatter.date(from: dateString) {
            return date
        } else {
            // 다른 형식 시도
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            if let date = dateFormatter.date(from: dateString) {
                return date
            }
        }
        
        // 파싱 실패 시 현재 날짜 반환
        return Date()
    }
    
    @objc private func storageTapped() {
        print("🏠 하단 분실물 보관함 버튼 탭됨")
        print("🏠 현재 navigationController: \(navigationController != nil ? "존재함" : "nil")")
        let lostAndFoundVC = LostAndFoundViewController()
        navigationController?.pushViewController(lostAndFoundVC, animated: true)
        print("🏠 LostAndFoundViewController로 이동 완료")
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homePostingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let homePostingItem = homePostingItems[indexPath.row]
        
        // HomePostingItem을 Post로 변환
        let post = Post(
            id: String(homePostingItem.postingId),
            postingId: homePostingItem.postingId,
            title: homePostingItem.postingTitle,
            content: homePostingItem.postingContent,
            location: homePostingItem.itemPlace, // 위치 정보 추가
            images: [], // 이미지는 별도로 로드
            authorId: "익명", // HomePostingItem에는 작성자 정보가 없으므로 기본값 사용
            authorName: "익명",
            isHidden: false,
            createdAt: Date(), // HomePostingItem에는 날짜 정보가 없으므로 현재 날짜 사용
            commentCount: 0,
            type: selectedSegment == 0 ? .found : .lost
        )
        
        cell.configure(with: post)
        
        // 이미지 URL이 있으면 로드
        if !homePostingItem.postingImageUrl.isEmpty {
            loadImageFromURL(homePostingItem.postingImageUrl, for: cell)
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let homePostingItem = homePostingItems[indexPath.row]
        
        // HomePostingItem을 Post로 변환
        let post = Post(
            id: String(homePostingItem.postingId),
            postingId: homePostingItem.postingId,
            title: homePostingItem.postingTitle,
            content: homePostingItem.postingContent,
            images: [],
            authorId: "익명", // HomePostingItem에는 작성자 정보가 없으므로 기본값 사용
            authorName: "익명",
            isHidden: false,
            createdAt: Date(), // HomePostingItem에는 날짜 정보가 없으므로 현재 날짜 사용
            commentCount: 0,
            type: selectedSegment == 0 ? .found : .lost
        )
        
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? Date()
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

// MARK: - PostCellDelegate
extension HomeViewController: PostCellDelegate {
    func postCellDidTapJoopjoop(_ cell: PostCell, post: Post) {
        // HomePostingItem에서 postingId 찾기
        guard let homePostingItem = homePostingItems.first(where: { $0.postingTitle == post.title }) else {
            print("❌ 해당 게시글을 찾을 수 없습니다.")
            return
        }
        
        print("🎯 홈 화면 줍줍 버튼 클릭: postingId = \(homePostingItem.postingId)")
        
        // 로딩 상태 표시
        cell.joopjoopButton.setTitle("줍줍 중...", for: .normal)
        cell.joopjoopButton.isEnabled = false
        
        APIService.shared.markPostAsPickedUp(postingId: homePostingItem.postingId) { [weak self] result in
            DispatchQueue.main.async {
                // 버튼 상태 복원
                cell.joopjoopButton.setTitle("줍줍", for: .normal)
                cell.joopjoopButton.isEnabled = true
                
                switch result {
                case .success(let response):
                    print("✅ 홈 화면 줍줍 성공: \(response.message)")
                    
                    // 성공 알림
                    let alert = UIAlertController(title: "줍줍 완료", message: "해당 게시글이 줍줍되었습니다.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                    
                    // 게시글 목록 새로고침
                    self?.currentPage = 0
                    self?.loadPosts()
                    
                case .failure(let error):
                    print("❌ 홈 화면 줍줍 실패: \(error.localizedDescription)")
                    
                    // 실패 알림
                    let alert = UIAlertController(title: "줍줍 실패", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}


