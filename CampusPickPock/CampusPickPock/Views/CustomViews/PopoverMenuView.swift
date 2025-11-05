//
//  PopoverMenuView.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

protocol PopoverMenuViewDelegate: AnyObject {
    func popoverMenuView(_ menuView: PopoverMenuView, didSelectItemAt index: Int)
}

class PopoverMenuView: UIView {
    
    weak var delegate: PopoverMenuViewDelegate?
    
    // 커스터마이징 옵션
    var customBackgroundColor: UIColor? = nil
    var customBorderColor: UIColor? = nil
    var customBorderWidth: CGFloat = 0
    var customCornerRadius: CGFloat = 12
    var customMaskedCorners: CACornerMask? = nil
    var customItemHeight: CGFloat? = nil  // 커스텀 아이템 높이
    var customPadding: UIEdgeInsets? = nil  // 커스텀 패딩
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondaryBackgroundColor
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private var menuItems: [MenuItem] = []
    private var stackViewTopConstraint: NSLayoutConstraint?
    private var stackViewLeadingConstraint: NSLayoutConstraint?
    private var stackViewTrailingConstraint: NSLayoutConstraint?
    private var stackViewBottomConstraint: NSLayoutConstraint?
    private var separators: [UIView] = []  // 구분선들을 저장
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        isUserInteractionEnabled = true
        
        addSubview(containerView)
        containerView.addSubview(stackView)
        
