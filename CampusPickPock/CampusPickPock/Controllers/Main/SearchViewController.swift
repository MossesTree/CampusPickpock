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
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(red: 0x51/255.0, green: 0x5B/255.0, blue: 0x70/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "잃어버린 물건을 검색해 보세요."
        textField.backgroundColor = UIColor(red: 0xF5/255.0, green: 0xF5/255.0, blue: 0xF5/255.0, alpha: 1.0)
        textField.layer.cornerRadius = 20
        textField.font = UIFont.systemFont(ofSize: 15)
        textField.leftViewMode = .always
        textField.clearButtonMode = .whileEditing
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        // 왼쪽에 돋보기 아이콘 추가
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        searchIcon.tintColor = .gray
        searchIcon.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        searchIcon.contentMode = .scaleAspectFit
        
        let iconContainer = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        iconContainer.addSubview(searchIcon)
        searchIcon.center = iconContainer.center
        
        textField.leftView = iconContainer
        
        // 텍스트 왼쪽 여백
        textField.leftViewMode = .always
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 20))
        textField.leftView?.addSubview(leftPaddingView)
        
        return textField
    }()
    
    // UISearchBar delegate를 유지하기 위한 속성
    private var searchBar: UISearchBar?
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["FOUND", "LOST"])
        control.selectedSegmentIndex = 0
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .backgroundColor
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
        
        // Add custom header with back button and search text field
        view.addSubview(customHeader)
        customHeader.addSubview(backButton)
        customHeader.addSubview(searchTextField)
        
        // Add segmented control, table view and other elements
        view.addSubview(segmentedControl)
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
            customHeader.heightAnchor.constraint(equalToConstant: 60),
            
            backButton.leadingAnchor.constraint(equalTo: customHeader.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customHeader.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            searchTextField.leadingAnchor.constraint(equalTo: backButton.trailingAnchor, constant: 8),
            searchTextField.trailingAnchor.constraint(equalTo: customHeader.trailingAnchor, constant: -16),
            searchTextField.centerYAnchor.constraint(equalTo: customHeader.centerYAnchor),
            searchTextField.heightAnchor.constraint(equalToConstant: 40),
            
            segmentedControl.topAnchor.constraint(equalTo: customHeader.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
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
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
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
                    self?.searchResults = searchResults.map { postingItem in
                        Post(
                            id: String(postingItem.postingId),
                            postingId: postingItem.postingId,
                            title: postingItem.postingTitle,
                            content: postingItem.postingContent,
                            images: [],
                            authorId: postingItem.postingWriterNickName ?? "익명",
                            authorName: postingItem.postingWriterNickName ?? "익명",
                            isHidden: false,
                            createdAt: self?.parseDate(postingItem.postingCreatedAt) ?? Date(),
                            commentCount: postingItem.commentCount,
                            type: postingItem.postingCategory == "LOST" ? .lost : .found
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        cell.configure(with: searchResults[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let post = searchResults[indexPath.row]
        let detailVC = PostDetailViewController(post: post)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

