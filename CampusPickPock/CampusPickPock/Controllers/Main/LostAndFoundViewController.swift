//
//  LostAndFoundViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class LostAndFoundViewController: UIViewController {
    
    // MARK: - Custom Navigation Header
    private let customNavHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(red: 0x51/255.0, green: 0x5B/255.0, blue: 0x70/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        view.backgroundColor = .backgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "우리 학교 분실물 보관함"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "학교 분실물 보관함에 있는 물건을 손쉽게 찾아보세요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Category Filter Section
    private let categoryScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Items Grid Section
    private let itemsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Add Button
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("추가하기", for: .normal)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.1
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var items: [LostAndFoundItem] = []
    private var filteredItems: [LostAndFoundItem] = []
    private var storageItems: [StorageItem] = []
    private var filteredStorageItems: [StorageItem] = []
    private var selectedCategory = "전체"
    private var currentPage = 0
    private let pageSize = 20
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupCategoryButtons()
        loadItems()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add custom header
        view.addSubview(customNavHeader)
        customNavHeader.addSubview(backButton)
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        contentView.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        
        contentView.addSubview(itemsCollectionView)
        
        view.addSubview(addButton)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        setupConstraints()
        setupActions()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Custom navigation header
            customNavHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavHeader.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: customNavHeader.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            scrollView.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Header Section
            headerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            subtitleLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -20),
            
            // Category Section
            categoryScrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            categoryScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            categoryScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            categoryStackView.topAnchor.constraint(equalTo: categoryScrollView.topAnchor),
            categoryStackView.leadingAnchor.constraint(equalTo: categoryScrollView.leadingAnchor),
            categoryStackView.trailingAnchor.constraint(equalTo: categoryScrollView.trailingAnchor),
            categoryStackView.bottomAnchor.constraint(equalTo: categoryScrollView.bottomAnchor),
            categoryStackView.heightAnchor.constraint(equalTo: categoryScrollView.heightAnchor),
            
            // Items Collection View
            itemsCollectionView.topAnchor.constraint(equalTo: categoryScrollView.bottomAnchor, constant: 16),
            itemsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            itemsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            itemsCollectionView.heightAnchor.constraint(equalToConstant: 600),
            itemsCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            // Add Button
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addButton.widthAnchor.constraint(equalToConstant: 120),
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupActions() {
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupCollectionView() {
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.register(LostAndFoundItemCell.self, forCellWithReuseIdentifier: "LostAndFoundItemCell")
    }
    
    private func setupCategoryButtons() {
        let categories = ["전체", "전자제품", "지갑·카드", "의류·잡화", "학용품", "생활용품", "기타"]
        
        for (index, category) in categories.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 20
            button.translatesAutoresizingMaskIntoConstraints = false
            
            if index == 0 {
                // 첫 번째 버튼은 선택된 상태로 설정
                button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
            }
            
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            button.tag = index
            
            categoryStackView.addArrangedSubview(button)
            
            button.widthAnchor.constraint(equalToConstant: 80).isActive = true
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }
    }
    
    @objc private func backTapped() {
        print("🔙 LostAndFoundViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        // 모든 버튼을 기본 상태로 변경
        for subview in categoryStackView.arrangedSubviews {
            if let button = subview as? UIButton {
                button.backgroundColor = UIColor(red: 0xCE/255.0, green: 0xD6/255.0, blue: 0xE9/255.0, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0), for: .normal)
            }
        }
        
        // 선택된 버튼을 활성 상태로 변경
        sender.backgroundColor = UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
        
        // 카테고리 업데이트
        let categories = ["전체", "전자제품", "지갑·카드", "의류·잡화", "학용품", "생활용품", "기타"]
        selectedCategory = categories[sender.tag]
        
        filterItems()
    }
    
    private func filterItems() {
        if selectedCategory == "전체" {
            filteredItems = items
            filteredStorageItems = storageItems
        } else {
            // 카테고리 매핑
            let categoryMap: [String: [String]] = [
                "전자제품": ["전자제품"],
                "지갑·카드": ["지갑·카드", "지갑 및 카드"],
                "의류·잡화": ["의류·잡화", "의류 및 잡화"],
                "학용품": ["학용품"],
                "생활용품": ["생활용품"],
                "기타": []
            ]
            
            let mappedCategories = categoryMap[selectedCategory] ?? []
            
            if mappedCategories.isEmpty {
                // "기타" 카테고리인 경우, 매핑된 카테고리가 아닌 모든 항목을 표시
                let allMappedCategories = categoryMap.flatMap { $0.value }
                filteredStorageItems = storageItems.filter { item in
                    guard let category = item.postingCategory else { return true }
                    return !allMappedCategories.contains(category)
                }
            } else {
                filteredStorageItems = storageItems.filter { item in
                    guard let category = item.postingCategory else { return false }
                    return mappedCategories.contains(category)
                }
            }
            
            // storageItems를 기반으로 filteredItems 생성
            filteredItems = filteredStorageItems.map { storageItem in
                LostAndFoundItem(
                    id: String(storageItem.postingId),
                    name: storageItem.postingCategory ?? "분실물",
                    imageUrl: storageItem.postingImageUrl,
                    registrationDate: formatDate(storageItem.postingCreatedAt)
                )
            }
        }
        
        itemsCollectionView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        // Found 포스팅 작성 페이지로 이동
        print("분실물 추가 버튼 탭됨 - Found 포스팅 작성 페이지로 이동")
        let postCreateVC = PostCreateViewController()
        navigationController?.pushViewController(postCreateVC, animated: true)
    }
    
    private func loadItems() {
        print("🏠 분실물 보관함 데이터 로드 시작 - 페이지: \(currentPage), 페이지 크기: \(pageSize)")
        
        isLoading = true
        
        APIService.shared.getStorageList(page: currentPage, pageSize: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let storageItems):
                    print("✅ 분실물 보관함 데이터 로드 성공: \(storageItems.count)개 항목")
                    
                    if storageItems.isEmpty && self?.currentPage == 0 {
                        print("📭 분실물 보관함이 비어있습니다")
                        self?.showEmptyState()
                        return
                    }
                    
                    if self?.currentPage == 0 {
                        // 첫 페이지 로드 시 기존 데이터 교체
                        self?.storageItems = storageItems
                        self?.items = storageItems.map { storageItem in
                            LostAndFoundItem(
                                id: String(storageItem.postingId),
                                name: storageItem.postingCategory ?? "분실물",
                                imageUrl: storageItem.postingImageUrl,
                                registrationDate: self?.formatDate(storageItem.postingCreatedAt) ?? ""
                            )
                        }
                    } else {
                        // 추가 페이지 로드 시 데이터 추가
                        self?.storageItems.append(contentsOf: storageItems)
                        let newItems = storageItems.map { storageItem in
                            LostAndFoundItem(
                                id: String(storageItem.postingId),
                                name: storageItem.postingCategory ?? "분실물",
                                imageUrl: storageItem.postingImageUrl,
                                registrationDate: self?.formatDate(storageItem.postingCreatedAt) ?? ""
                            )
                        }
                        self?.items.append(contentsOf: newItems)
                    }
                    
                    self?.filterItems()
                    
                case .failure(let error):
                    print("❌ 분실물 보관함 데이터 로드 실패: \(error.localizedDescription)")
                    
                    // 오류 시 샘플 데이터 표시
                    self?.loadSampleData()
                }
            }
        }
    }
    
    private func loadSampleData() {
        // 샘플 데이터 로드 (API 실패 시)
        items = [
            LostAndFoundItem(id: "1", name: "물병", imageUrl: nil, registrationDate: "2024/01/15"),
            LostAndFoundItem(id: "2", name: "물병", imageUrl: nil, registrationDate: "2024/01/14"),
            LostAndFoundItem(id: "3", name: "물병", imageUrl: nil, registrationDate: "2024/01/13"),
            LostAndFoundItem(id: "4", name: "물병", imageUrl: nil, registrationDate: "2024/01/12"),
            LostAndFoundItem(id: "5", name: "물병", imageUrl: nil, registrationDate: "2024/01/11"),
            LostAndFoundItem(id: "6", name: "물병", imageUrl: nil, registrationDate: "2024/01/10")
        ]
        
        itemsCollectionView.reloadData()
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else { return dateString }
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy/MM/dd"
        return displayFormatter.string(from: date)
    }
    
    private func showEmptyState() {
        items = []
        itemsCollectionView.reloadData()
        
        // 빈 상태 메시지 표시
        let emptyLabel = UILabel()
        emptyLabel.text = "분실물 보관함이 비어있습니다"
        emptyLabel.textAlignment = .center
        emptyLabel.textColor = .secondaryTextColor
        emptyLabel.font = UIFont.systemFont(ofSize: 16)
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: itemsCollectionView.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: itemsCollectionView.centerYAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension LostAndFoundViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LostAndFoundItemCell", for: indexPath) as! LostAndFoundItemCell
        cell.configure(with: filteredItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let storageItem = filteredStorageItems[indexPath.item]
        print("분실물 아이템 선택됨: ID \(storageItem.postingId)")
        
        // PostDetailViewController로 이동
        let postDetailVC = PostDetailViewController(postingId: storageItem.postingId)
        navigationController?.pushViewController(postDetailVC, animated: true)
    }
    
    // MARK: - 페이지네이션
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // 스크롤이 끝에 가까워지면 다음 페이지 로드
        if offsetY > contentHeight - height - 100 {
            loadNextPage()
        }
    }
    
    private func loadNextPage() {
        // 이미 로딩 중이면 중복 요청 방지
        guard !isLoading else { return }
        
        currentPage += 1
        print("📄 다음 페이지 로드: \(currentPage)")
        loadItems()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension LostAndFoundViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 44) / 2 // 2열 그리드
        return CGSize(width: width, height: width + 80) // 이미지 + 텍스트 공간
    }
}