        let defaultPadding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        let padding = customPadding ?? defaultPadding
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // 패딩 제약을 변수로 저장하여 나중에 업데이트 가능하도록
        stackViewTopConstraint = stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: padding.top)
        stackViewLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: padding.left)
        stackViewTrailingConstraint = stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -padding.right)
        stackViewBottomConstraint = stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -padding.bottom)
        
        NSLayoutConstraint.activate([
            stackViewTopConstraint!,
            stackViewLeadingConstraint!,
            stackViewTrailingConstraint!,
            stackViewBottomConstraint!
        ])
        
        applyCustomStyles()
    }
    
    private func applyCustomStyles() {
        // 커스터마이징 스타일 적용
        if let bgColor = customBackgroundColor {
            containerView.backgroundColor = bgColor
            // 커스텀 배경색이 설정되면 그림자 제거
            containerView.layer.shadowOpacity = 0
        }
        
        if let borderColor = customBorderColor {
            containerView.layer.borderColor = borderColor.cgColor
            containerView.layer.borderWidth = customBorderWidth > 0 ? customBorderWidth : 1.0 / UIScreen.main.scale
        }
        
        containerView.layer.cornerRadius = customCornerRadius
        
        if let maskedCorners = customMaskedCorners {
            containerView.layer.maskedCorners = maskedCorners
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyCustomStyles()
        updatePaddingConstraints()
    }
    
    private func updatePaddingConstraints() {
        let padding = customPadding ?? UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        stackViewTopConstraint?.constant = padding.top
        stackViewLeadingConstraint?.constant = padding.left
        stackViewTrailingConstraint?.constant = -padding.right
        stackViewBottomConstraint?.constant = -padding.bottom
    }
    
    func configure(with items: [MenuItem]) {
        print("🔧 PopoverMenuView configure 호출됨, delegate: \(delegate != nil ? "설정됨" : "nil")")
        self.menuItems = items
        
        // 패딩 업데이트
        updatePaddingConstraints()
        
        // 기존 뷰들 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        // 기존 구분선들 제거
        separators.forEach { $0.removeFromSuperview() }
        separators.removeAll()
        
        for (index, item) in items.enumerated() {
            let itemView = createMenuItemView(for: item, at: index)
            stackView.addArrangedSubview(itemView)
            
            if index < items.count - 1 {
                // 구분선을 stackView 안에 두되, 너비를 containerView에 맞추기 위해 컨테이너 뷰 사용
                let separatorContainer = UIView()
                separatorContainer.translatesAutoresizingMaskIntoConstraints = false
                
                let separator = UIView()
                // 구분선 색상: rgba(199, 207, 225, 0.7) - 더 진하게
                separator.backgroundColor = UIColor(red: 199/255.0, green: 207/255.0, blue: 225/255.0, alpha: 0.7)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separatorContainer.addSubview(separator)
                separators.append(separator)
                
                stackView.addArrangedSubview(separatorContainer)
                
                // 구분선 컨테이너의 높이는 1px
                // 구분선의 너비를 containerView에 맞춤
                NSLayoutConstraint.activate([
                    separatorContainer.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.scale),
                    
                    separator.topAnchor.constraint(equalTo: separatorContainer.topAnchor),
                    separator.bottomAnchor.constraint(equalTo: separatorContainer.bottomAnchor),
                    separator.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                    separator.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
                ])
            }
        }
    }
    
    private func createMenuItemView(for item: MenuItem, at index: Int) -> UIView {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = index
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(itemButtonTapped(_:)), for: .touchUpInside)
        
        let iconImageView = UIImageView()
        // 커스텀 아이콘 설정
        if index == 2 {
            // "내가 쓴 글 보기": HomeDocumentIcon, 8x10
            if let customIcon = UIImage(named: "HomeDocumentIcon") {
                let size = CGSize(width: 8, height: 10)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                customIcon.draw(in: CGRect(origin: .zero, size: size))
                let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                iconImageView.image = resizedIcon?.withRenderingMode(.alwaysOriginal)
            } else {
                iconImageView.image = UIImage(systemName: item.iconName)
                iconImageView.tintColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
            }
        } else if index == 3 {
            // "댓글 단 글 보기": HomeCommentIcon, 10x11
            if let customIcon = UIImage(named: "HomeCommentIcon") {
                let size = CGSize(width: 10, height: 11)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                customIcon.draw(in: CGRect(origin: .zero, size: size))
                let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                iconImageView.image = resizedIcon?.withRenderingMode(.alwaysOriginal)
            } else {
                iconImageView.image = UIImage(systemName: item.iconName)
                iconImageView.tintColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
            }
        } else {
            // 기본 시스템 아이콘
            iconImageView.image = UIImage(systemName: item.iconName)
            iconImageView.tintColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
        }
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        // 첫 번째 아이템(닉네임)과 두 번째 아이템(로그아웃)은 아이콘 숨김
        iconImageView.isHidden = (index == 0 || index == 1)
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        // Pretendard Variable 11px, 굵기 400, rgba(98, 95, 95, 1)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 11) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.regular.rawValue]
            ])
            titleLabel.font = UIFont(descriptor: fontDescriptor, size: 11)
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        }
        titleLabel.textColor = UIColor(red: 98/255.0, green: 95/255.0, blue: 95/255.0, alpha: 1.0)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(iconImageView)
        button.addSubview(titleLabel)
        
        // 커스텀 높이가 설정되어 있으면 사용, 아니면 기본값 44
        let itemHeight = customItemHeight ?? 44
        // 모든 버튼 높이를 동일하게 설정
        
        // 첫 번째 아이템(닉네임)과 두 번째 아이템(로그아웃)은 아이콘이 없으므로 titleLabel의 leadingAnchor를 button의 leadingAnchor로 설정
        if index == 0 || index == 1 {
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: itemHeight),
                
                titleLabel.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: itemHeight),
                
                iconImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                // 아이콘 크기는 index에 따라 다르게 설정
                iconImageView.widthAnchor.constraint(equalToConstant: index == 2 ? 8 : index == 3 ? 10 : 16),
                iconImageView.heightAnchor.constraint(equalToConstant: index == 2 ? 10 : index == 3 ? 11 : 16),
                
                titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
                titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor)
            ])
        }
        
        return button
    }
    
    @objc private func itemButtonTapped(_ sender: UIButton) {
        print("🎯 itemButtonTapped 호출됨")
        print("🎯 팝오버 아이템 탭됨: tag = \(sender.tag), delegate: \(delegate != nil ? "설정됨" : "nil")")
        
        if delegate == nil {
            print("❌ delegate가 nil입니다!")
            return
        }
        
        delegate?.popoverMenuView(self, didSelectItemAt: sender.tag)
        print("✅ delegate 메서드 호출 완료")
    }
}

struct MenuItem {
    let title: String
    let iconName: String
}
