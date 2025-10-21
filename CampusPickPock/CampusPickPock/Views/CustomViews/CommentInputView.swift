//
//  CommentInputView.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

protocol CommentInputViewDelegate: AnyObject {
    func commentInputView(_ view: CommentInputView, didSubmitComment text: String, isSecret: Bool)
}

class CommentInputView: UIView {
    
    weak var delegate: CommentInputViewDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryBackgroundColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요..."
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let secretCheckbox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        button.tintColor = .primaryColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let secretLabel: UILabel = {
        let label = UILabel()
        label.text = "비밀댓글"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전송", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .backgroundColor
        
        addSubview(containerView)
        containerView.addSubview(textField)
        containerView.addSubview(secretCheckbox)
        containerView.addSubview(secretLabel)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 60),
            
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            textField.heightAnchor.constraint(equalToConstant: 36),
            
            sendButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 8),
            sendButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            sendButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            
            secretCheckbox.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            secretCheckbox.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 4),
            secretCheckbox.widthAnchor.constraint(equalToConstant: 20),
            secretCheckbox.heightAnchor.constraint(equalToConstant: 20),
            
            secretLabel.leadingAnchor.constraint(equalTo: secretCheckbox.trailingAnchor, constant: 4),
            secretLabel.centerYAnchor.constraint(equalTo: secretCheckbox.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        secretCheckbox.addTarget(self, action: #selector(checkboxTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
    }
    
    @objc private func checkboxTapped() {
        secretCheckbox.isSelected.toggle()
    }
    
    @objc private func sendTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        delegate?.commentInputView(self, didSubmitComment: text, isSecret: secretCheckbox.isSelected)
        textField.text = ""
        secretCheckbox.isSelected = false
        textField.resignFirstResponder()
    }
}

