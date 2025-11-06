//
//  SignUpViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "회원가입"
        label.font = UIFont.pretendardBold(size: 28)
        label.textColor = .primaryColor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 이름 필드
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름"
        label.font = UIFont.pretendardSemibold(size: 15)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.font = UIFont.pretendardMedium(size: 15)
        textField.textColor = .primaryTextColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: "이름",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 학번 필드
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
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.keyboardType = .numberPad
        textField.font = UIFont.pretendardMedium(size: 15)
        textField.textColor = .primaryTextColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: "학번",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 생년월일 필드
    private let birthDateLabel: UILabel = {
        let label = UILabel()
        label.text = "생년월일"
        label.font = UIFont.pretendardSemibold(size: 15)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let birthDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ex) 2003/02/05"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.font = UIFont.pretendardMedium(size: 15)
        textField.textColor = .primaryTextColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: "ex) 2003/02/05",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 닉네임 필드
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.pretendardSemibold(size: 15)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.font = UIFont.pretendardMedium(size: 15)
        textField.textColor = .primaryTextColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: "닉네임",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 비밀번호 필드
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀번호"
        label.font = UIFont.pretendardSemibold(size: 15)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.isSecureTextEntry = true
        textField.font = UIFont.pretendardMedium(size: 15)
        textField.textColor = .primaryTextColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 비밀번호 확인 필드
    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "비밀번호 확인"
        textField.borderStyle = .none
        textField.backgroundColor = .white
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.isSecureTextEntry = true
        textField.font = UIFont.pretendardMedium(size: 15)
        textField.textColor = .primaryTextColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(
            string: "비밀번호 확인",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryTextColor]
        )
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // 비밀번호 안내 문구
    private let passwordGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "영문 대문자와 소문자, 숫자, 특수문자 중 2가지 이상을 조합하여 6-20자로 입력해주세요."
        label.font = UIFont.pretendardMedium(size: 12)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("회원가입 하기", for: .normal)
        button.backgroundColor = .primaryColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.pretendardBold(size: 18)
        button.layer.cornerRadius = 10 // 높이(54)의 절반
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
        
        // Set up navigation bar
        title = ""
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(studentIdLabel)
        contentView.addSubview(studentIdTextField)
        contentView.addSubview(birthDateLabel)
        contentView.addSubview(birthDateTextField)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(nicknameTextField)
        contentView.addSubview(passwordLabel)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(confirmPasswordTextField)
        contentView.addSubview(passwordGuideLabel)
        contentView.addSubview(signUpButton)
        
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // 제목
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // 이름 필드
            nameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 학번 필드
            studentIdLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20),
            studentIdLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            studentIdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            studentIdTextField.topAnchor.constraint(equalTo: studentIdLabel.bottomAnchor, constant: 8),
            studentIdTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            studentIdTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            studentIdTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 생년월일 필드
            birthDateLabel.topAnchor.constraint(equalTo: studentIdTextField.bottomAnchor, constant: 20),
            birthDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            birthDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            birthDateTextField.topAnchor.constraint(equalTo: birthDateLabel.bottomAnchor, constant: 8),
            birthDateTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            birthDateTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            birthDateTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 닉네임 필드
            nicknameLabel.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 20),
            nicknameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nicknameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            nicknameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nicknameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 비밀번호 필드
            passwordLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 8),
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 비밀번호 확인 필드
            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            confirmPasswordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            confirmPasswordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // 비밀번호 안내 문구
            passwordGuideLabel.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 8),
            passwordGuideLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            passwordGuideLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            // 회원가입 버튼
            signUpButton.topAnchor.constraint(equalTo: passwordGuideLabel.bottomAnchor, constant: 32),
            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            signUpButton.heightAnchor.constraint(equalToConstant: 65),
            signUpButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
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
        
        // 자동으로 슬래시 추가 (YYYY/MM/DD 형식)
        var formatted = ""
        for (index, char) in limited.enumerated() {
            if index == 4 || index == 6 {
                formatted += "/"
            }
            formatted += String(char)
        }
        
        // 값이 변경된 경우에만 업데이트
        if formatted != birthDateTextField.text {
            birthDateTextField.text = formatted
        }
    }
    
    @objc private func signUpTapped() {
        guard let name = nameTextField.text, !name.isEmpty,
              let studentId = studentIdTextField.text, !studentId.isEmpty,
              let birthDate = birthDateTextField.text, !birthDate.isEmpty,
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
        
        // 생년월일 형식 검증 (YYYY/MM/DD)
        guard isValidDateFormat(birthDate) else {
            showAlert(message: "생년월일 형식을 올바르게 입력해주세요. (YYYY/MM/DD)")
            return
        }
        
        // API에 전송하기 위해 슬래시를 하이픈으로 변환
        let formattedBirthDate = birthDate.replacingOccurrences(of: "/", with: "-")
        
        // 로딩 표시
        signUpButton.isEnabled = false
        signUpButton.setTitle("회원가입 중...", for: .normal)
        
        // 버튼 참조를 미리 저장
        let button = signUpButton
        
        // API 호출
        APIService.shared.registerUser(
            userStudentId: studentId,
            userBirthDate: formattedBirthDate,
            userRealName: name,
            userNickname: nickname,
            userPassword: password
        ) { [weak self] result in
            DispatchQueue.main.async {
                // 버튼 상태 복원
                button.isEnabled = true
                button.setTitle("회원가입 하기", for: .normal)
                
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
        // 슬래시 형식도 지원
        if dateString.contains("/") {
            dateFormatter.dateFormat = "yyyy/MM/dd"
        } else {
            dateFormatter.dateFormat = "yyyy-MM-dd"
        }
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

