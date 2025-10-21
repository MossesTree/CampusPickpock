//
//  MainTabBarController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class MainTabBarController: UINavigationController {
    
    private let homeVC = HomeViewController()
    private let searchVC = SearchViewController()
    private let myPageVC = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainView()
    }
    
    private func setupMainView() {
        // 홈 화면을 네비게이션 스택의 루트로 설정
        setViewControllers([homeVC], animated: false)
    }
    
    func navigateToSearch() {
        let navController = UINavigationController(rootViewController: searchVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func navigateToMyPage() {
        let navController = UINavigationController(rootViewController: myPageVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

