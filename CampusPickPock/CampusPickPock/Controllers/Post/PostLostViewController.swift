//
//  PostLostViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit
import PhotosUI

class PostLostViewController: UIViewController {
    
    // MARK: - Custom Navigation Header
    private let customNavHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        // DefaultBackIcon을 48x48 크기로 설정
        if let backIcon = UIImage(named: "DefaultBackIcon") {
            let size = CGSize(width: 48, height: 48)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            backIcon.draw(in: CGRect(origin: .zero, size: size))
            let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            button.setImage(resizedIcon?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "잃어버렸어요"
        // Pretendard Variable 20px, bold (주인을 찾아요와 동일한 두께), rgba(19, 45, 100, 1)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 20) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.bold.rawValue]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 20)
        } else {
            label.font = UIFont.boldSystemFont(ofSize: 20)
        }
        label.textColor = UIColor(red: 19/255.0, green: 45/255.0, blue: 100/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let navDividerLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xC7/255.0, green: 0xCF/255.0, blue: 0xE1/255.0, alpha: 1.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    // MARK: - Image Upload Section
    private let imageUploadView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0xCD/255.0, green: 0xD7/255.0, blue: 0xE0/255.0, alpha: 1.0)
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let cameraIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "CameraIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/5"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(red: 78/255.0, green: 78/255.0, blue: 78/255.0, alpha: 1.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 180, height: 200)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        // 버튼 터치를 위해 스크롤 제스처 취소 설정
        collectionView.canCancelContentTouches = true
        collectionView.delaysContentTouches = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Category Section
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        // Pretendard Variable SemiBold 15px
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 15) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold.rawValue]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 15)
        } else {
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        label.textColor = UIColor(red: 59/255.0, green: 59/255.0, blue: 59/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let categoryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Title Section
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "제목"
        // Pretendard Variable SemiBold 15px
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 15) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold.rawValue]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 15)
        } else {
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        label.textColor = UIColor(red: 59/255.0, green: 59/255.0, blue: 59/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        // Placeholder 스타일 설정: Pretendard Variable 15px rgba(106, 106, 106, 1)
        let placeholderText = "글 제목"
        let placeholderColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 15) {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .font: pretendardFont,
                    .foregroundColor: placeholderColor
                ]
            )
        } else {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 15),
                    .foregroundColor: placeholderColor
                ]
            )
        }
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        textField.layer.cornerRadius = 8
        // 테두리 추가: rgba(199, 207, 225, 1) 색상의 1px 테두리
        textField.layer.borderWidth = 1.0 / UIScreen.main.scale
        textField.layer.borderColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 225/255.0, alpha: 1.0).cgColor
        // 좌우 14px 패딩
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        textField.rightViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Description Section
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자세한 설명"
        // Pretendard Variable SemiBold 15px
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 15) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.semibold.rawValue]
            ])
            label.font = UIFont(descriptor: fontDescriptor, size: 15)
        } else {
            label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        }
        label.textColor = UIColor(red: 59/255.0, green: 59/255.0, blue: 59/255.0, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        // Placeholder 스타일: Pretendard Variable 15px rgba(106, 106, 106, 1)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 15) {
            textView.font = pretendardFont
        } else {
            textView.font = UIFont.systemFont(ofSize: 15)
        }
        textView.textColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)
        // 패딩: 좌우 14px, 상하 10px
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        // lineFragmentPadding을 0으로 설정하여 추가 여백 제거
        textView.textContainer.lineFragmentPadding = 0
        textView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        textView.layer.cornerRadius = 8
        // 테두리 추가: rgba(199, 207, 225, 1) 색상의 1px 테두리
        textView.layer.borderWidth = 1.0 / UIScreen.main.scale
        textView.layer.borderColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 225/255.0, alpha: 1.0).cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    // MARK: - Personal Info Section
    private let personalInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 입력란"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let personalInfoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "잃어버린 분실물에 등록된 개인 정보를 등록해주세요"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let studentIdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "학번"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let birthDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "생년월일"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Upload Button
    private let uploadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("올리기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 74/255.0, green: 128/255.0, blue: 240/255.0, alpha: 1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Helper Text
    private let helperLabel: UILabel = {
        let label = UILabel()
        label.text = "분실물을 빨리 찾을 수 있게 캠퍼스 줍줍이 도와드릴게요!"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .secondaryTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var selectedImages: [UIImage] = []
    private var selectedCategory: String?
    private var selectedLocation: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupActions()
        updateImageCount()
        setupDescriptionPlaceholder()
    }
    
    private func setupDescriptionPlaceholder() {
        // 초기 placeholder 설정 (행간 25px)
        if descriptionTextView.text.isEmpty {
            let placeholderText = "캠퍼스 줍줍에서 잃어버린 분실물에 대한 내용을 작성해주세요."
            let placeholderColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)
            let font = descriptionTextView.font ?? UIFont.systemFont(ofSize: 15)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 25 - font.lineHeight  // 행간 25px (lineHeight를 고려)
            
            let attributedText = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .font: font,
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
            )
            descriptionTextView.attributedText = attributedText
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add subviews in proper order
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add custom header after scrollView to ensure it's on top
        view.addSubview(customNavHeader)
        customNavHeader.addSubview(backButton)
        customNavHeader.addSubview(navTitleLabel)
        view.addSubview(navDividerLine)
        
        // Add all subviews
        contentView.addSubview(imageUploadView)
        imageUploadView.addSubview(cameraIconImageView)
        imageUploadView.addSubview(imageCountLabel)
        contentView.addSubview(imageCollectionView)
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryStackView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextField)
        
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionTextView)
        
        contentView.addSubview(personalInfoLabel)
        contentView.addSubview(personalInfoDescriptionLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(studentIdTextField)
        contentView.addSubview(birthDateTextField)
        
        contentView.addSubview(uploadButton)
        contentView.addSubview(helperLabel)
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
        // Hide personal info section
        personalInfoLabel.isHidden = true
        personalInfoDescriptionLabel.isHidden = true
        nameTextField.isHidden = true
        studentIdTextField.isHidden = true
        birthDateTextField.isHidden = true
        helperLabel.isHidden = true
        
        setupConstraints()
        setupCategoryButtons()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Custom navigation header
            customNavHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customNavHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavHeader.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavHeader.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: customNavHeader.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 48),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            
            navTitleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            navTitleLabel.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            
            navDividerLine.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor),
            navDividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navDividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navDividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            scrollView.topAnchor.constraint(equalTo: navDividerLine.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Image Upload Section - positioned at 20 from navDividerLine (1px 헤더 라인으로부터 20 떨어진 위치)
            imageUploadView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageUploadView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 96),
            imageUploadView.widthAnchor.constraint(equalToConstant: 185),
            imageUploadView.heightAnchor.constraint(equalToConstant: 185),
            
            cameraIconImageView.centerXAnchor.constraint(equalTo: imageUploadView.centerXAnchor),
            cameraIconImageView.centerYAnchor.constraint(equalTo: imageUploadView.centerYAnchor, constant: -10),
            cameraIconImageView.widthAnchor.constraint(equalToConstant: 65),
            cameraIconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            imageCountLabel.centerXAnchor.constraint(equalTo: imageUploadView.centerXAnchor),
            imageCountLabel.topAnchor.constraint(equalTo: cameraIconImageView.bottomAnchor, constant: 8),
            
            // Image Collection View (1px 헤더 라인으로부터 20 떨어진 위치)
            imageCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            // Category Section - constraint to whichever view is visible
            categoryLabel.topAnchor.constraint(equalTo: imageUploadView.bottomAnchor, constant: 24),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            categoryStackView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 12),
            categoryStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Title Section
            titleLabel.topAnchor.constraint(equalTo: categoryStackView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Description Section
            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 120),
            
            // Upload Button - connected to descriptionTextView since personal info is hidden
            uploadButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            
            // Personal Info Section (hidden but constraints kept for structure)
            personalInfoLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            personalInfoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            personalInfoDescriptionLabel.topAnchor.constraint(equalTo: personalInfoLabel.bottomAnchor, constant: 8),
            personalInfoDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            personalInfoDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            nameTextField.topAnchor.constraint(equalTo: personalInfoDescriptionLabel.bottomAnchor, constant: 16),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 48),
            
            studentIdTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            studentIdTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            studentIdTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            studentIdTextField.heightAnchor.constraint(equalToConstant: 48),
            
            birthDateTextField.topAnchor.constraint(equalTo: studentIdTextField.bottomAnchor, constant: 12),
            birthDateTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            birthDateTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            birthDateTextField.heightAnchor.constraint(equalToConstant: 48),
            
            // Upload Button - constraints
            uploadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            uploadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            uploadButton.heightAnchor.constraint(equalToConstant: 56),
            
            // Helper Text
            helperLabel.topAnchor.constraint(equalTo: uploadButton.bottomAnchor, constant: 16),
            helperLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            helperLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            helperLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func setupCategoryButtons() {
        let categories = ["전자제품", "지갑·카드", "의류·잡화", "학용품", "생활용품", "기타"]
        
        // 3개씩 나누어서 가로 스택뷰로 배치
        let firstRow = ["전자제품", "지갑·카드", "의류·잡화"]
        let secondRow = ["학용품", "생활용품", "기타"]
        
        let firstRowStack = UIStackView()
        firstRowStack.axis = .horizontal
        firstRowStack.spacing = 8
        firstRowStack.distribution = .fill
        firstRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        let secondRowStack = UIStackView()
        secondRowStack.axis = .horizontal
        secondRowStack.spacing = 8
        secondRowStack.distribution = .fill
        secondRowStack.translatesAutoresizingMaskIntoConstraints = false
        
        let buttonWidth: CGFloat = (UIScreen.main.bounds.width - 40 - 16) / 3 // 화면 너비에서 여백 빼고 3으로 나눔
        
        for category in firstRow {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
            button.backgroundColor = UIColor(red: 206/255.0, green: 214/255.0, blue: 233/255.0, alpha: 1.0)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 8
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            firstRowStack.addArrangedSubview(button)
        }
        
        for category in secondRow {
            let button = UIButton(type: .system)
            button.setTitle(category, for: .normal)
            button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
            button.backgroundColor = UIColor(red: 206/255.0, green: 214/255.0, blue: 233/255.0, alpha: 1.0)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 8
            button.heightAnchor.constraint(equalToConstant: 40).isActive = true
            button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
            button.addTarget(self, action: #selector(categoryButtonTapped(_:)), for: .touchUpInside)
            secondRowStack.addArrangedSubview(button)
        }
        
        categoryStackView.addArrangedSubview(firstRowStack)
        categoryStackView.addArrangedSubview(secondRowStack)
    }
    
    private func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        imageCollectionView.register(AddImageCell.self, forCellWithReuseIdentifier: "AddImageCell")
        
        // Add tap gesture to image upload view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageUploadTapped))
        imageUploadView.addGestureRecognizer(tapGesture)
    }
    
    private func setupActions() {
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        descriptionTextView.delegate = self
    }
    
    @objc private func backTapped() {
        print("🔙 PostLostViewController 뒤로가기 버튼 탭됨")
        navigationController?.popViewController(animated: true)
        print("🔙 메인화면으로 복귀 완료")
    }
    
    @objc private func imageUploadTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 5 - selectedImages.count
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func uploadTapped() {
        // placeholder인지 확인
        let placeholderText = "캠퍼스 줍줍에서 잃어버린 분실물에 대한 내용을 작성해주세요."
        let placeholderColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)
        let isPlaceholder = descriptionTextView.text == placeholderText && descriptionTextView.textColor == placeholderColor
        
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              !isPlaceholder else {
            showAlert(message: "제목과 설명을 입력해주세요.")
            return
        }
        
        // 로딩 상태 표시
        uploadButton.isEnabled = false
        uploadButton.setTitle(selectedImages.isEmpty ? "게시글 작성 중..." : "이미지 업로드 중...", for: .normal)
        
        // 이미지가 있는 경우 먼저 업로드
        if !selectedImages.isEmpty {
            uploadImagesAndCreatePost(
                title: title,
                description: description
            )
        } else {
            // 이미지가 없는 경우 바로 게시글 작성
            createPostWithImageUrls(
                title: title,
                description: description,
                imageUrls: []
            )
        }
    }
    
    private func updateImageCount() {
        imageCountLabel.text = "\(selectedImages.count)/5"
        
        if selectedImages.isEmpty {
            cameraIconImageView.isHidden = false
            imageCountLabel.isHidden = false
            imageUploadView.isHidden = false
            imageCollectionView.isHidden = true
        } else {
            cameraIconImageView.isHidden = true
            imageCountLabel.isHidden = true
            imageUploadView.isHidden = true
            imageCollectionView.isHidden = false
        }
        imageCollectionView.reloadData()
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func uploadImagesAndCreatePost(title: String, description: String) {
        // 파일명 생성 (타임스탬프 + 인덱스)
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileNames = selectedImages.enumerated().map { index, _ in
            "lost_post_\(timestamp)_\(index).jpg"
        }
        
        print("📸 분실물 이미지 업로드 시작: \(fileNames.count)개")
        
        // 1단계: Presigned URL 요청
        APIService.shared.getPresignedUrls(fileNames: fileNames) { [weak self] result in
            switch result {
            case .success(let presignedUrls):
                print("✅ Presigned URL 획득 성공")
                self?.uploadImagesToS3(presignedUrls: presignedUrls, title: title, description: description)
                
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.uploadButton.isEnabled = true
                    self?.uploadButton.setTitle("올리기", for: .normal)
                    print("❌ Presigned URL 획득 실패: \(error.localizedDescription)")
                    self?.showAlert(message: "이미지 업로드 준비에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func uploadImagesToS3(presignedUrls: [String], title: String, description: String) {
        let dispatchGroup = DispatchGroup()
        var uploadedImageUrls: [String] = []
        var uploadError: APIError?
        let totalImages = presignedUrls.count
        
        for (index, presignedUrl) in presignedUrls.enumerated() {
            dispatchGroup.enter()
            
            APIService.shared.uploadImageToS3(image: selectedImages[index], presignedUrl: presignedUrl) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let imageUrl):
                        uploadedImageUrls.append(imageUrl)
                        print("✅ 분실물 이미지 \(index + 1)/\(totalImages) 업로드 성공")
                        
                        // 진행 상황 업데이트
                        self.uploadButton.setTitle("이미지 업로드 중... \(index + 1)/\(totalImages)", for: .normal)
                        
                    case .failure(let error):
                        uploadError = error
                        print("❌ 분실물 이미지 \(index + 1)/\(totalImages) 업로드 실패: \(error.localizedDescription)")
                    }
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            if let error = uploadError {
                self?.uploadButton.isEnabled = true
                self?.uploadButton.setTitle("올리기", for: .normal)
                self?.showAlert(message: "이미지 업로드에 실패했습니다: \(error.localizedDescription)")
                return
            }
            
            // 모든 이미지 업로드 성공 시 게시글 작성
            self?.uploadButton.setTitle("게시글 작성 중...", for: .normal)
            self?.createPostWithImageUrls(
                title: title,
                description: description,
                imageUrls: uploadedImageUrls
            )
        }
    }
    
    private func createPostWithImageUrls(title: String, description: String, imageUrls: [String]) {
        print("📝 분실물 게시글 작성 시작")
        
        APIService.shared.createPost(
            postingTitle: title,
            postingContent: description,
            postingType: "LOST", // 분실물 게시글
            itemPlace: selectedLocation ?? "캠퍼스",
            ownerStudentId: "",
            ownerBirthDate: "",
            ownerName: "",
            postingImageUrls: imageUrls,
            postingCategory: selectedCategory ?? "기타",
            isPlacedInStorage: false // 분실물은 보관함에 넣지 않음
        ) { [weak self] result in
            DispatchQueue.main.async {
                // 버튼 상태 복원
                self?.uploadButton.isEnabled = true
                self?.uploadButton.setTitle("올리기", for: .normal)
                
                switch result {
                case .success(let response):
                    print("✅ 분실물 게시글 작성 성공: \(response)")
                    self?.showSuccessAlert()
                    
                case .failure(let error):
                    print("❌ 분실물 게시글 작성 실패: \(error.localizedDescription)")
                    self?.showAlert(message: "게시글 작성에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        // 모든 버튼을 초기 상태로 리셋
        for subview in categoryStackView.arrangedSubviews {
            if let stackView = subview as? UIStackView {
                for arrangedSubview in stackView.arrangedSubviews {
                    if let button = arrangedSubview as? UIButton {
                        button.backgroundColor = UIColor(red: 206/255.0, green: 214/255.0, blue: 233/255.0, alpha: 1.0)
                        button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
                    }
                }
            }
        }
        
        // 선택된 버튼 표시
        sender.backgroundColor = UIColor(red: 74/255.0, green: 128/255.0, blue: 240/255.0, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
        
        // 선택된 카테고리 저장
        selectedCategory = sender.title(for: .normal)
    }
    
    private func showSuccessAlert() {
        let alert = UIAlertController(title: "성공", message: "분실물 게시글이 성공적으로 작성되었습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PostLostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                if let image = object as? UIImage {
                    DispatchQueue.main.async {
                        self?.selectedImages.append(image)
                        self?.updateImageCount()
                        self?.imageCollectionView.reloadData()
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension PostLostViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 이미지 개수 + 플러스 버튼 (최대 5개까지 선택 가능하므로 5개 미만일 때만 플러스 버튼 표시)
        let hasAddButton = selectedImages.count < 5
        return selectedImages.count + (hasAddButton ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 마지막 셀이고 선택된 이미지가 5개 미만이면 플러스 버튼 셀 표시
        if indexPath.item == selectedImages.count && selectedImages.count < 5 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddImageCell", for: indexPath) as! AddImageCell
            cell.onAddTapped = { [weak self] in
                self?.imageUploadTapped()
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let imageIndex = indexPath.item
        print("📸 Lost 셀 구성: index=\(imageIndex), 총 이미지=\(selectedImages.count)")
        cell.configure(with: selectedImages[imageIndex]) { [weak self] in
            print("🗑️ Lost 이미지 삭제 시작: index=\(imageIndex), 삭제 전 개수=\(self?.selectedImages.count ?? 0)")
            guard let self = self, imageIndex < self.selectedImages.count else {
                print("❌ Lost 인덱스 범위 초과")
                return
            }
            self.selectedImages.remove(at: imageIndex)
            print("✅ Lost 이미지 삭제 완료: 삭제 후 개수=\(self.selectedImages.count)")
            self.updateImageCount()
            self.imageCollectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // 셀 선택 비활성화 (버튼만 작동하도록)
        // 하지만 터치 이벤트는 전달되어야 하므로 true로 변경
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 셀 선택 시 아무 동작도 하지 않음 (버튼만 작동)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 200)
    }
}

// MARK: - UITextViewDelegate
extension PostLostViewController: UITextViewDelegate {
    private var placeholderText: String {
        return "캠퍼스 줍줍에서 잃어버린 분실물에 대한 내용을 작성해주세요."
    }
    
    private var placeholderColor: UIColor {
        return UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // placeholder인지 확인 (attributedText의 텍스트와 색상 확인)
        let placeholderText = "캠퍼스 줍줍에서 잃어버린 분실물에 대한 내용을 작성해주세요."
        let placeholderColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)
        
        if textView.text == placeholderText {
            // attributedText의 색상 확인
            let isPlaceholder = textView.textColor == placeholderColor || 
                               (textView.attributedText.length > 0 && 
                                textView.attributedText.attribute(.foregroundColor, at: 0, effectiveRange: nil) as? UIColor == placeholderColor)
            
            if isPlaceholder {
                textView.text = ""
                textView.textColor = .primaryTextColor
                // 입력 시 기본 행간으로 변경 (기존 attributedText의 paragraphStyle 제거)
                let font = textView.font ?? UIFont.systemFont(ofSize: 15)
                let paragraphStyle = NSMutableParagraphStyle()
                textView.typingAttributes = [
                    .font: font,
                    .foregroundColor: UIColor.primaryTextColor,
                    .paragraphStyle: paragraphStyle
                ]
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            let placeholderText = "캠퍼스 줍줍에서 잃어버린 분실물에 대한 내용을 작성해주세요."
            let placeholderColor = UIColor(red: 106/255.0, green: 106/255.0, blue: 106/255.0, alpha: 1.0)
            let font = textView.font ?? UIFont.systemFont(ofSize: 15)
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 25 - font.lineHeight  // 행간 25px (lineHeight를 고려)
            
            let attributedText = NSAttributedString(
                string: placeholderText,
                attributes: [
                    .font: font,
                    .foregroundColor: placeholderColor,
                    .paragraphStyle: paragraphStyle
                ]
            )
            textView.attributedText = attributedText
        }
    }
}
