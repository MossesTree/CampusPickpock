//
//  PostCreateViewController.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit
import PhotosUI

class PostCreateViewController: UIViewController {
    
    // MARK: - Custom Navigation Header
    private let customNavHeader: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = UIColor(red: 0x51/255.0, green: 0x5B/255.0, blue: 0x70/255.0, alpha: 1.0)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let navTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "주인을 찾아요"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .primaryTextColor
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
        label.textColor = .gray
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
    
    // MARK: - Location Section
    private let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("위치 추가", for: .normal)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let storageCheckbox: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let storageLabel: UILabel = {
        let label = UILabel()
        label.text = "분실물 보관함에 넣어놨어요"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Category Section
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
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
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "글 제목"
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        textField.layer.cornerRadius = 8
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftViewMode = .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // MARK: - Description Section
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "자세한 설명"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .primaryTextColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.text = "캠퍼스 줍줍에서 찾은 분실물에 대한 내용을 작성해 주세요."
        textView.textColor = .placeholderText
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        textView.layer.cornerRadius = 8
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
        label.text = "캠퍼스 줍줍에서 찾은 분실물에 등록된 개인 정보를 등록해주세요"
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
        button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectedImages: [UIImage] = []
    private var isStorageChecked = false
    private var selectedCategory: String?
    private var selectedLocation: String?
    
    // 수정 모드를 위한 프로퍼티들
    private var isEditMode = false
    private var editingPost: Post?
    private var editingPostDetail: PostDetailItem?
    private var postType: PostType = .found
    private var uploadButtonTopConstraint: NSLayoutConstraint?
    private var categoryToSelect: String? // 수정 모드에서 선택할 카테고리 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupActions()
        updateImageCount()
    }
    
    private func setupUI() {
        view.backgroundColor = .backgroundColor
        
        // Hide default navigation bar
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Add custom header first to ensure it's on top
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        view.addSubview(customNavHeader)
        customNavHeader.addSubview(backButton)
        customNavHeader.addSubview(navTitleLabel)
        view.addSubview(navDividerLine)
        
        // Add all subviews
        contentView.addSubview(imageUploadView)
        imageUploadView.addSubview(cameraIconImageView)
        imageUploadView.addSubview(imageCountLabel)
        contentView.addSubview(imageCollectionView)
        
        contentView.addSubview(locationButton)
        contentView.addSubview(storageCheckbox)
        contentView.addSubview(storageLabel)
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(categoryStackView)
        
        // imageCollectionView를 다른 뷰들 위로 올려서 터치가 가로채지지 않도록
        contentView.bringSubviewToFront(imageCollectionView)
        
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
        
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        
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
            
            navDividerLine.topAnchor.constraint(equalTo: customNavHeader.bottomAnchor),
            navDividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navDividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navDividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            scrollView.topAnchor.constraint(equalTo: navDividerLine.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: customNavHeader.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            
            navTitleLabel.centerXAnchor.constraint(equalTo: customNavHeader.centerXAnchor),
            navTitleLabel.centerYAnchor.constraint(equalTo: customNavHeader.centerYAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Image Upload Section - positioned at (96, 60) from top
            imageUploadView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60),
            imageUploadView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 96),
            imageUploadView.widthAnchor.constraint(equalToConstant: 185),
            imageUploadView.heightAnchor.constraint(equalToConstant: 185),
            
            cameraIconImageView.centerXAnchor.constraint(equalTo: imageUploadView.centerXAnchor),
            cameraIconImageView.centerYAnchor.constraint(equalTo: imageUploadView.centerYAnchor, constant: -10),
            cameraIconImageView.widthAnchor.constraint(equalToConstant: 65),
            cameraIconImageView.heightAnchor.constraint(equalToConstant: 60),
            
            imageCountLabel.centerXAnchor.constraint(equalTo: imageUploadView.centerXAnchor),
            imageCountLabel.topAnchor.constraint(equalTo: cameraIconImageView.bottomAnchor, constant: 8),
            
            // Image Collection View - starts from the left edge, single row
            imageCollectionView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 60),
            imageCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageCollectionView.heightAnchor.constraint(equalToConstant: 200),
            
