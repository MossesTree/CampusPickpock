//
//  UIColor+Extensions.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

extension UIColor {
    // 메인 색상
    static let primaryColor = UIColor(red: 74/255, green: 128/255, blue: 240/255, alpha: 1.0) // 4A80F0
    static let secondaryColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.0) // 연한 회색
    
    // 배경 색상
    static let backgroundColor = UIColor(red: 221/255, green: 227/255, blue: 235/255, alpha: 1.0) // DDE3EB
    static let secondaryBackgroundColor = UIColor.secondarySystemBackground
    
    // 텍스트 색상
    static let primaryTextColor = UIColor.label
    static let secondaryTextColor = UIColor.secondaryLabel
    
    // 강조 색상
    static let accentColor = UIColor(red: 1.0, green: 0.59, blue: 0.0, alpha: 1.0) // 주황색
    static let dangerColor = UIColor.systemRed
    static let successColor = UIColor.systemGreen
}

