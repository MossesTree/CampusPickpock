//
//  NotificationListViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class NotificationListViewController: UIViewController {
    
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
    
    private var notifications: [AppNotification] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        loadNotifications()
    }
    
    private func setupUI() {
        title = "알림"
        view.backgroundColor = .backgroundColor
        
        setupCustomBackButton()
        
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
        print("🔙 NotificationListViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NotificationCell")
    }
    
    private func loadNotifications() {
        notifications = NotificationManager.shared.getNotifications()
        emptyLabel.isHidden = !notifications.isEmpty
        tableView.reloadData()
    }
}

extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath)
        let notification = notifications[indexPath.row]
        
        var config = cell.defaultContentConfiguration()
        config.text = notification.message
        config.secondaryText = formatDate(notification.createdAt)
        config.textProperties.font = UIFont.systemFont(ofSize: 14)
        config.secondaryTextProperties.font = UIFont.systemFont(ofSize: 12)
        config.secondaryTextProperties.color = .secondaryTextColor
        
        cell.contentConfiguration = config
        cell.backgroundColor = notification.isRead ? .backgroundColor : .secondaryBackgroundColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notifications[indexPath.row]
        
        NotificationManager.shared.markAsRead(notificationId: notification.id)
        
        if let postId = notification.postId,
           let post = DataManager.shared.getPost(by: postId) {
            let detailVC = PostDetailViewController(post: post)
            navigationController?.pushViewController(detailVC, animated: true)
        }
        
        loadNotifications()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