            // Location Section - constraint to whichever view is visible
            locationButton.topAnchor.constraint(equalTo: imageUploadView.bottomAnchor, constant: 20),
            locationButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            storageCheckbox.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 16),
            storageCheckbox.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            storageLabel.leadingAnchor.constraint(equalTo: storageCheckbox.trailingAnchor, constant: 8),
            storageLabel.centerYAnchor.constraint(equalTo: storageCheckbox.centerYAnchor),
            
            // Category Section
            categoryLabel.topAnchor.constraint(equalTo: storageCheckbox.bottomAnchor, constant: 24),
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
            
            // Personal Info Section
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
            
            // Upload Button
            uploadButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            uploadButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            uploadButton.heightAnchor.constraint(equalToConstant: 56),
            uploadButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
        
        // uploadButton의 top 제약조건 저장 (기본값: birthDateTextField 아래)
        uploadButtonTopConstraint = uploadButton.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 32)
        uploadButtonTopConstraint?.isActive = true
    }
    
    private func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        imageCollectionView.register(AddImageCell.self, forCellWithReuseIdentifier: "AddImageCell")
        
        // imageCollectionView를 다른 뷰들 위로 올려서 터치가 가로채지지 않도록
        contentView.bringSubviewToFront(imageCollectionView)
        
        // Add tap gesture to image upload view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageUploadTapped))
        imageUploadView.addGestureRecognizer(tapGesture)
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
            button.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
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
            button.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
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
    
    private func setupActions() {
        locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
        storageCheckbox.addTarget(self, action: #selector(storageCheckboxTapped), for: .touchUpInside)
        uploadButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        
        descriptionTextView.delegate = self
        birthDateTextField.delegate = self
        
        // 생년월일 포맷터 추가
        birthDateTextField.addTarget(self, action: #selector(birthDateTextFieldChanged), for: .editingChanged)
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
    
    @objc private func locationButtonTapped() {
        let alert = UIAlertController(title: "위치 입력", message: "습득한 위치를 입력해주세요.", preferredStyle: .alert)
        
        alert.addTextField { [weak self] textField in
            textField.placeholder = "예: 캠퍼스, 도서관, 강의실"
            textField.text = self?.selectedLocation
        }
        
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                self?.selectedLocation = text
                self?.locationButton.setTitle(text, for: .normal)
            }
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func backTapped() {
        print("🔙 PostCreateViewController 뒤로가기 버튼 탭됨")
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
    
    @objc private func storageCheckboxTapped() {
        isStorageChecked.toggle()
        let imageName = isStorageChecked ? "checkmark.square.fill" : "square"
        storageCheckbox.setImage(UIImage(systemName: imageName), for: .normal)
        storageCheckbox.tintColor = isStorageChecked ? UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0) : .gray
    }
    
    @objc private func uploadTapped() {
        // 수정 모드인지 확인
        if isEditMode {
            handleEditMode()
        } else {
            handleCreateMode()
        }
    }
    
    private func handleEditMode() {
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              description != "캠퍼스 줍줍에서 찾은 분실물에 대한 내용을 작성해 주세요." else {
            showAlert(message: "제목과 내용을 입력해주세요.")
            return
        }
        
        guard let postingId = editingPost?.postingId else {
            showAlert(message: "게시글 정보를 찾을 수 없습니다.")
            return
        }
        
        // 로딩 상태 표시
        uploadButton.isEnabled = false
        uploadButton.setTitle("수정 중...", for: .normal)
        
        // 기존 이미지 URL들 가져오기
        var imageUrls: [String] = []
        if let postDetail = editingPostDetail {
            imageUrls = postDetail.postingImageUrls ?? []
        }
        
        // 수정 요청 데이터 생성
        let updateData = UpdatePostRequest(
            postingCategory: selectedCategory ?? "기타",
            postingTitle: title,
            postingContent: description,
            itemPlace: selectedLocation ?? "캠퍼스",
            isPlacedInStorage: isStorageChecked,
            ownerStudentId: "", // 수정 시에는 개인정보 변경 불가
            ownerBirthDate: "", // 수정 시에는 개인정보 변경 불가
            ownerName: "", // 수정 시에는 개인정보 변경 불가
            postingImageUrls: imageUrls
        )
        
        // 수정 API 호출
        APIService.shared.updatePost(postingId: postingId, updateData: updateData) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                // 버튼 상태 복원
                self.uploadButton.isEnabled = true
                self.uploadButton.setTitle("수정하기", for: .normal)
                
                switch result {
                case .success(let response):
                    print("✅ 게시글 수정 성공: \(response.message)")
                    self.showSuccessAlert()
                    
                case .failure(let error):
                    print("❌ 게시글 수정 실패: \(error.localizedDescription)")
                    self.showAlert(message: "게시글 수정에 실패했습니다: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func handleCreateMode() {
        // 필수 항목 검증: 제목, 설명, 위치
        guard let title = titleTextField.text, !title.isEmpty,
              let description = descriptionTextView.text, !description.isEmpty,
              description != "캠퍼스 줍줍에서 찾은 분실물에 대한 내용을 작성해 주세요.",
              let location = selectedLocation, !location.isEmpty else {
            showAlert(message: "제목, 설명, 위치는 필수 항목입니다.")
            return
        }
        
        // 개인정보는 선택 항목
        let name = nameTextField.text ?? ""
        let studentId = studentIdTextField.text ?? ""
        var birthDate = birthDateTextField.text ?? ""
        
        // 생년월일에 하이픈이 없으면 추가
        if !birthDate.isEmpty && !birthDate.contains("-") {
            birthDate = formatBirthDate(birthDate)
        }
        
        // 로딩 상태 표시
        uploadButton.isEnabled = false
        uploadButton.setTitle(selectedImages.isEmpty ? "게시글 작성 중..." : "이미지 업로드 중...", for: .normal)
        
        // 이미지가 있는 경우 먼저 업로드
        if !selectedImages.isEmpty {
            uploadImagesAndCreatePost(
                title: title,
                description: description,
                name: name,
                studentId: studentId,
                birthDate: birthDate
            )
        } else {
            // 이미지가 없는 경우 바로 게시글 작성
            createPostWithImageUrls(
                title: title,
                description: description,
                name: name,
                studentId: studentId,
                birthDate: birthDate,
                imageUrls: []
            )
        }
    }
    
    private func uploadImagesAndCreatePost(title: String, description: String, name: String, studentId: String, birthDate: String) {
        // 파일명 생성 (타임스탬프 + 인덱스)
        let timestamp = Int(Date().timeIntervalSince1970)
        let fileNames = selectedImages.enumerated().map { index, _ in
            "post_\(timestamp)_\(index).jpg"
        }
        
        print("📸 이미지 업로드 시작: \(fileNames.count)개")
        
        // 1단계: Presigned URL 요청
        APIService.shared.getPresignedUrls(fileNames: fileNames) { [weak self] result in
            switch result {
            case .success(let presignedUrls):
                print("✅ Presigned URL 획득 성공")
                self?.uploadImagesToS3(presignedUrls: presignedUrls, title: title, description: description, name: name, studentId: studentId, birthDate: birthDate)
                
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
    
    private func uploadImagesToS3(presignedUrls: [String], title: String, description: String, name: String, studentId: String, birthDate: String) {
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
                        print("✅ 이미지 \(index + 1)/\(totalImages) 업로드 성공")
                        
                        // 진행 상황 업데이트
                        self.uploadButton.setTitle("이미지 업로드 중... \(index + 1)/\(totalImages)", for: .normal)
                        
                    case .failure(let error):
                        uploadError = error
                        print("❌ 이미지 \(index + 1)/\(totalImages) 업로드 실패: \(error.localizedDescription)")
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
                name: name,
                studentId: studentId,
                birthDate: birthDate,
                imageUrls: uploadedImageUrls
            )
        }
    }
    
    private func createPostWithImageUrls(title: String, description: String, name: String, studentId: String, birthDate: String, imageUrls: [String]) {
        print("📝 게시글 작성 시작")
        
        APIService.shared.createPost(
            postingTitle: title,
            postingContent: description,
            postingType: "FOUND", // 습득물 게시글
            itemPlace: selectedLocation ?? "캠퍼스",
            ownerStudentId: studentId,
            ownerBirthDate: birthDate,
            ownerName: name,
            postingImageUrls: imageUrls,
            postingCategory: selectedCategory ?? "기타",
            isPlacedInStorage: isStorageChecked
        ) { [weak self] result in
            DispatchQueue.main.async {
                // 버튼 상태 복원
                self?.uploadButton.isEnabled = true
                self?.uploadButton.setTitle("올리기", for: .normal)
                
                switch result {
                case .success(let response):
                    print("✅ 게시글 작성 성공: \(response)")
                    self?.showSuccessAlert()
                    
                case .failure(let error):
                    print("❌ 게시글 작성 실패: \(error.localizedDescription)")
                    self?.showAlert(message: "게시글 작성에 실패했습니다: \(error.localizedDescription)")
                }
            }
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
            // 이미지가 표시될 때 컬렉션뷰를 다시 최상위로 올림
            contentView.bringSubviewToFront(imageCollectionView)
        }
        imageCollectionView.reloadData()
    }
    
    @objc private func categoryButtonTapped(_ sender: UIButton) {
        // 모든 버튼을 초기 상태로 리셋
        for subview in categoryStackView.arrangedSubviews {
            if let stackView = subview as? UIStackView {
                for arrangedSubview in stackView.arrangedSubviews {
                    if let button = arrangedSubview as? UIButton {
                        button.backgroundColor = UIColor(red: 0.9, green: 0.93, blue: 1.0, alpha: 1.0)
                        button.setTitleColor(UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0), for: .normal)
                    }
                }
            }
        }
        
        // 선택된 버튼 표시
        sender.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
        sender.setTitleColor(.white, for: .normal)
        
        // 선택된 카테고리 저장
        selectedCategory = sender.title(for: .normal)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    private func formatBirthDate(_ text: String) -> String {
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
        
        return formatted
    }
    
    // MARK: - Edit Mode Configuration
    func configureForEdit(post: Post, postDetail: PostDetailItem?) {
        isEditMode = true
        editingPost = post
        editingPostDetail = postDetail
        postType = post.type
        
        // 게시글 타입에 따라 제목 변경
        switch post.type {
        case .found:
            navTitleLabel.text = "주인을 찾아요"
        case .lost:
            navTitleLabel.text = "잃어버렸어요"
        }
        
        // 기존 데이터로 폼 채우기
        if let postDetail = postDetail {
            print("📝 수정 모드 데이터 채우기 시작")
            print("📍 itemPlace: \(postDetail.itemPlace ?? "nil")")
            print("📦 isPlacedInStorage: \(postDetail.isPlacedInStorage?.description ?? "nil")")
            print("🏷️ postingCategory: \(postDetail.postingCategory ?? "nil")")
            
            titleTextField.text = postDetail.postingTitle
            descriptionTextView.text = postDetail.postingContent
            descriptionTextView.textColor = .primaryTextColor
            
            // 키보드 타임아웃 에러 방지: 텍스트 필드들을 편집 종료 상태로 만들기
            titleTextField.resignFirstResponder()
            descriptionTextView.resignFirstResponder()
            
            // 위치 설정
            if let itemPlace = postDetail.itemPlace {
                selectedLocation = itemPlace
                locationButton.setTitle(itemPlace, for: .normal)
                print("✅ 위치 설정 완료: \(itemPlace)")
            } else {
                print("⚠️ 위치 정보 없음")
            }
            
            // 카테고리 설정
            if let category = postDetail.postingCategory {
                selectedCategory = category
                categoryToSelect = category
                print("✅ 카테고리 설정 완료: \(category)")
            } else {
                print("⚠️ 카테고리 정보 없음")
            }
            
            // 분실물 보관함 체크박스 설정 (found 타입일 때만)
            if postType == .found {
                if let isPlacedInStorage = postDetail.isPlacedInStorage, isPlacedInStorage {
                    isStorageChecked = true
                    storageCheckbox.setImage(UIImage(systemName: "checkmark.square.fill"), for: .normal)
                    storageCheckbox.tintColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
                    print("✅ 분실물 보관함 체크박스 설정 완료")
                } else {
                    isStorageChecked = false
                    storageCheckbox.setImage(UIImage(systemName: "square"), for: .normal)
                    storageCheckbox.tintColor = .gray
                    print("⚠️ 분실물 보관함 정보 없음 또는 false")
                }
            }
            
            // 개인정보 입력란 채우기 (found 타입일 때만)
            if postType == .found {
                if let ownerName = postDetail.ownerName {
                    nameTextField.text = ownerName
                    print("✅ 이름 설정: \(ownerName)")
                }
                if let ownerStudentId = postDetail.ownerStudentId {
                    studentIdTextField.text = ownerStudentId
                    print("✅ 학번 설정: \(ownerStudentId)")
                }
                if let ownerBirthDate = postDetail.ownerBirthDate {
                    birthDateTextField.text = formatBirthDate(ownerBirthDate)
                    print("✅ 생년월일 설정: \(ownerBirthDate)")
                }
                
                // 키보드 타임아웃 에러 방지
                nameTextField.resignFirstResponder()
                studentIdTextField.resignFirstResponder()
                birthDateTextField.resignFirstResponder()
            }
            
            // 이미지 URL이 있다면 로드
            if let imageUrls = postDetail.postingImageUrls, !imageUrls.isEmpty {
                loadImagesFromUrls(imageUrls)
            }
        }
        
        // 업로드 버튼 텍스트 변경
        uploadButton.setTitle("수정하기", for: .normal)
        
        // 개인정보 섹션은 found 타입일 때만 표시
        // 분실물 보관함 체크박스는 found 타입일 때만 표시
        if postType == .found {
            // found 타입: 개인정보 섹션 표시
            personalInfoLabel.isHidden = false
            personalInfoDescriptionLabel.isHidden = false
            nameTextField.isHidden = false
            studentIdTextField.isHidden = false
            birthDateTextField.isHidden = false
            
            // 분실물 보관함 체크박스 표시
            storageCheckbox.isHidden = false
            storageLabel.isHidden = false
        } else {
            // lost 타입: 개인정보 섹션 숨김 및 제약조건 조정
            personalInfoLabel.alpha = 0
            personalInfoDescriptionLabel.alpha = 0
            nameTextField.alpha = 0
            studentIdTextField.alpha = 0
            birthDateTextField.alpha = 0
            
            personalInfoLabel.isHidden = true
            personalInfoDescriptionLabel.isHidden = true
            nameTextField.isHidden = true
            studentIdTextField.isHidden = true
            birthDateTextField.isHidden = true
            
            // lost 타입: 분실물 보관함 체크박스 숨김
            storageCheckbox.isHidden = true
            storageLabel.isHidden = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 수정 모드이고 lost 타입일 때만 제약조건 조정
        if isEditMode && postType == .lost {
            adjustConstraintsForEditMode()
        }
        
        // 수정 모드일 때 카테고리 선택
        if isEditMode, let category = categoryToSelect {
            selectCategory(category)
        }
    }
    
    private func adjustConstraintsForEditMode() {
        // 기존 제약조건 비활성화
        if let constraint = uploadButtonTopConstraint {
            constraint.isActive = false
        }
        
        // descriptionTextView에서 uploadButton까지의 거리로 변경하여 여백 줄이기
        let newConstraint = uploadButton.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 32)
        uploadButtonTopConstraint = newConstraint
        newConstraint.isActive = true
    }
    
    private func selectCategory(_ category: String) {
        for subview in categoryStackView.arrangedSubviews {
            if let stackView = subview as? UIStackView {
                for arrangedSubview in stackView.arrangedSubviews {
                    if let button = arrangedSubview as? UIButton, button.title(for: .normal) == category {
                        button.backgroundColor = UIColor(red: 0.26, green: 0.41, blue: 0.96, alpha: 1.0)
                        button.setTitleColor(.white, for: .normal)
                        return
                    }
                }
            }
        }
    }
    
    private func loadImagesFromUrls(_ imageUrls: [String]) {
        print("📸 기존 이미지 로드 시작: \(imageUrls.count)개")
        
        for imageUrl in imageUrls {
            guard let url = URL(string: imageUrl) else { continue }
            
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.selectedImages.append(image)
                        self?.updateImageCount()
                        self?.imageCollectionView.reloadData()
                        print("✅ 이미지 로드 완료: \(imageUrl)")
                    }
                }
            }
        }
    }
    
    private func showSuccessAlert() {
        let editMode = isEditMode
        let message = editMode ? "게시글이 성공적으로 수정되었습니다." : "습득물 게시글이 성공적으로 작성되었습니다."
        let alert = UIAlertController(title: "성공", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }
}

// MARK: - PHPickerViewControllerDelegate
extension PostCreateViewController: PHPickerViewControllerDelegate {
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
extension PostCreateViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
extension PostCreateViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .placeholderText {
            textView.text = nil
            textView.textColor = .primaryTextColor
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "캠퍼스 줍줍에서 찾은 분실물에 대한 내용을 작성해 주세요."
            textView.textColor = .placeholderText
        }
    }
}

// MARK: - UITextFieldDelegate
extension PostCreateViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 생년월일 필드일 때만 자동 포맷팅
        if textField == birthDateTextField {
            return true // birthDateTextFieldChanged에서 처리하므로 true 반환
        }
        return true
    }
}