// MARK: - LostAndFoundItem Model
struct LostAndFoundItem {
    let id: String
    let name: String
    let imageUrl: String?
    let registrationDate: String
}

// MARK: - LostAndFoundItemCell
class LostAndFoundItemCell: UICollectionViewCell {
    
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
    
    private let itemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.8)
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let clockIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "clock")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "등록일 : 0000/00/00"
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(itemImageView)
        containerView.addSubview(dateOverlayView)
        
        dateOverlayView.addSubview(clockIconImageView)
        dateOverlayView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            itemImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            itemImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            itemImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            itemImageView.heightAnchor.constraint(equalTo: itemImageView.widthAnchor),
            
            dateOverlayView.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            dateOverlayView.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            dateOverlayView.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            dateOverlayView.heightAnchor.constraint(equalToConstant: 35),
            
            clockIconImageView.leadingAnchor.constraint(equalTo: dateOverlayView.leadingAnchor, constant: 8),
            clockIconImageView.centerYAnchor.constraint(equalTo: dateOverlayView.centerYAnchor),
            clockIconImageView.widthAnchor.constraint(equalToConstant: 12),
            clockIconImageView.heightAnchor.constraint(equalToConstant: 12),
            
            dateLabel.leadingAnchor.constraint(equalTo: clockIconImageView.trailingAnchor, constant: 4),
            dateLabel.centerYAnchor.constraint(equalTo: dateOverlayView.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: dateOverlayView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with item: LostAndFoundItem) {
        // URL로부터 이미지 로드
        if let imageUrl = item.imageUrl, !imageUrl.isEmpty, let url = URL(string: imageUrl) {
            itemImageView.image = nil // 기본 이미지 초기화
            
            // 비동기적으로 이미지 로드
            URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                DispatchQueue.main.async {
                    if let data = data, let image = UIImage(data: data) {
                        self?.itemImageView.image = image
                    } else {
                        // 이미지 로드 실패 시 플레이스홀더 표시
                        self?.itemImageView.image = UIImage(systemName: "photo")
                        self?.itemImageView.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
                    }
                }
            }.resume()
        } else {
            // 이미지 URL이 없는 경우 플레이스홀더 표시
            itemImageView.image = UIImage(systemName: "photo")
            itemImageView.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        }
        
        // UTC 시간을 한국 시간으로 변환
        let koreanDateString = convertToKoreanTime(item.registrationDate)
        dateLabel.text = "등록일 : \(koreanDateString)"
    }
    
    private func convertToKoreanTime(_ dateString: String) -> String {
        var date: Date?
        
        // ISO8601DateFormatter 시도 (fractional seconds 포함)
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let parsedDate = iso8601Formatter.date(from: dateString) {
            date = parsedDate
        } else {
            // DateFormatter들로 시도
            let dateFormatters: [DateFormatter] = [
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
                    f.timeZone = TimeZone(abbreviation: "UTC")
                    return f
                }(),
                {
                    let f = DateFormatter()
                    f.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
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
            
            for formatter in dateFormatters {
                if let parsedDate = formatter.date(from: dateString) {
                    date = parsedDate
                    break
                }
            }
        }
        
        guard let date = date else {
            return dateString // 파싱 실패 시 원본 반환
        }
        
        // 한국 시간으로 변환
        let koreanTimeZone = TimeZone(identifier: "Asia/Seoul") ?? TimeZone.current
        let formatter = DateFormatter()
        formatter.timeZone = koreanTimeZone
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        return formatter.string(from: date)
    }
}
