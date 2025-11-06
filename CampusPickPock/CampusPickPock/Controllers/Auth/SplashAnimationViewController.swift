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
        label.text = "캠퍼스 줍줍에서\n발견하세요"
        label.font = UIFont.pretendardBold(size: 34)
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
    
    // 제약조건 관리
    private var titleLabelCenterYConstraint: NSLayoutConstraint?
    private var titleLabelTopConstraint: NSLayoutConstraint?
    
    private var radialGradientView: nRadialGradientView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGradientView()
        setupUI()
        loadSplashPostings()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        radialGradientView?.frame = view.bounds
        radialGradientView?.setNeedsDisplay()
    }
    
    private func setupGradientView() {
        let radialView = nRadialGradientView(frame: view.bounds)
        radialView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        radialView.backgroundColor = .clear
        view.insertSubview(radialView, at: 0)
        self.radialGradientView = radialView
    }
    
    private func setupUI() {
        // 배경색을 clear로 설정하여 그라데이션이 보이도록 함
        view.backgroundColor = .clear
        
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
    
//    private func createPostCardsFromAPI() {
//        // API에서 받은 데이터로 카드 생성 (최대 3개)
//        let maxCards = min(splashPostings.count, 3)
//        
//        for index in 0..<maxCards {
//            let posting = splashPostings[index]
//            let cardView = PostCardView()
//            
//            // API 데이터를 PostCardData로 변환
//            let postData = PostCardData(
//                username: posting.postingWriterNickname,
//                primaryMessage: posting.postingTitle,
//                secondaryMessage: posting.postingContent,
//                detailMessage: posting.postingContent.count > 50 ? String(posting.postingContent.prefix(50)) + "..." : posting.postingContent
//            )
//            
//            cardView.configure(with: postData)
//            cardView.translatesAutoresizingMaskIntoConstraints = false
//            cardView.alpha = 0
//            cardView.transform = CGAffineTransform(translationX: 0, y: 50)
//            
//            cardContainerView.addSubview(cardView)
//            postCards.append(cardView)
//            
//            NSLayoutConstraint.activate([
//                cardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
//                cardView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
//                cardView.heightAnchor.constraint(equalToConstant: 120),
//                cardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: CGFloat(index * 100))
//            ])
//        }
//    }
    private func createPostCardsFromAPI() {
        // 카드가 겹치는 정도를 정의합니다. (음수 값으로 설정)
        // 예: -40pt를 주면 이전 카드의 하단 40pt가 다음 카드로 인해 덮이게 됩니다.
        let overlapOffset: CGFloat = -5.0
        
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
            
            // --- 애니메이션 초기 상태 설정 (시작 지점) ---
            cardView.alpha = 0
            // 최종 겹치는 위치보다 Y축으로 50pt 아래에서 시작하도록 설정
            cardView.transform = CGAffineTransform(translationX: 0, y: 50)
                
            cardContainerView.addSubview(cardView)
            postCards.append(cardView)
                
            // --- 겹침 레이아웃 설정 (최종 위치) ---
            NSLayoutConstraint.activate([
                cardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor),
                cardView.trailingAnchor.constraint(equalTo: cardContainerView.trailingAnchor),
                cardView.heightAnchor.constraint(equalToConstant: 120),
            ])
            
            if index == 0 {
                // 첫 번째 카드: 컨테이너의 상단에 고정
                cardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor).isActive = true
            } else {
                // 나머지 카드: 직전 카드의 하단에 연결하고, 'overlapOffset'만큼 겹치게 만듭니다.
                let previousCard = postCards[index - 1]
                cardView.topAnchor.constraint(equalTo: previousCard.bottomAnchor, constant: overlapOffset).isActive = true
            }
        }
        
        // MARK: - Z-Order 재정렬 (아래로 들어가듯이 겹치게 만드는 핵심)
        // 인덱스를 역순(maxCards-1 -> 0)으로 순회하며 뷰를 앞쪽으로 가져옵니다.
        // 이렇게 하면 Index 0번 카드가 가장 마지막에 toFront되어 시각적으로 가장 위에 놓이게 됩니다.
        for index in stride(from: maxCards - 1, through: 0, by: -1) {
            let card = postCards[index]
            cardContainerView.bringSubviewToFront(card)
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
            UIView.animate(withDuration: 1, delay: Double(index) * 0.3, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut) {
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

// MARK: - RadialGradientView
class nRadialGradientView: UIView {
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
