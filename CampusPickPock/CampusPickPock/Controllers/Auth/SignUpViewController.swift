//
//  SignUpViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - UI Components
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
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
    
    private let birthDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일 (YYYY-MM-DD)"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let realNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "실명"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.borderStyle = .roundedRect
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
    
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 확인"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
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
        title = "회원가입"
        
        view.addSubview(titleLabel)
        view.addSubview(studentIdTextField)
        view.addSubview(birthDateTextField)
        view.addSubview(realNameTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(confirmPasswordTextField)
        view.addSubview(autoLoginSwitch)
        view.addSubview(autoLoginLabel)
        view.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            studentIdTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            studentIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            studentIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            studentIdTextField.heightAnchor.constraint(equalToConstant: 50),
            
            birthDateTextField.topAnchor.constraint(equalTo: studentIdTextField.bottomAnchor, constant: 16),
            birthDateTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            birthDateTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            birthDateTextField.heightAnchor.constraint(equalToConstant: 50),
            
            realNameTextField.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 16),
            realNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            realNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            realNameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            nicknameTextField.topAnchor.constraint(equalTo: realNameTextField.bottomAnchor, constant: 16),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            passwordTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 16),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            autoLoginSwitch.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 16),
            autoLoginSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            autoLoginLabel.leadingAnchor.constraint(equalTo: autoLoginSwitch.trailingAnchor, constant: 8),
            autoLoginLabel.centerYAnchor.constraint(equalTo: autoLoginSwitch.centerYAnchor),
            
            signUpButton.topAnchor.constraint(equalTo: autoLoginSwitch.bottomAnchor, constant: 32),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            signUpButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    // MARK: - Actions
    private func setupActions() {
        signUpButton.addTarget(self, action: #selector(signUpTapped), for: .touchUpInside)
        
        // 생년월일 포맷터 추가
        birthDateTextField.addTarget(self, action: #selector(birthDateTextFieldChanged), for: .editingChanged)
        birthDateTextField.delegate = self
    }
    
    @objc private func birthDateTextFieldChanged() {
        guard let text = birthDateTextField.text else { return }
        
        // 숫자만 추출
        let numbers = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // 8자리로 제한
        let limited = String(numbers.prefix(8))
        
        // 자동으로 하이픈 추가
        var formatted = ""
        for (index, char) in limited.enumerated() {
            if index == 4 || index == 6 {
                formatted += "-"
            }
            formatted += String(char)
        }
        
        // 값이 변경된 경우에만 업데이트
        if formatted != birthDateTextField.text {
            birthDateTextField.text = formatted
        }
    }
    
    @objc private func signUpTapped() {
        guard let studentId = studentIdTextField.text, !studentId.isEmpty,
              let birthDate = birthDateTextField.text, !birthDate.isEmpty,
              let realName = realNameTextField.text, !realName.isEmpty,
              let nickname = nicknameTextField.text, !nickname.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(message: "모든 항목을 입력해주세요.")
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "비밀번호가 일치하지 않습니다.")
            return
        }
        
        // 생년월일 형식 검증
        guard isValidDateFormat(birthDate) else {
            showAlert(message: "생년월일 형식을 올바르게 입력해주세요. (YYYY-MM-DD)")
            return
        }
        
        // 로딩 표시
        signUpButton.isEnabled = false
        signUpButton.setTitle("회원가입 중...", for: .normal)
        
        // 버튼 참조를 미리 저장
        let button = signUpButton
        
        // API 호출
        APIService.shared.registerUser(
            userStudentId: studentId,
            userBirthDate: birthDate,
            userRealName: realName,
            userNickname: nickname,
            userPassword: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                // 버튼 상태 복원
                button.isEnabled = true
                button.setTitle("회원가입", for: .normal)
                
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if response.success {
                        // 회원가입 성공 시 로컬 데이터 저장
                        if let userId = response.userId {
                            DataManager.shared.saveUserData(userId: userId, name: nickname, email: studentId)
                        }
                        
                        self.showAlert(message: "회원가입이 완료되었습니다.") {
                            self.navigationController?.popViewController(animated: true)
                        }
                    } else {
                        self.showAlert(message: response.message ?? "회원가입에 실패했습니다.")
                    }
                case .failure(let error):
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func isValidDateFormat(_ dateString: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateString) != nil
    }
    
    private func showAlert(message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 생년월일 필드일 때만 자동 포맷팅
        if textField == birthDateTextField {
            return true // birthDateTextFieldChanged에서 처리하므로 true 반환
        }
        return true
    }
}

