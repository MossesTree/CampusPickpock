//
//  LostAndFoundViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class LostAndFoundViewController: UIViewController {
    
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
    private var storageItems: [StorageItem] = []
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
        view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.99, alpha: 1.0)
        
        setupCustomBackButton()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(headerView)
        headerView.addSubview(titleLabel)
        headerView.addSubview(subtitleLabel)
        
        contentView.addSubview(categoryScrollView)
        categoryScrollView.addSubview(categoryStackView)
        
        contentView.addSubview(itemsCollectionView)
        
        view.addSubview(addButton)
        
        setupConstraints()
        setupActions()
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
        let categories = ["전체", "전자 제품", "카드/지갑", "기타"]
        
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
                button.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
                button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
            }
        }
        
        // 선택된 버튼을 활성 상태로 변경
        sender.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
        
        // 카테고리 업데이트
        let categories = ["전체", "전자 제품", "카드/지갑", "기타"]
        selectedCategory = categories[sender.tag]
        
        // 페이지 초기화 후 데이터 로드
        currentPage = 0
        loadItems()
    }
    
    @objc private func addButtonTapped() {
        // 분실물 추가 기능 (필요시 구현)
        print("분실물 추가 버튼 탭됨")
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
                                image: UIImage(systemName: "photo"),
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
                                image: UIImage(systemName: "photo"),
                                registrationDate: self?.formatDate(storageItem.postingCreatedAt) ?? ""
                            )
                        }
                        self?.items.append(contentsOf: newItems)
                    }
                    
                    self?.itemsCollectionView.reloadData()
                    
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
            LostAndFoundItem(id: "1", name: "물병", image: UIImage(systemName: "waterbottle"), registrationDate: "2024/01/15"),
            LostAndFoundItem(id: "2", name: "물병", image: UIImage(systemName: "waterbottle"), registrationDate: "2024/01/14"),
            LostAndFoundItem(id: "3", name: "물병", image: UIImage(systemName: "waterbottle"), registrationDate: "2024/01/13"),
            LostAndFoundItem(id: "4", name: "물병", image: UIImage(systemName: "waterbottle"), registrationDate: "2024/01/12"),
            LostAndFoundItem(id: "5", name: "물병", image: UIImage(systemName: "waterbottle"), registrationDate: "2024/01/11"),
            LostAndFoundItem(id: "6", name: "물병", image: UIImage(systemName: "waterbottle"), registrationDate: "2024/01/10")
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
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LostAndFoundItemCell", for: indexPath) as! LostAndFoundItemCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let storageItem = storageItems[indexPath.item]
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
        return CGSize(width: width, height: width + 60) // 이미지 + 텍스트 공간
    }
}

// MARK: - LostAndFoundItem Model
struct LostAndFoundItem {
    let id: String
    let name: String
    let image: UIImage?
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
    
    private let removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        button.tintColor = .white
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
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
        containerView.addSubview(removeButton)
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
            
            removeButton.topAnchor.constraint(equalTo: itemImageView.topAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: -8),
            removeButton.widthAnchor.constraint(equalToConstant: 24),
            removeButton.heightAnchor.constraint(equalToConstant: 24),
            
            dateOverlayView.leadingAnchor.constraint(equalTo: itemImageView.leadingAnchor),
            dateOverlayView.trailingAnchor.constraint(equalTo: itemImageView.trailingAnchor),
            dateOverlayView.bottomAnchor.constraint(equalTo: itemImageView.bottomAnchor),
            dateOverlayView.heightAnchor.constraint(equalToConstant: 30),
            
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
        itemImageView.image = item.image
        itemImageView.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        dateLabel.text = "등록일 : \(item.registrationDate)"
    }
}
