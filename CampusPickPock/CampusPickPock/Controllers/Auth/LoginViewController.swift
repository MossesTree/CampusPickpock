//
//  LoginViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "로그인"
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let studentIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "학번"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let autoLoginSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.isOn = true // 기본값으로 자동 로그인 활성화
        toggle.translatesAutoresizingMaskIntoConstraints = false
        return toggle
    }()
    
    private let autoLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "자동 로그인"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
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
        
        view.addSubview(titleLabel)
        view.addSubview(studentIdTextField)
        view.addSubview(passwordTextField)
        view.addSubview(autoLoginSwitch)
        view.addSubview(autoLoginLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            studentIdTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            studentIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            studentIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            studentIdTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: studentIdTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            autoLoginSwitch.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            autoLoginSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            autoLoginLabel.leadingAnchor.constraint(equalTo: autoLoginSwitch.trailingAnchor, constant: 8),
            autoLoginLabel.centerYAnchor.constraint(equalTo: autoLoginSwitch.centerYAnchor),
            
            loginButton.topAnchor.constraint(equalTo: autoLoginSwitch.bottomAnchor, constant: 32),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            loginButton.heightAnchor.constraint(equalToConstant: 54),
            
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
    }
    
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
                    self?.handleLoginSuccess(response: response, autoLoginEnabled: self?.autoLoginSwitch.isOn ?? true)
                case .failure(let error):
                    self?.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func handleLoginSuccess(response: LoginResponse, autoLoginEnabled: Bool) {
        // DataManager에 사용자 정보 저장
        DataManager.shared.saveLoginData(
            token: response.token,
            userStudentId: studentIdTextField.text ?? "",
            userBirthDate: response.userBirthDate,
            userRealName: response.userRealName,
            userNickname: response.userNickname,
            autoLoginEnabled: autoLoginEnabled
        )
        
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

