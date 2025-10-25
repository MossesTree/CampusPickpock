//
//  addPosting.swift
//  CampusPickPock
//
//  Created by 주현아 on 10/8/25.
//

import UIKit

class PostViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let titleLabel = UILabel()
    private let imagePlaceholder = UIImageView()
    private let imageCountLabel = UILabel()

    private let titleTextField = UITextField()
    private let descriptionTextView = UITextView()
    private let studentIdField = UITextField()
    private let nameField = UITextField()

    private let submitButton = UIButton()
    private let helperLabel = UILabel()

    // MARK: - Custom Properties
    var isFoundMode = true // true: 주인을 찾아요, false: 잃어버렸어요

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6

        setupScrollView()
        setupUI()
        layoutUI()
        applyMode()
    }

    // MARK: - UI Setup

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupUI() {
        // 타이틀
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        titleLabel.textAlignment = .center

        // 이미지 박스
        imagePlaceholder.backgroundColor = .white
        imagePlaceholder.layer.cornerRadius = 12
        imagePlaceholder.layer.borderColor = UIColor.lightGray.cgColor
        imagePlaceholder.layer.borderWidth = 1
        imagePlaceholder.contentMode = .center
        imagePlaceholder.image = UIImage(systemName: "camera.fill")
        imagePlaceholder.tintColor = .gray

        imageCountLabel.font = .systemFont(ofSize: 14)
        imageCountLabel.textColor = .gray
        imageCountLabel.textAlignment = .center
        imageCountLabel.text = "0/5"

        // 제목 입력
        titleTextField.placeholder = "글 제목"
        titleTextField.borderStyle = .roundedRect

        // 설명 입력
        descriptionTextView.layer.cornerRadius = 8
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextView.font = UIFont.systemFont(ofSize: 16)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)

        // 개인정보 입력
        studentIdField.placeholder = "학번 / 생년월일"
        studentIdField.borderStyle = .roundedRect

        nameField.placeholder = "이름"
        nameField.borderStyle = .roundedRect

        // 버튼
        submitButton.setTitle("올리기", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 10
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)

        // 도와주는 메시지
        helperLabel.font = UIFont.systemFont(ofSize: 12)
        helperLabel.textColor = .gray
        helperLabel.textAlignment = .center
        helperLabel.numberOfLines = 2
    }

    private func layoutUI() {
        let stack = UIStackView(arrangedSubviews: [
            titleLabel,
            imagePlaceholder,
            imageCountLabel,
            titleTextField,
            descriptionTextView,
        ])
        if isFoundMode {
            stack.addArrangedSubview(studentIdField)
            stack.addArrangedSubview(nameField)
        }
        stack.addArrangedSubview(submitButton)
        if !isFoundMode {
            stack.addArrangedSubview(helperLabel)
        }

        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32),

            imagePlaceholder.heightAnchor.constraint(equalToConstant: 160),
            submitButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }

    // MARK: - Mode 설정

    private func applyMode() {
        if isFoundMode {
            titleLabel.text = "주인을 찾아요"
            descriptionTextView.text = "캠퍼스 줍줍에서 찾은 분실물에 대한 내용을 작성해주세요."
            helperLabel.isHidden = true
        } else {
            titleLabel.text = "잃어버렸어요"
            descriptionTextView.text = "캠퍼스 줍줍에서 잃어버린 분실물에 대한 내용을 작성해주세요."
            studentIdField.isHidden = true
            nameField.isHidden = true
            helperLabel.text = "분실물을 빨리 찾을 수 있게 캠퍼스 줍줍이 도와드릴게요!"
        }
    }
}
