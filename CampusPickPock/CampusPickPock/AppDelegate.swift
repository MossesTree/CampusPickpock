//
//  AppDelegate.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 폰트 로드 및 디버깅
        loadCustomFonts()
        return true
    }
    
    // MARK: - Font Loading
    private func loadCustomFonts() {
        // 등록된 폰트 이름 확인 (디버깅용)
        print("📝 등록된 모든 폰트 패밀리:")
        let allFonts = UIFont.familyNames.sorted()
        for familyName in allFonts {
            if familyName.lowercased().contains("pretendard") {
                let fonts = UIFont.fontNames(forFamilyName: familyName)
                print("  ✅ Family: \(familyName)")
                for fontName in fonts {
                    print("    - \(fontName)")
                }
            }
        }
        
        // Pretendard 폰트 이름 직접 확인
        let possibleNames = ["Pretendard Variable", "PretendardVariable", "Pretendard-Variable"]
        print("\n📝 Pretendard 폰트 이름 확인:")
        for name in possibleNames {
            if let font = UIFont(name: name, size: 17) {
                print("  ✅ 사용 가능: '\(name)' - 실제 폰트 이름: \(font.fontName)")
            } else {
                print("  ❌ 사용 불가: '\(name)'")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

