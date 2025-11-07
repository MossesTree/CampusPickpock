//
//  UIFont+Extensions.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

extension UIFont {
    /// Pretendard 폰트를 가져오는 헬퍼 메서드
    /// 여러 가능한 폰트 이름을 시도하여 가장 적합한 폰트를 반환합니다.
    static func pretendard(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        // 가능한 폰트 이름들
        let possibleNames = [
            "Pretendard Variable",
            "PretendardVariable",
            "Pretendard-Variable",
            "PretendardVariable-Regular"
        ]
        
        // 먼저 폰트 이름으로 직접 찾기
        for fontName in possibleNames {
            if let font = UIFont(name: fontName, size: size) {
                // Variable Font의 경우 weight를 descriptor로 설정
                if weight != .regular {
                    let fontDescriptor = font.fontDescriptor.addingAttributes([
                        .traits: [UIFontDescriptor.TraitKey.weight: weight]
                    ])
                    return UIFont(descriptor: fontDescriptor, size: size)
                }
                return font
            }
        }
        
        // 폰트를 찾지 못한 경우 시스템 폰트로 fallback
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    /// Pretendard Bold 폰트
    static func pretendardBold(size: CGFloat) -> UIFont {
        return pretendard(size: size, weight: .bold)
    }
    
    /// Pretendard Semibold 폰트
    static func pretendardSemibold(size: CGFloat) -> UIFont {
        return pretendard(size: size, weight: .semibold)
    }
    
    /// Pretendard Medium 폰트
    static func pretendardMedium(size: CGFloat) -> UIFont {
        return pretendard(size: size, weight: .medium)
    }
}