// MARK: - DeleteButton
class DeleteButton: UIButton {
    var onDelete: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // 버튼 타입 명시적으로 설정
        self.setTitle(nil, for: .normal)
        self.setImage(nil, for: .normal)
        
        // 빨간색 원 배경의 흰색 X 아이콘 생성 (25x25)
        let scale = UIScreen.main.scale
        let circleSize = CGSize(width: 25 * scale, height: 25 * scale)
        UIGraphicsBeginImageContextWithOptions(circleSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        
        if let context = UIGraphicsGetCurrentContext() {
            // 빨간색 원 그리기
            context.setFillColor(UIColor.red.cgColor)
            context.fillEllipse(in: CGRect(origin: .zero, size: circleSize))
            
            // 흰색 X 그리기
            context.setStrokeColor(UIColor.white.cgColor)
            context.setLineWidth(2.5 * scale)
            context.setLineCap(.round)
            let padding: CGFloat = 7 * scale
            context.move(to: CGPoint(x: padding, y: padding))
            context.addLine(to: CGPoint(x: circleSize.width - padding, y: circleSize.height - padding))
            context.move(to: CGPoint(x: circleSize.width - padding, y: padding))
            context.addLine(to: CGPoint(x: padding, y: circleSize.height - padding))
            context.strokePath()
            
            if let combinedImage = UIGraphicsGetImageFromCurrentImageContext() {
                self.setImage(combinedImage, for: .normal)
            }
        }
        
        // 버튼 설정
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true
        self.adjustsImageWhenHighlighted = false
        self.adjustsImageWhenDisabled = false
        self.imageView?.contentMode = .scaleAspectFit
        
        // 액션 추가
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        print("🔧 DeleteButton 초기화 완료: type=\(type(of: self))")
    }
    
