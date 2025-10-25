//
//  SplashViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "hand.raised.fill")
        imageView.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0) // #4267F6
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 손 안의 분실물 보관함"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor(red: 0.42, green: 0.55, blue: 0.99, alpha: 1.0) // #6A8CFE
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0) // #4267F6
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.navigateToAnimationScreen()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(logoImageView)
        view.addSubview(subtitleLabel)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            
            subtitleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 20),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func navigateToAnimationScreen() {
        let animationVC = SplashAnimationViewController()
        animationVC.modalPresentationStyle = .fullScreen
        animationVC.modalTransitionStyle = .crossDissolve
        present(animationVC, animated: true)
    }
    
    private func navigateToOnboarding() {
        let onboardingVC = OnboardingViewController()
        onboardingVC.modalPresentationStyle = .fullScreen
        onboardingVC.modalTransitionStyle = .crossDissolve
        present(onboardingVC, animated: true)
    }
    
    private func navigateToMainScreen() {
        let mainTabBar = MainTabBarController()
        mainTabBar.modalPresentationStyle = .fullScreen
        mainTabBar.modalTransitionStyle = .crossDissolve
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBar
            window.makeKeyAndVisible()
        }
    }
}

