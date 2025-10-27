//
//  NotificationListViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class NotificationListViewController: UIViewController {
    
    // MARK: - Custom Navigation Header
    private let customNavHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "알림"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("×", for: .normal)
        button.setTitleColor(.primaryTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 28, weight: .light)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .backgroundColor
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "알림이 없습니다"
        label.textColor = .secondaryTextColor
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var notificationItems: [NotificationItem] = []
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadNotifications()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add custom header
        view.addSubview(customNavHeader)
        customNavHeader.addSubview(titleLabel)
        customNavHeader.addSubview(closeButton)
        
        // Add table view and other elements
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(loadingIndicator)
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Custom header constraints
            customNavHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavHeader.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            
            closeButton.trailingAnchor.constraint(equalTo: customNavHeader.trailingAnchor, constant: -16),
            closeButton.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Table view constraints - start below custom header
            tableView.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func closeTapped() {
        print("❌ 알림창 닫기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
    }
    
    private func loadNotifications() {
        print("🔔 알림 목록 로드 시작")
        
        guard !isLoading else {
            print("⚠️ 이미 로딩 중입니다")
            return
        }
        
        isLoading = true
        loadingIndicator.startAnimating()
        tableView.isHidden = true
        emptyLabel.isHidden = true
        
        APIService.shared.getNotificationList { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.loadingIndicator.stopAnimating()
                self?.tableView.isHidden = false
                
                switch result {
                case .success(let notifications):
                    print("✅ 알림 목록 로드 성공: \(notifications.count)개")
                    self?.notificationItems = notifications
                    self?.emptyLabel.isHidden = !notifications.isEmpty
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print("❌ 알림 목록 로드 실패: \(error.localizedDescription)")
                    self?.notificationItems = []
                    self?.emptyLabel.isHidden = false
                    self?.emptyLabel.text = "알림을 불러올 수 없습니다"
                    self?.tableView.reloadData()
                    
                    // 에러 알림 표시
                    let alert = UIAlertController(
                        title: "오류",
                        message: "알림을 불러오는데 실패했습니다: \(error.localizedDescription)",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "확인", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let notification = notificationItems[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = notification.notificationContent
        config.secondaryText = formatDate(notification.notificationCreatedAt)
        config.textProperties.font = UIFont.systemFont(ofSize: 14)
        config.secondaryTextProperties.font = UIFont.systemFont(ofSize: 12)
        config.secondaryTextProperties.color = .secondaryTextColor
        
        // 알림 타입에 따른 아이콘 설정
        switch notification.notificationType {
        case "Comment":
            config.image = UIImage(systemName: "message.fill")
            config.imageProperties.tintColor = .systemBlue
        case "PickedUp":
            config.image = UIImage(systemName: "hand.raised.fill")
            config.imageProperties.tintColor = .systemGreen
        case "Found":
            config.image = UIImage(systemName: "checkmark.circle.fill")
            config.imageProperties.tintColor = .systemOrange
        default:
            config.image = UIImage(systemName: "bell.fill")
            config.imageProperties.tintColor = .systemGray
        }
        
        cell.contentConfiguration = config
        cell.backgroundColor = .backgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notificationItems[indexPath.row]
        
        print("🔔 알림 선택됨: postingId=\(notification.postingId)")
        
        // 게시글 상세 화면으로 이동
        // TODO: postingId를 사용하여 게시글 상세 정보를 가져와서 PostDetailViewController로 이동
        // 현재는 간단한 알림만 표시
        let alert = UIAlertController(
            title: "알림",
            message: "게시글 ID: \(notification.postingId)\n알림 타입: \(notification.notificationType)\n내용: \(notification.notificationContent)",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        if let date = dateFormatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MM/dd HH:mm"
            return displayFormatter.string(from: date)
        } else {
            return dateString
        }
    }
}

