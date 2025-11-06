//
//  OnboardingViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    
    private let skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("건너뛰기", for: .normal)
        button.setTitleColor(.secondaryTextColor, for: .normal)
        button.titleLabel?.font = UIFont.pretendardSemibold(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음으로", for: .normal)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendardSemibold(size: 18)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("다음으로", for: .normal)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendardSemibold(size: 18)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let onboardingPages = [
        OnboardingPage(
            subtitle: "어? 내 물건 어디갔지 ?\n이란 질문 한번쯤 하신 기억이\n있지 않으신가요?",
            imageName: "SplashIcon"
        ),
        OnboardingPage(
            subtitle: "학교 안 잃어버린 모든 물건들,\n이젠 캠퍼스 줍줍에서 찾아보세요",
            imageName: "SplashIcon"
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupOnboardingPages()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(scrollView)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        view.addSubview(startButton)
        
        startButton.isHidden = true
        
        NSLayoutConstraint.activate([
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.heightAnchor.constraint(equalToConstant: 50),
            
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            scrollView.topAnchor.constraint(equalTo: skipButton.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),
            nextButton.widthAnchor.constraint(equalToConstant: 340),
            nextButton.heightAnchor.constraint(equalToConstant: 65),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),
            startButton.widthAnchor.constraint(equalToConstant: 340),
            startButton.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    private func setupOnboardingPages() {
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(onboardingPages.count), height: scrollView.bounds.height)
        
        for (index, page) in onboardingPages.enumerated() {
            let pageView = createPageView(for: page)
            
            pageView.frame = CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(pageView)
            
        }
    }
    
    private func createPageView(for page: OnboardingPage) -> UIView {
        let containerView = UIView()
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "\(page.imageName)")
        imageView.tintColor = .primaryColor
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = page.subtitle
        subtitleLabel.font = UIFont.pretendardSemibold(size: 16)
        subtitleLabel.textColor = .primaryColor
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(imageView)
        containerView.addSubview(subtitleLabel)
        
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: 200),
            //            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            subtitleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
        
        return containerView
    }
    
    private func setupActions() {
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
        
        scrollView.delegate = self
    }
    
    @objc private func skipTapped() {
        navigateToLogin()
    }
    
    @objc private func nextTapped() {
        let currentPage = Int(scrollView.contentOffset.x / view.bounds.width)
        if currentPage < onboardingPages.count - 1 {
            let nextPage = currentPage + 1
            scrollView.setContentOffset(CGPoint(x: view.bounds.width * CGFloat(nextPage), y: 0), animated: true)
        }
    }
    
    @objc private func startTapped() {
        navigateToLogin()
    }
    
    private func navigateToLogin() {
        let loginVC = LoginViewController()
        let navController = UINavigationController(rootViewController: loginVC)
        navController.modalPresentationStyle = .fullScreen
        navController.modalTransitionStyle = .crossDissolve
        present(navController, animated: true)
    }
}

extension OnboardingViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.bounds.width)
        //        pageControl.currentPage = Int(pageIndex)
        
        let isLastPage = Int(pageIndex) == onboardingPages.count - 1
        nextButton.isHidden = isLastPage
        startButton.isHidden = !isLastPage
    }
}

struct OnboardingPage {
    let subtitle: String
    let imageName: String
}

