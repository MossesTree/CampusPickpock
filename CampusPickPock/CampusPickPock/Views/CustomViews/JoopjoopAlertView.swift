//
//  JoopjoopAlertView.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

protocol JoopjoopAlertViewDelegate: AnyObject {
    func joopjoopAlertViewDidTapSend(_ alertView: JoopjoopAlertView)
    func joopjoopAlertViewDidTapClose(_ alertView: JoopjoopAlertView)
}

class JoopjoopAlertView: UIView {
    
    weak var delegate: JoopjoopAlertViewDelegate?
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6) // HomeViewController와 동일
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 225/255.0, alpha: 1.0) // C7CFE1 - HomeViewController와 동일
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "CloseIcon1"), for: .normal) // HomeViewController와 동일
        button.tintColor = UIColor.gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let starIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "StarIcon3") // HomeViewController와 동일 (StarIcon3)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "줍줍 버튼을 누르셨네요!"
        // Pretendard Variable SemiBold 17px - HomeViewController와 동일
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 17) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold.rawValue]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 17)
        } else {
            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        }
        label.textColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0) // HomeViewController와 동일
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "줍줍 버튼을 누르면 작성자에게"
        // Pretendard Variable Regular 13px - HomeViewController와 동일
        label.font = UIFont(name: "Pretendard Variable", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0) // HomeViewController와 동일
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.text = "알림이 가요. 알림을 보내시겠어요?"
        // Pretendard Variable Regular 13px - HomeViewController와 동일
        label.font = UIFont(name: "Pretendard Variable", size: 13) ?? UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0) // HomeViewController와 동일
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("줍줍 알림 보내기", for: .normal)
        // Pretendard Variable Medium 12px - HomeViewController와 동일
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 12) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.medium.rawValue]
            ])
            button.titleLabel?.font = UIFont(descriptor: fontDescriptor, size: 12)
        } else {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        }
        button.backgroundColor = UIColor(red: 74/255.0, green: 128/255.0, blue: 240/255.0, alpha: 1.0) // HomeViewController와 동일
        button.setTitleColor(UIColor(red: 219/255.0, green: 230/255.0, blue: 255/255.0, alpha: 1.0), for: .normal) // HomeViewController와 동일
        button.layer.cornerRadius = 8 // HomeViewController와 동일
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(overlayView)
        addSubview(containerView)
        
        containerView.addSubview(closeButton)
        containerView.addSubview(starIconImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(questionLabel)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 263), // HomeViewController와 동일
            
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16), // HomeViewController와 동일
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16), // HomeViewController와 동일
            closeButton.widthAnchor.constraint(equalToConstant: 22), // HomeViewController와 동일
            closeButton.heightAnchor.constraint(equalToConstant: 22), // HomeViewController와 동일
            
            starIconImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 40), // HomeViewController와 동일
            starIconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            starIconImageView.widthAnchor.constraint(equalToConstant: 71), // HomeViewController와 동일
            starIconImageView.heightAnchor.constraint(equalToConstant: 71), // HomeViewController와 동일
            
            titleLabel.topAnchor.constraint(equalTo: starIconImageView.bottomAnchor, constant: 16), // HomeViewController와 동일
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20), // HomeViewController와 동일
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20), // HomeViewController와 동일
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8), // HomeViewController와 동일
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20), // HomeViewController와 동일
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20), // HomeViewController와 동일
            
            questionLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 0), // 간격 제거
            questionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            questionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            sendButton.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24), // HomeViewController와 동일
            sendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor), // HomeViewController와 동일
            sendButton.widthAnchor.constraint(equalToConstant: 179), // HomeViewController와 동일
            sendButton.heightAnchor.constraint(equalToConstant: 33), // HomeViewController와 동일
            sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -24)
        ])
        
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        
        // Overlay 탭 시 닫기
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(overlayTapped))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func closeButtonTapped() {
        delegate?.joopjoopAlertViewDidTapClose(self)
    }
    
    @objc private func sendButtonTapped() {
        delegate?.joopjoopAlertViewDidTapSend(self)
    }
    
    @objc private func overlayTapped() {
        delegate?.joopjoopAlertViewDidTapClose(self)
    }
}

