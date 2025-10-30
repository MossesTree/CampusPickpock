//
//  SplashAnimationViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class SplashAnimationViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "캠퍼스 줍줍에서 발견하세요"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .primaryTextColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let cardContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var postCards: [PostCardView] = []
    
    private var splashPostings: [SplashPosting] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSplashPostings()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(cardContainerView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardContainerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            cardContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            cardContainerView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
//        createPostCards()
    }
    
    private func loadSplashPostings() {
        print("🌐 스플래시 게시글 로드 시작")
        
        APIService.shared.getSplashPostings { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let postings):
                    print("✅ 스플래시 게시글 로드 성공: \(postings.count)개")
                    self?.splashPostings = postings
                    self?.createPostCardsFromAPI()
                    self?.startAnimation()
                case .failure(let error):
                    print("❌ 스플래시 게시글 로드 실패: \(error.localizedDescription)")
                    // API 실패 시 기본 데이터로 폴백
                    self?.createPostCards()
                    self?.startAnimation()
                }
            }
        }
    }
    
    private func createPostCardsFromAPI() {
        // API에서 받은 데이터로 카드 생성 (최대 3개)
        let maxCards = min(splashPostings.count, 3)
        
        for index in 0..<maxCards {
            let posting = splashPostings[index]
            let cardView = PostCardView()
            
            // API 데이터를 PostCardData로 변환
            let postData = PostCardData(
                username: posting.postingWriterNickname,
                primaryMessage: posting.postingTitle,
                secondaryMessage: posting.postingContent,
                detailMessage: posting.postingContent.count > 50 ? String(posting.postingContent.prefix(50)) + "..." : posting.postingContent
            )
            
            cardView.configure(with: postData)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.alpha = 0
            cardView.transform = CGAffineTransform(translationX: 0, y: 50)
            
            cardContainerView.addSubview(cardView)
            postCards.append(cardView)
            
            NSLayoutConstraint.activate([
                cardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
                cardView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
                cardView.heightAnchor.constraint(equalToConstant: 120),
                cardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: CGFloat(index * 130))
            ])
        }
    }
    
    private func createPostCards() {
        let posts = [
            PostCardData(
                username: "에어팟찾아삼만리",
                primaryMessage: "에어팟 왼쪽 찾아요 ㅠㅠ!",
                secondaryMessage: "에어팟 왼쪽 찾으신 분 계신가요 ㅠㅠㅠㅠ!",
                detailMessage: "어제 학관 앞에서 10시쯤 잃어버렸습니다 ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ"
            ),
            PostCardData(
                username: "에어팟찾아삼만리",
                primaryMessage: "에어팟 왼쪽 찾아요 ㅠㅠ!",
                secondaryMessage: "에어팟 왼쪽 찾으신 분 계신가요 ㅠㅠㅠㅠ!",
                detailMessage: "어제 학관 앞에서 10시쯤 잃어버렸습니다 ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ"
            ),
            PostCardData(
                username: "에어팟찾아삼만리",
                primaryMessage: "에어팟 왼쪽 찾아요 ㅠㅠ!",
                secondaryMessage: "에어팟 왼쪽 찾으신 분 계신가요 ㅠㅠㅠㅠ!",
                detailMessage: "어제 학관 앞에서 10시쯤 잃어버렸습니다 ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ"
            )
        ]
        
        for (index, postData) in posts.enumerated() {
            let cardView = PostCardView()
            cardView.configure(with: postData)
            cardView.translatesAutoresizingMaskIntoConstraints = false
            cardView.alpha = 0
            cardView.transform = CGAffineTransform(translationX: 0, y: 50)
            
            cardContainerView.addSubview(cardView)
            postCards.append(cardView)
            
            NSLayoutConstraint.activate([
                cardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
                cardView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
                cardView.heightAnchor.constraint(equalToConstant: 120),
                cardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: CGFloat(index * 130))
            ])
        }
    }
    
    private func startAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.animateCards()
        }
    }
    
    private func animateCards() {
        for (index, card) in postCards.enumerated() {
            UIView.animate(withDuration: 0.6, delay: Double(index) * 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
                card.alpha = 1
                card.transform = .identity
            }
        }
        
        // 애니메이션 완료 후 다음 화면으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.navigateToNextScreen()
        }
    }
    
    private func navigateToNextScreen() {
        if DataManager.shared.autoLogin() {
            navigateToMainScreen()
        } else {
            navigateToOnboarding()
        }
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

// MARK: - PostCardView
class PostCardView: UIView {
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let primaryMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let detailMessageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 0
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
        backgroundColor = .white
        layer.cornerRadius = 12
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius = 4
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(primaryMessageLabel)
        addSubview(secondaryMessageLabel)
        addSubview(detailMessageLabel)
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            usernameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            primaryMessageLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            primaryMessageLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 4),
            primaryMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            secondaryMessageLabel.leadingAnchor.constraint(equalTo: primaryMessageLabel.leadingAnchor),
            secondaryMessageLabel.topAnchor.constraint(equalTo: primaryMessageLabel.bottomAnchor, constant: 4),
            secondaryMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            detailMessageLabel.leadingAnchor.constraint(equalTo: secondaryMessageLabel.leadingAnchor),
            detailMessageLabel.topAnchor.constraint(equalTo: secondaryMessageLabel.bottomAnchor, constant: 4),
            detailMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            detailMessageLabel.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with data: PostCardData) {
        usernameLabel.text = data.username
        primaryMessageLabel.text = data.primaryMessage
        secondaryMessageLabel.text = data.secondaryMessage
        detailMessageLabel.text = data.detailMessage
    }
}

struct PostCardData {
    let username: String
    let primaryMessage: String
    let secondaryMessage: String
    let detailMessage: String
}
