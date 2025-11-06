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
        imageView.image = UIImage(named: "SplashIcon")
        imageView.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0) // #4267F6
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 손 안의 분실물 보관함"
        label.font = UIFont(name: "Pretendard Variable",size: 20)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 20) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 20)
        } else {
            label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        }
        label.textColor = UIColor.primaryColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍"
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 40) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 40)
        } else {
            label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        }
        label.textColor = UIColor.primaryColor // #4267F6
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        let radialView = RadialGradientView(frame: view.bounds)
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.insertSubview(radialView, at: 1)
        setupUI()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.navigateToAnimationScreen()
        }
    }
    
    
    private func setupUI() {
        view.addSubview(logoImageView)
        view.addSubview(subtitleLabel)
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 102),
            
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

class RadialGradientView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let colors = [UIColor(red: 233/255, green: 252/255, blue: 255/255, alpha: 1.0).cgColor,
                      UIColor(red: 221/255, green: 227/255, blue: 235/255, alpha: 1.0).cgColor
        ] as CFArray

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0, 1])!

        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2.5

        context.drawRadialGradient(
            gradient,
            startCenter: center,
            startRadius: 0,
            endCenter: center,
            endRadius: radius,
            options: .drawsAfterEndLocation
        )
    }
}