    @objc private func buttonTapped() {
        print("🗑️ DeleteButton 터치됨!")
        onDelete?()
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        // 터치 영역을 확대 (45x45)
        let expandedBounds = bounds.insetBy(dx: -10, dy: -10)
        return expandedBounds.contains(point)
    }
}

// MARK: - ImageCell
class ImageCell: UICollectionViewCell {
    var onDelete: (() -> Void)?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.isUserInteractionEnabled = false  // 이미지뷰가 터치를 가로채지 않도록
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let deleteButton: DeleteButton = {
        let button = DeleteButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 셀 자체가 터치를 받을 수 있도록 설정
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(deleteButton)
        
        // 컨텐츠뷰의 clipsToBounds 확인
        contentView.clipsToBounds = true
        
        // 이미지뷰가 버튼을 가리지 않도록 z-index 설정
        contentView.bringSubviewToFront(deleteButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            deleteButton.widthAnchor.constraint(equalToConstant: 25),
            deleteButton.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        // 버튼에 직접 액션 추가
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 레이아웃 완료 후 항상 버튼을 최상위로
        contentView.bringSubviewToFront(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage, onDelete: @escaping () -> Void) {
        imageView.image = image
        self.onDelete = onDelete
        
        // 버튼이 항상 앞에 오도록
        contentView.bringSubviewToFront(deleteButton)
        
        // 버튼 활성화 및 터치 가능하도록 설정
        deleteButton.isEnabled = true
        deleteButton.isUserInteractionEnabled = true
        deleteButton.isHidden = false
        deleteButton.alpha = 1.0
        
        // 셀과 컨텐츠뷰도 터치 가능하도록 재확인
        isUserInteractionEnabled = true
        contentView.isUserInteractionEnabled = true
        
        print("🔧 ImageCell configure 완료: DeleteButton=\(type(of: deleteButton)), onDelete=\(onDelete != nil ? "설정됨" : "nil")")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 레이아웃이 완료되지 않았다면 기본 처리
        guard deleteButton.frame.width > 0, deleteButton.frame.height > 0 else {
            return super.hitTest(point, with: event)
        }
        
        // 버튼 영역을 크게 확대해서 터치 감지 개선 (45x45 터치 영역)
        let expandedFrame = deleteButton.frame.insetBy(dx: -10, dy: -10)
        if expandedFrame.contains(point) {
            // 버튼의 좌표계로 변환
            let buttonPoint = convert(point, to: deleteButton)
            // 버튼의 hitTest 호출하여 버튼이 터치를 받을 수 있는지 확인
            if let hitView = deleteButton.hitTest(buttonPoint, with: event) {
                return hitView
            }
            // 버튼의 hitTest가 nil을 반환하면 버튼 자체 반환
            return deleteButton
        }
        // 버튼 영역이 아니면 기본 처리 (컬렉션뷰 스크롤을 위해 nil 반환하지 않음)
        // 하지만 이미지뷰는 터치를 받지 않도록 했으므로 nil 반환으로 스크롤 허용
        let imagePoint = convert(point, to: imageView)
        if imageView.bounds.contains(imagePoint) {
            return nil  // 이미지 영역 터치 시 스크롤 허용
        }
        return super.hitTest(point, with: event)
    }
    
    @objc private func deleteButtonTapped() {
        print("🗑️ ImageCell deleteButtonTapped 호출됨")
        onDelete?()
    }
    
    // deleteButtonTapped 메서드 제거 - DeleteButton이 자체적으로 처리
}


// MARK: - AddImageCell
class AddImageCell: UICollectionViewCell {
    var onAddTapped: (() -> Void)?
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .gray
        button.backgroundColor = UIColor(red: 0xF5/255.0, green: 0xF5/255.0, blue: 0xF5/255.0, alpha: 1.0)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(addButton)
        
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            addButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func addButtonTapped() {
        onAddTapped?()
    }
}

