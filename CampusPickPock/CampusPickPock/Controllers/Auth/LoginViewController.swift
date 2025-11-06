//
//  LoginViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SplashIcon")
        imageView.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0) // #4267F6
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let studentIdLabel: UILabel = {
        let label = UILabel()
        label.text = "학번"
        label.font = UIFont.pretendardSemibold(size: 15)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let studentIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "학번"
        textField.borderStyle = .none
        textField.keyboardType = .numberPad
        textField.font = UIFont.pretendardMedium(size: 20)
        textField.textColor = .primaryTextColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "학번",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let studentIdUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.pretendardBold(size: 15)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.borderStyle = .none
        textField.isSecureTextEntry = true
        textField.font = UIFont.pretendardMedium(size: 20)
        textField.textColor = .primaryTextColor
        textField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordUnderline: UIView = {
        let view = UIView()
        view.backgroundColor = .primaryColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendardBold(size: 18)
        button.layer.cornerRadius = 12 // 높이(54)의 절반으로 완전히 둥글게
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let autoLoginCheckbox: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = .primaryColor
        button.isSelected = false // 기본값 비활성화
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let autoLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "자동 로그인하기"
        label.font = UIFont.pretendardMedium(size: 13)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private let findPasswordButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("비밀번호 찾기", for: .normal)
//        button.setTitleColor(.secondaryTextColor, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.secondaryTextColor, for: .normal)
        button.titleLabel?.font = UIFont.pretendardSemibold(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        view.addSubview(logoImageView)
        view.addSubview(studentIdLabel)
        view.addSubview(studentIdTextField)
        view.addSubview(studentIdUnderline)
        view.addSubview(passwordLabel)
        view.addSubview(passwordTextField)
        view.addSubview(passwordUnderline)
        view.addSubview(autoLoginCheckbox)
        view.addSubview(autoLoginLabel)
//        view.addSubview(findPasswordButton)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            // 로고 - 상단 중앙
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 92),
            logoImageView.heightAnchor.constraint(equalToConstant: 78),
            
            // 학번 입력 필드
            studentIdLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 60),
            studentIdLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            studentIdLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            studentIdTextField.topAnchor.constraint(equalTo: studentIdLabel.bottomAnchor, constant: 8),
            studentIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            studentIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            studentIdTextField.heightAnchor.constraint(equalToConstant: 44),
            
            studentIdUnderline.topAnchor.constraint(equalTo: studentIdTextField.bottomAnchor, constant: 4),
            studentIdUnderline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            studentIdUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            studentIdUnderline.heightAnchor.constraint(equalToConstant: 2),
            
            // 비밀번호 입력 필드
            passwordLabel.topAnchor.constraint(equalTo: studentIdUnderline.bottomAnchor, constant: 24),
            passwordLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 44),
            
            passwordUnderline.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 4),
            passwordUnderline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordUnderline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordUnderline.heightAnchor.constraint(equalToConstant: 1),
            
            // 자동 로그인 체크박스와 비밀번호 찾기
            autoLoginCheckbox.topAnchor.constraint(equalTo: passwordUnderline.bottomAnchor, constant: 16),
            autoLoginCheckbox.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            autoLoginCheckbox.widthAnchor.constraint(equalToConstant: 24),
            autoLoginCheckbox.heightAnchor.constraint(equalToConstant: 24),
            
            autoLoginLabel.leadingAnchor.constraint(equalTo: autoLoginCheckbox.trailingAnchor, constant: 8),
            autoLoginLabel.centerYAnchor.constraint(equalTo: autoLoginCheckbox.centerYAnchor),
            
//            findPasswordButton.centerYAnchor.constraint(equalTo: autoLoginCheckbox.centerYAnchor),
//            findPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // 로그인 버튼
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -76),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 65),
            
            // 회원가입 링크
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        autoLoginCheckbox.addTarget(self, action: #selector(autoLoginCheckboxTapped), for: .touchUpInside)
//        findPasswordButton.addTarget(self, action: #selector(findPasswordTapped), for: .touchUpInside)
    }
    
    @objc private func autoLoginCheckboxTapped() {
        autoLoginCheckbox.isSelected.toggle()
    }
    
//    @objc private func findPasswordTapped() {
//        // TODO: 비밀번호 찾기 기능 구현
//        showAlert(message: "비밀번호 찾기 기능은 준비 중입니다.")
//    }
    
    @objc private func loginTapped() {
        guard let studentId = studentIdTextField.text, !studentId.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "학번과 비밀번호를 입력해주세요.")
            return
        }
        
        // 로딩 표시
        loginButton.isEnabled = false
        loginButton.setTitle("로그인 중...", for: .normal)
        
        // API 호출
        APIService.shared.loginUser(userStudentId: studentId, userPassword: password) { [weak self] result in
            DispatchQueue.main.async {
                // 버튼 상태 복원
                self?.loginButton.isEnabled = true
                self?.loginButton.setTitle("로그인", for: .normal)
                
                switch result {
                case .success(let response):
                    // 로그인 성공 시 사용자 데이터 저장
                    self?.handleLoginSuccess(response: response, autoLoginEnabled: self?.autoLoginCheckbox.isSelected ?? true)
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func handleLoginSuccess(response: LoginResponse, autoLoginEnabled: Bool) {
        print("🔐 로그인 성공 처리 시작")
        print("🔐 응답 토큰: \(response.token.prefix(20))...")
        print("🔐 사용자 닉네임: \(response.userNickname)")
        print("🔐 학번: \(studentIdTextField.text ?? "")")
        print("🔐 자동 로그인 설정: \(autoLoginEnabled)")
        
        print("🔑 인증 토큰 발급 완료 - 사용자 권한 부여 시작")
        print("📊 사용자 정보:")
        print("   - 닉네임: \(response.userNickname)")
        print("   - 학번: \(studentIdTextField.text ?? "")")
        print("   - 실명: \(response.userRealName)")
        print("   - 생년월일: \(response.userBirthDate)")
        print("   - 토큰: \(response.token.prefix(20))...")
        
        // DataManager에 사용자 정보 저장
        print("💾 사용자 데이터 저장 시작")
        DataManager.shared.saveLoginData(
            token: response.token,
            userStudentId: studentIdTextField.text ?? "",
            userBirthDate: response.userBirthDate,
            userRealName: response.userRealName,
            userNickname: response.userNickname,
            autoLoginEnabled: autoLoginEnabled
        )
        
        print("✅ 사용자 데이터 저장 완료")
        print("🎯 로그인 권한 부여 완료 - 댓글 작성 권한 획득")
        print("🔐 로그인 데이터 저장 완료, 메인 화면으로 이동")
        
        // 메인 화면으로 이동
        navigateToMainScreen()
    }
    
    @objc private func signUpTapped() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
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
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

