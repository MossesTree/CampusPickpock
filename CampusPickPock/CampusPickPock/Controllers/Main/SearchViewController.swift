//
//  SearchViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Custom Header
    private let customHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        // DefaultBackIcon을 48x48 크기로 설정, 원본 색상 유지
        if let backIcon = UIImage(named: "DefaultBackIcon") {
            let size = CGSize(width: 48, height: 48)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            backIcon.draw(in: CGRect(origin: .zero, size: size))
            let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            // 원본 색상을 유지하기 위해 renderingMode 설정
            button.setImage(resizedIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        // 색상 명시적으로 설정 (rgba(19, 45, 100, 1))
        button.tintColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red: 0xF5/255.0, green: 0xF5/255.0, blue: 0xF5/255.0, alpha: 1.0)
        textField.layer.cornerRadius = 10  // 더 각지게 둥글게 (20 -> 10)
        
        // 테두리 추가: rgba(199, 207, 225, 1) 색상의 1px 테두리
        textField.layer.borderWidth = 1.0 / UIScreen.main.scale
        textField.layer.borderColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 225/255.0, alpha: 1.0).cgColor
        
        // Pretendard Variable Medium 14px placeholder 설정
        let placeholderText = "잃어버린 물건을 검색해 보세요."
        let placeholderColor = UIColor(red: 143/255.0, green: 143/255.0, blue: 143/255.0, alpha: 1.0)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 14) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium]
            ])
            let font = UIFont(descriptor: fontDescriptor, size: 14)
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .font: font,
                    .foregroundColor: placeholderColor
                ]
            )
        } else {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 14, weight: .medium),
                    .foregroundColor: placeholderColor
                ]
            )
        }
        
        textField.font = UIFont(name: "Pretendard Variable", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.leftViewMode = .always
        textField.rightViewMode = .always
        textField.clearButtonMode = .never  // clearButton 대신 검색 아이콘 사용
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // 왼쪽 여백
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        textField.leftView = leftPaddingView
        
        // 오른쪽에 SearchIcon 추가
        if let searchIconImage = UIImage(named: "SearchIcon") {
            let searchIcon = UIImageView(image: searchIconImage)
            searchIcon.contentMode = .scaleAspectFit
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        
            let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
        iconContainer.addSubview(searchIcon)
        searchIcon.center = iconContainer.center
        
            textField.rightView = iconContainer
        }
        
        return textField
    }()
    
    // UISearchBar delegate를 유지하기 위한 속성
    private var searchBar: UISearchBar?
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["FOUND", "LOST"])
        control.selectedSegmentIndex = 0
        
        // 배경색 완전히 제거
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = .clear
        
        // Divider 이미지 제거 (세그먼트 사이 구분선 제거)
        control.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        // 선택된 상태: 4A80F0
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(red: 0x4A/255.0, green: 0x80/255.0, blue: 0xF0/255.0, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 17, weight: .medium)
        ], for: .selected)
        
        // 선택되지 않은 상태: 7A7A7A
        control.setTitleTextAttributes([
            .foregroundColor: UIColor(red: 0x7A/255.0, green: 0x7A/255.0, blue: 0x7A/255.0, alpha: 1.0),
            .font: UIFont.systemFont(ofSize: 17)
        ], for: .normal)
        
        // 배경 이미지 완전히 제거
        control.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        control.setBackgroundImage(UIImage(), for: .selected, barMetrics: .default)
        
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let headerDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .backgroundColor
        table.separatorStyle = .none
        return table
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색어를 입력해주세요"
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
    
    private var searchResults: [Post] = []
    private var postingItems: [PostingItem] = []
    private var currentSearchType = "ALL"
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add custom header with segmented control
        view.addSubview(customHeader)
        // 백버튼을 view에 직접 추가 (절대 위치 (10, 60))
        view.addSubview(backButton)
        // 검색창을 view에 직접 추가 (절대 위치 (55, 62))
        view.addSubview(searchTextField)
        customHeader.addSubview(segmentedControl)
        customHeader.addSubview(headerDividerLine)
        
        // Add table view and other elements
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(loadingIndicator)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            // Custom header constraints
            customHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customHeader.bottomAnchor.constraint(equalTo: headerDividerLine.bottomAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: customHeader.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customHeader.topAnchor, constant: 22),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            
            searchTextField.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 0),
            searchTextField.widthAnchor.constraint(equalToConstant: 296),
            searchTextField.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            segmentedControl.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 40),
            segmentedControl.leadingAnchor.constraint(equalTo: customHeader.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: customHeader.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32),
            
            headerDividerLine.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 0),
            headerDividerLine.leadingAnchor.constraint(equalTo: customHeader.leadingAnchor, constant: 0),
            headerDividerLine.trailingAnchor.constraint(equalTo: customHeader.trailingAnchor, constant: 0),
            headerDividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            tableView.topAnchor.constraint(equalTo: customHeader.bottomAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.isHidden = true
        emptyLabel.isHidden = false
    }
    
    @objc private func backTapped() {
        print("🔙 SearchViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostListCell.self, forCellReuseIdentifier: "PostListCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 400
    }
    
    @objc private func segmentChanged() {
        let searchText = searchTextField.text ?? ""
        if !searchText.isEmpty {
            performSearch(query: searchText)
        }
    }
    
    @objc private func textFieldDidChange() {
        let searchText = searchTextField.text ?? ""
        performSearch(query: searchText)
    }
    
    private func performSearch(query: String) {
        if query.isEmpty {
            searchResults = []
            postingItems = []
            tableView.isHidden = true
            emptyLabel.isHidden = false
            emptyLabel.text = "검색어를 입력해주세요"
            tableView.reloadData()
            return
        }
        
        // 검색 타입 결정
        let searchType: String
        switch segmentedControl.selectedSegmentIndex {
        case 0: searchType = "FOUND"
        case 1: searchType = "LOST"
        default: searchType = "FOUND"
        }
        
        currentSearchType = searchType
        
        // 로딩 상태 표시
        isLoading = true
        tableView.isHidden = false
        emptyLabel.isHidden = true
        loadingIndicator.startAnimating()
        
        print("🔍 검색 시작: keyword=\(query), type=\(searchType)")
        
        APIService.shared.searchPosts(type: searchType, keyword: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.loadingIndicator.stopAnimating()
                
                switch result {
                case .success(let searchResults):
                    print("✅ 검색 성공: \(searchResults.count)개 결과")
                    
                    self?.postingItems = searchResults
                    
                    // PostingItem을 Post로 변환
                    // 현재 선택된 검색 타입에 따라 post.type 설정
                    let currentSearchType = self?.currentSearchType ?? "FOUND"
                    self?.searchResults = searchResults.map { postingItem in
                        // 검색 타입을 기준으로 type 설정 (검색한 타입과 일치)
                        let postType: PostType = currentSearchType == "LOST" ? .lost : .found
                        
                        return Post(
                            id: String(postingItem.postingId),
                            postingId: postingItem.postingId,
                            title: postingItem.postingTitle,
                            content: postingItem.postingContent,
                            location: postingItem.itemPlace,
                            imageUrl: postingItem.postingImageUrl,
                            images: [],
                            authorId: postingItem.postingWriterNickName ?? "익명",
                            authorName: postingItem.postingWriterNickName ?? "익명",
                            isHidden: false,
                            createdAt: self?.parseDate(postingItem.postingCreatedAt) ?? Date(),
                            commentCount: postingItem.commentCount,
                            type: postType,
                            isPickedUp: postingItem.isPickedUp
                        )
                    }
                    
                    if self?.searchResults.isEmpty == true {
                        self?.emptyLabel.isHidden = false
                        self?.emptyLabel.text = "'\(query)'에 대한 검색 결과가 없습니다"
                    } else {
                        self?.emptyLabel.isHidden = true
                    }
                    
                    self?.tableView.reloadData()
                    
                case .failure(let error):
                    print("❌ 검색 실패: \(error.localizedDescription)")
                    
                    self?.searchResults = []
                    self?.postingItems = []
                    self?.emptyLabel.isHidden = false
                    self?.emptyLabel.text = "검색 중 오류가 발생했습니다"
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? Date()
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostListCell", for: indexPath) as! PostListCell
        let post = searchResults[indexPath.row]
        let isFirst = indexPath.row == 0
        cell.configure(with: post, isFirst: isFirst, isSearchMode: true)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = searchResults[indexPath.row]
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

