//
//  DeleteButton.swift
//  CampusPickPock
//
//  Created for image deletion in PostCreateViewController
//

import UIKit

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

