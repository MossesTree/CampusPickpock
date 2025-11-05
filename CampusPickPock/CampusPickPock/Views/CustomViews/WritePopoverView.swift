//
//  WritePopoverView.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

protocol WritePopoverViewDelegate: AnyObject {
    func writePopoverView(_ view: WritePopoverView, didSelectItemAt index: Int)
}

class WritePopoverView: UIView {
    
    weak var delegate: WritePopoverViewDelegate?
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 241/255.0, green: 247/255.0, blue: 255/255.0, alpha: 1.0)
        view.layer.cornerRadius = 10
        // 외곽선: 두께 1px, 색상 CED6E9
        view.layer.borderWidth = 1.0 / UIScreen.main.scale
        view.layer.borderColor = UIColor(red: 206/255.0, green: 214/255.0, blue: 233/255.0, alpha: 1.0).cgColor
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
    private var separators: [UIView] = []
    
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
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
    
    func configure(with items: [MenuItem]) {
        self.menuItems = items
        
        // 기존 뷰들 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        separators.forEach { $0.removeFromSuperview() }
        separators.removeAll()
        
        for (index, item) in items.enumerated() {
            let itemView = createMenuItemView(for: item, at: index)
            stackView.addArrangedSubview(itemView)
            
            if index < items.count - 1 {
                // 구분선 추가
                let separatorContainer = UIView()
                separatorContainer.translatesAutoresizingMaskIntoConstraints = false
                
                let separator = UIView()
                separator.backgroundColor = UIColor(red: 206/255.0, green: 214/255.0, blue: 233/255.0, alpha: 1.0)
                separator.translatesAutoresizingMaskIntoConstraints = false
                separatorContainer.addSubview(separator)
                separators.append(separator)
                
                stackView.addArrangedSubview(separatorContainer)
                
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
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // 아이콘 설정
        if index == 0 {
            // "주인을 찾아요": HomeSearchIcon 8x8
            if let customIcon = UIImage(named: "HomeSearchIcon") {
                let size = CGSize(width: 8, height: 8)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                customIcon.draw(in: CGRect(origin: .zero, size: size))
                let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                iconImageView.image = resizedIcon?.withRenderingMode(.alwaysOriginal)
            }
        } else if index == 1 {
            // "잃어버렸어요": HomeFoundIcon 13x12
            if let customIcon = UIImage(named: "HomeFoundIcon") {
                let size = CGSize(width: 13, height: 12)
                UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
                customIcon.draw(in: CGRect(origin: .zero, size: size))
                let resizedIcon = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                iconImageView.image = resizedIcon?.withRenderingMode(.alwaysOriginal)
            }
        }
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        // Pretendard Variable Regular 10px, rgba(74, 128, 240, 1)
        if let pretendardFont = UIFont(name: "Pretendard Variable", size: 10) {
            let fontDescriptor = pretendardFont.fontDescriptor.addingAttributes([
                .traits: [UIFontDescriptor.TraitKey.weight: UIFont.Weight.regular.rawValue]
            ])
            titleLabel.font = UIFont(descriptor: fontDescriptor, size: 10)
        } else {
            titleLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        }
        titleLabel.textColor = UIColor(red: 74/255.0, green: 128/255.0, blue: 240/255.0, alpha: 1.0)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 아이콘과 텍스트를 담을 컨테이너 스택뷰
        let contentStackView = UIStackView(arrangedSubviews: [iconImageView, titleLabel])
        contentStackView.axis = .horizontal
        contentStackView.spacing = 8
        contentStackView.alignment = .center
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(contentStackView)
        
        // 각 버튼 높이 계산 (총 높이 53, 구분선 1px)
        let itemHeight: CGFloat = (53 - 1) / 2  // 26
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: itemHeight),
            
            iconImageView.widthAnchor.constraint(equalToConstant: index == 0 ? 8 : 13),
            iconImageView.heightAnchor.constraint(equalToConstant: index == 0 ? 8 : 12),
            
            contentStackView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            contentStackView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        return button
    }
    
    @objc private func itemButtonTapped(_ sender: UIButton) {
        delegate?.writePopoverView(self, didSelectItemAt: sender.tag)
    }
}

