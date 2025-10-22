//
//  SearchViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "분실물 검색..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["전체", "분실물", "습득물"])
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
        title = "검색"
        view.backgroundColor = .backgroundColor
        
        setupCustomBackButton()
        
        view.addSubview(searchBar)
        view.addSubview(segmentedControl)
        view.addSubview(tableView)
        view.addSubview(emptyLabel)
        view.addSubview(loadingIndicator)
        
        searchBar.delegate = self
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            segmentedControl.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 16),
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
    
    private func setupCustomBackButton() {
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        backButton.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
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
        let searchText = searchBar.text ?? ""
        if !searchText.isEmpty {
            performSearch(query: searchText)
        }
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
        
        // 검색 타입 결정 - ALL일 때는 두 번의 API 호출
        let searchType: String
        switch segmentedControl.selectedSegmentIndex {
        case 0: 
            // 전체 검색 - LOST와 FOUND를 각각 검색
            performCombinedSearch(query: query)
            return
        case 1: searchType = "LOST"
        case 2: searchType = "FOUND"
        default: searchType = "LOST"
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
    
    private func performCombinedSearch(query: String) {
        // 로딩 상태 표시
        isLoading = true
        tableView.isHidden = false
        emptyLabel.isHidden = true
        loadingIndicator.startAnimating()
        
        print("🔍 전체 검색 시작: keyword=\(query)")
        
        let group = DispatchGroup()
        var lostResults: [PostingItem] = []
        var foundResults: [PostingItem] = []
        var searchError: APIError?
        
        // LOST 검색
        group.enter()
        APIService.shared.searchPosts(type: "LOST", keyword: query) { result in
            switch result {
            case .success(let results):
                lostResults = results
                print("✅ LOST 검색 성공: \(results.count)개 결과")
            case .failure(let error):
                print("❌ LOST 검색 실패: \(error.localizedDescription)")
                searchError = error
            }
            group.leave()
        }
        
        // FOUND 검색
        group.enter()
        APIService.shared.searchPosts(type: "FOUND", keyword: query) { result in
            switch result {
            case .success(let results):
                foundResults = results
                print("✅ FOUND 검색 성공: \(results.count)개 결과")
            case .failure(let error):
                print("❌ FOUND 검색 실패: \(error.localizedDescription)")
                searchError = error
            }
            group.leave()
        }
        
        // 모든 검색 완료 후 결과 처리
        group.notify(queue: .main) { [weak self] in
            self?.isLoading = false
            self?.loadingIndicator.stopAnimating()
            
            if let error = searchError {
                print("❌ 검색 실패: \(error.localizedDescription)")
                self?.searchResults = []
                self?.postingItems = []
                self?.emptyLabel.isHidden = false
                self?.emptyLabel.text = "검색 중 오류가 발생했습니다"
                self?.tableView.reloadData()
                return
            }
            
            // 결과 합치기
            let combinedResults = lostResults + foundResults
            print("✅ 전체 검색 완료: 총 \(combinedResults.count)개 결과 (LOST: \(lostResults.count), FOUND: \(foundResults.count))")
            
            self?.postingItems = combinedResults
            
            // PostingItem을 Post로 변환
            self?.searchResults = combinedResults.map { postingItem in
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
        }
    }
    
    private func parseDate(_ dateString: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: dateString) ?? Date()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(query: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
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

