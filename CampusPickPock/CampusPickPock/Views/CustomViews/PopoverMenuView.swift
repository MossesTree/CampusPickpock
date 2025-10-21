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
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with items: [MenuItem]) {
        print("🔧 PopoverMenuView configure 호출됨, delegate: \(delegate != nil ? "설정됨" : "nil")")
        self.menuItems = items
        
        // 기존 뷰들 제거
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, item) in items.enumerated() {
            let itemView = createMenuItemView(for: item, at: index)
            stackView.addArrangedSubview(itemView)
            
            if index < items.count - 1 {
                let separator = UIView()
                separator.backgroundColor = .separator
                separator.translatesAutoresizingMaskIntoConstraints = false
                separator.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                stackView.addArrangedSubview(separator)
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
        iconImageView.image = UIImage(systemName: item.iconName)
        iconImageView.tintColor = .primaryColor
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = item.title
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = .primaryTextColor
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        button.addSubview(iconImageView)
        button.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 44),
            
            iconImageView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: button.trailingAnchor)
        ])
        
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
