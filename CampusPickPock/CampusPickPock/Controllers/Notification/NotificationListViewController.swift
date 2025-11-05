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
        label.font = UIFont(name: "Pretendard Variable", size: 20) ?? UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        // DefaultCloseIcon을 27x27 크기로 설정
        if let closeIcon = UIImage(named: "DefaultCloseIcon") {
            let size = CGSize(width: 27, height: 27)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            closeIcon.draw(in: CGRect(origin: .zero, size: size))
            let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            button.setImage(resizedIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let navDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .backgroundColor
        return table
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
        imageView.image = UIImage(named: "UnhappyIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let emptyMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "아직 받은 알림이 없어요"
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 20) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 20)
        } else {
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        label.textColor = UIColor(red: 172/255.0, green: 190/255.0, blue: 226/255.0, alpha: 1.0)
        label.textAlignment = .center
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
        view.addSubview(navDividerLine)
        
        // Add table view and other elements
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
        view.addSubview(loadingIndicator)
        
        emptyStateView.addSubview(emptyIconImageView)
        emptyStateView.addSubview(emptyMessageLabel)
        
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Custom header constraints
            customNavHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavHeader.heightAnchor.constraint(equalToConstant: 44),
            
            titleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            
            // X 버튼 위치 (323, 70)
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 323),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            closeButton.widthAnchor.constraint(equalToConstant: 27),
            closeButton.heightAnchor.constraint(equalToConstant: 27),
            
            navDividerLine.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor),
            navDividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navDividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navDividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            // Table view constraints - start below custom header
            // 셀의 오른쪽 끝이 X 버튼의 오른쪽 끝(350)에 맞춰지도록 trailingAnchor 조정
            tableView.topAnchor.constraint(equalTo: navDividerLine.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: 350),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Empty State View
            emptyStateView.topAnchor.constraint(equalTo: navDividerLine.bottomAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyIconImageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyIconImageView.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor, constant: -20),
            emptyIconImageView.widthAnchor.constraint(equalToConstant: 38),
            emptyIconImageView.heightAnchor.constraint(equalToConstant: 38),
            
            emptyMessageLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyMessageLabel.topAnchor.constraint(equalTo: emptyIconImageView.bottomAnchor, constant: 16),
            
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
        tableView.separatorStyle = .none // 셀 하단 라인 제거
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
        emptyStateView.isHidden = true
        
        APIService.shared.getNotificationList { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.loadingIndicator.stopAnimating()
                
                switch result {
                case .success(let notifications):
                    print("✅ 알림 목록 로드 성공: \(notifications.count)개")
                    self?.notificationItems = notifications
                    // 알림이 있으면 tableView 표시, 없으면 emptyStateView 표시
                    self?.tableView.isHidden = notifications.isEmpty
                    self?.emptyStateView.isHidden = !notifications.isEmpty
                    print("📊 tableView.isHidden=\(self?.tableView.isHidden ?? true), emptyStateView.isHidden=\(self?.emptyStateView.isHidden ?? true)")
                    print("📊 tableView.frame=\(self?.tableView.frame ?? .zero)")
                    self?.tableView.reloadData()
                    print("🔄 tableView.reloadData() 완료")
                    
                case .failure(let error):
                    print("❌ 알림 목록 로드 실패: \(error.localizedDescription)")
                    self?.notificationItems = []
                    self?.tableView.isHidden = true
                    self?.emptyStateView.isHidden = false
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
        
        print("📱 셀 구성 시작: row=\(indexPath.row), 총 알림=\(notificationItems.count)")
        
        // 셀 선택 스타일 제거
        cell.selectionStyle = .none
        
        // 기존 서브뷰 및 제약 조건 제거
        cell.contentView.subviews.forEach { $0.removeFromSuperview() }
        cell.contentView.constraints.forEach { $0.isActive = false }
        cell.backgroundView = nil
        cell.backgroundColor = .backgroundColor
        
        // 흰색 컨테이너 배경 설정
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10  // 더 각지게 (15 -> 10)
        // 테두리 추가: rgba(221, 221, 221, 1) 색상의 1px 테두리
        containerView.layer.borderWidth = 1.0 / UIScreen.main.scale
        containerView.layer.borderColor = UIColor(red: 221/255.0, green: 221/255.0, blue: 221/255.0, alpha: 1.0).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // 아이콘 이미지뷰
        let iconImageView = UIImageView()
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 알림 타입에 따른 아이콘 설정
        switch notification.notificationType {
        case "Comment":
            iconImageView.image = UIImage(named: "CommentIcon1")
        case "Found", "pickedUp", "PickedUp":
            iconImageView.image = UIImage(named: "StarIcon2")
        default:
            iconImageView.image = UIImage(systemName: "bell.fill")
            iconImageView.tintColor = .systemGray
        }
        
        // 제목 레이블 - Pretendard Variable 15px semibold rgba(78, 78, 78, 1)
        let titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 본문 레이블 - Pretendard Variable 13px medium rgba(123, 123, 123, 1)
        let contentLabel = UILabel()
        contentLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        contentLabel.textColor = UIColor(red: 123/255.0, green: 123/255.0, blue: 123/255.0, alpha: 1.0)
        contentLabel.numberOfLines = 0
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 시간 레이블 (우측 상단) - Pretendard Variable 10px medium rgba(123, 123, 123, 1)
        let timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        timeLabel.textColor = UIColor(red: 123/255.0, green: 123/255.0, blue: 123/255.0, alpha: 1.0)
        timeLabel.textAlignment = .right
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 알림 타입에 따른 제목, 본문 설정
        switch notification.notificationType {
        case "Comment":
            titleLabel.text = "내 게시물에 댓글이 달렸어요"
            contentLabel.text = formatNotificationContent(notification.notificationContent)
        case "Found", "pickedUp", "PickedUp":
            titleLabel.text = "줍줍 알림 도착 !"
            contentLabel.text = formatNotificationContent(notification.notificationContent)
        default:
            titleLabel.text = notification.notificationContent
            contentLabel.text = ""
        }
        
        // 시간 표시 (상대 시간)
        timeLabel.text = formatRelativeTime(notification.notificationCreatedAt)
        
        // 서브뷰 추가
        containerView.addSubview(iconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(contentLabel)
        containerView.addSubview(timeLabel)
        cell.contentView.addSubview(containerView)
        
        // 셀 높이 계산 (셀 간 간격 8픽셀: 하단 여백 4 + 상단 여백 4 = 8)
        let topMargin: CGFloat = indexPath.row == 0 ? 31 : 4
        let bottomMargin: CGFloat = 4
        
        var constraints: [NSLayoutConstraint] = [
            // 컨테이너 뷰 (오른쪽 끝이 X 버튼의 오른쪽 끝에 맞춰지도록 정렬)
            containerView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 325),
            containerView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: topMargin),
            containerView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -bottomMargin),
            
            // 아이콘 (상, 하, 좌로 15씩 여백, 크기 40x40)
            iconImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 15),
            iconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            iconImageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -15),
            iconImageView.widthAnchor.constraint(equalToConstant: 40),
            iconImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // 제목 레이블 (아이콘 오른쪽, 시간 레이블 왼쪽)
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: -8),
            
            // 시간 레이블 (우측 상단)
            timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            
            // 본문 레이블
            contentLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 15),
            contentLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            contentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -15),
            contentLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(constraints)
        
        print("✅ 셀 구성 완료: row=\(indexPath.row), topMargin=\(topMargin), bottomMargin=\(bottomMargin)")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 각 셀의 높이는 컨테이너 높이(70) + 여백
        // 셀 간 간격 8픽셀: 하단 여백 4 + 상단 여백 4 = 8
        // 첫 번째 셀: 상단 여백 31 + 컨테이너 높이 70 + 하단 여백 4 = 105
        // 나머지 셀: 상단 여백 4 + 컨테이너 높이 70 + 하단 여백 4 = 78
        if indexPath.row == 0 {
            return 31 + 70 + 4
        } else {
            return 4 + 70 + 4
        }
    }
    
    private func formatNotificationContent(_ content: String) -> String {
        // notificationContent에서 게시글 제목 부분 추출
        // "게시글 제목: "으로 시작하는 경우 해당 부분만 사용
        if content.contains("게시글 제목:") {
            let components = content.components(separatedBy: "게시글 제목:")
            if components.count > 1 {
                let titlePart = components[1].trimmingCharacters(in: .whitespacesAndNewlines)
                // 일부분만 표시 (너무 길면 생략)
                let maxLength = 30
                if titlePart.count > maxLength {
                    return "게시글 제목: \(String(titlePart.prefix(maxLength)))..."
                }
                return "게시글 제목: \(titlePart)"
            }
        }
        // "게시글 제목:"이 없는 경우 전체 내용 사용 (일부분만)
        let maxLength = 30
        if content.count > maxLength {
            return "게시글 제목: \(String(content.prefix(maxLength)))..."
        }
        return "게시글 제목: \(content)"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let notification = notificationItems[indexPath.row]
        
        print("🔔 알림 선택됨: postingId=\(notification.postingId)")
        
        // 게시글 상세 화면으로 이동
        let detailVC = PostDetailViewController(postingId: notification.postingId)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func formatRelativeTime(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // UTC 시간으로 파싱
        
        guard let notificationDate = dateFormatter.date(from: dateString) else {
            print("⚠️ 날짜 파싱 실패: \(dateString)")
            return dateString
        }
        
        // 현재 시간 가져오기 (절대 시간, UTC 기준)
        let now = Date()
        
        // Date 객체는 절대 시간이므로, 두 Date의 차이를 직접 계산하면 정확한 시간 간격을 얻을 수 있음
        // 하지만 사용자 요구사항대로 한국 시간 기준으로 계산하기 위해
        // 한국 시간대의 현재 시간과 알림 시간을 비교
        
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone(secondsFromGMT: 9 * 3600)!
        
        // 한국 시간대의 오프셋 계산 (UTC에서 한국 시간으로)
        let utcOffset = koreanTimeZone.secondsFromGMT(for: now)
        
        // 한국 시간 기준으로 현재 시간과 알림 시간 계산
        // Date는 절대 시간이므로 직접 비교 가능
        // 하지만 로컬 시간대에 관계없이 한국 시간 기준으로 계산하려면:
        // 현재 기기의 시간대 오프셋과 한국 시간대 오프셋의 차이를 고려
        
        // 기기의 현재 시간대 오프셋
        let localOffset = TimeZone.current.secondsFromGMT(for: now)
        
        // 한국 시간 기준으로 조정된 시간 차이
        // 실제로는 Date 객체가 절대 시간이므로 직접 계산이 가장 정확
        let timeInterval = now.timeIntervalSince(notificationDate)
        
        print("🔍 시간 계산: UTC 원본=\(dateString), 알림 시간=\(notificationDate), 현재 시간=\(now), 간격=\(timeInterval)초 (\(timeInterval/60)분)")
        
        return formatTimeInterval(timeInterval)
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        // 미래 시간인 경우 (음수)
        if timeInterval < 0 {
            return "방금 전"
        }
        
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

