//
//  DataManager.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import UIKit

class DataManager {
    static let shared = DataManager()
    
    private init() {
        createSampleData()
        loadSavedUser()
    }
    
    // 현재 로그인한 사용자
    var currentUser: User?
    
    // UserDefaults 키
    private let userDefaults = UserDefaults.standard
    private let savedUserEmailKey = "savedUserEmail"
    private let savedUserNameKey = "savedUserName"
    private let savedUserIdKey = "savedUserId"
    private let autoLoginEnabledKey = "autoLoginEnabled"
    
    // 데이터 저장소
    private(set) var users: [User] = []
    private(set) var posts: [Post] = []
    private(set) var comments: [Comment] = []
    
    // MARK: - User Methods
    func login(email: String, password: String, autoLoginEnabled: Bool = true) -> Bool {
        print("🔐 로그인 시도: \(email), 자동로그인: \(autoLoginEnabled)")
        
        if let user = users.first(where: { $0.email == email }) {
            print("✅ 사용자 찾음: \(user.name)")
            currentUser = user
            
            // 자동 로그인 설정 저장
            userDefaults.set(autoLoginEnabled, forKey: autoLoginEnabledKey)
            
            if autoLoginEnabled {
                print("💾 사용자 정보 저장")
                saveUser(user)
            } else {
                print("🗑️ 자동로그인 비활성화 - 저장된 정보 삭제")
                clearSavedUserData()
            }
            
            return true
        }
        print("❌ 사용자를 찾을 수 없음")
        return false
    }
    
    func signUp(name: String, email: String, password: String, autoLoginEnabled: Bool = true) -> Bool {
        let newUser = User(name: name, email: email)
        users.append(newUser)
        currentUser = newUser
        
        // 자동 로그인 설정 저장
        userDefaults.set(autoLoginEnabled, forKey: autoLoginEnabledKey)
        
        if autoLoginEnabled {
            saveUser(newUser)
        } else {
            // 자동 로그인이 비활성화되어 있으면 저장된 사용자 정보 삭제
            clearSavedUserData()
        }
        
        return true
    }
    
    func logout() {
        currentUser = nil
        clearSavedUser()
        // 토큰도 삭제
        userDefaults.removeObject(forKey: "accessToken")
        userDefaults.synchronize()
    }
    
    func saveUserData(userId: String, name: String, email: String) {
        print("💾 사용자 데이터 저장: \(name), \(email)")
        let user = User(id: userId, name: name, email: email)
        currentUser = user
        
        // UserDefaults에 저장
        userDefaults.set(userId, forKey: savedUserIdKey)
        userDefaults.set(name, forKey: savedUserNameKey)
        userDefaults.set(email, forKey: savedUserEmailKey)
        userDefaults.set(true, forKey: autoLoginEnabledKey)
        
        // 로컬 users 배열에도 추가 (샘플 데이터와 함께)
        if !users.contains(where: { $0.id == userId }) {
            users.append(user)
        }
    }
    
    func saveLoginData(token: String, userStudentId: String, userBirthDate: String, userRealName: String, userNickname: String, autoLoginEnabled: Bool) {
        print("💾 로그인 데이터 저장 시작")
        print("💾 토큰: \(token.prefix(20))...")
        print("💾 사용자 닉네임: \(userNickname)")
        print("💾 학번: \(userStudentId)")
        
        // User 객체 생성
        let user = User(id: userStudentId, name: userNickname, email: userStudentId)
        currentUser = user
        
        // UserDefaults에 저장
        userDefaults.set(token, forKey: "accessToken")
        userDefaults.set(userStudentId, forKey: savedUserIdKey)
        userDefaults.set(userNickname, forKey: savedUserNameKey)
        userDefaults.set(userStudentId, forKey: savedUserEmailKey)
        userDefaults.set(userBirthDate, forKey: "userBirthDate")
        userDefaults.set(userRealName, forKey: "userRealName")
        userDefaults.set(autoLoginEnabled, forKey: autoLoginEnabledKey)
        
        // 저장 확인
        userDefaults.synchronize()
        let savedToken = userDefaults.string(forKey: "accessToken")
        print("💾 토큰 저장 확인: \(savedToken != nil ? "성공" : "실패")")
        if let savedToken = savedToken {
            print("💾 저장된 토큰: \(savedToken.prefix(20))...")
        }
        
        // 로컬 users 배열에도 추가 (샘플 데이터와 함께)
        if !users.contains(where: { $0.id == userStudentId }) {
            users.append(user)
        }
        
        print("💾 로그인 데이터 저장 완료")
    }
    
    func autoLogin() -> Bool {
        print("🔄 자동 로그인 시도")
        
        // 토큰 확인
        let token = userDefaults.string(forKey: "accessToken")
        print("🔄 저장된 토큰: \(token != nil ? "존재함" : "없음")")
        if let token = token {
            print("🔄 토큰 값: \(token.prefix(20))...")
        }
        
        // 자동 로그인이 명시적으로 비활성화되어 있으면 false 반환
        if userDefaults.object(forKey: autoLoginEnabledKey) != nil && !userDefaults.bool(forKey: autoLoginEnabledKey) {
            print("❌ 자동 로그인이 비활성화됨")
            return false
        }
        
        // 저장된 사용자 정보가 없으면 false 반환
        guard let savedEmail = userDefaults.string(forKey: savedUserEmailKey),
              let savedName = userDefaults.string(forKey: savedUserNameKey),
              let savedId = userDefaults.string(forKey: savedUserIdKey) else {
            print("❌ 저장된 사용자 정보 없음")
            return false
        }
        
        print("✅ 저장된 사용자 정보로 로그인: \(savedName)")
        
        // 저장된 사용자 정보로 로그인
        let user = User(id: savedId, name: savedName, email: savedEmail)
        currentUser = user
        
        // users 배열에 없으면 추가
        if !users.contains(where: { $0.id == savedId }) {
            users.append(user)
        }
        
        print("✅ 자동 로그인 성공")
        return true
    }
    
    func isAutoLoginEnabled() -> Bool {
        return userDefaults.bool(forKey: autoLoginEnabledKey)
    }
    
    func getAccessToken() -> String? {
        print("🔍 토큰 조회 시작")
        let token = userDefaults.string(forKey: "accessToken")
        print("🔍 토큰 조회 결과: \(token != nil ? "존재함" : "없음")")
        
        if let token = token {
            print("🔍 토큰 값: \(token.prefix(20))...")
            print("🔍 토큰 길이: \(token.count) characters")
            
            // JWT 토큰 형식 검증
            let tokenParts = token.components(separatedBy: ".")
            print("🔍 JWT 토큰 부분 수: \(tokenParts.count)")
            if tokenParts.count == 3 {
                print("✅ JWT 토큰 형식 유효")
            } else {
                print("❌ JWT 토큰 형식 무효")
            }
        }
        
        // UserDefaults에 저장된 모든 키 확인
        let allKeys = userDefaults.dictionaryRepresentation().keys
        let tokenKeys = allKeys.filter { $0.lowercased().contains("token") }
        print("🔍 토큰 관련 키들: \(tokenKeys)")
        
        if token != nil {
            print("✅ 토큰 조회 성공 - 인증 상태 확인됨")
        } else {
            print("❌ 토큰 조회 실패 - 인증 필요")
        }
        
        return token
    }
    
    func checkTokenStatus() {
        print("🔍 토큰 상태 확인 시작")
        let token = userDefaults.string(forKey: "accessToken")
        print("🔍 토큰 존재 여부: \(token != nil ? "존재함" : "없음")")
        
        if let token = token {
            print("🔍 토큰 길이: \(token.count)")
            print("🔍 토큰 시작 부분: \(token.prefix(50))...")
        }
        
        // 모든 UserDefaults 키 확인
        let allKeys = userDefaults.dictionaryRepresentation().keys
        print("🔍 모든 UserDefaults 키: \(Array(allKeys).sorted())")
        
        // 현재 사용자 정보 확인
        print("🔍 현재 사용자: \(currentUser?.name ?? "없음")")
        print("🔍 자동 로그인 활성화: \(isAutoLoginEnabled())")
    }
    
    private func saveUser(_ user: User) {
        userDefaults.set(user.email, forKey: savedUserEmailKey)
        userDefaults.set(user.name, forKey: savedUserNameKey)
        userDefaults.set(user.id, forKey: savedUserIdKey)
        userDefaults.synchronize()
    }
    
    private func clearSavedUser() {
        userDefaults.removeObject(forKey: savedUserEmailKey)
        userDefaults.removeObject(forKey: savedUserNameKey)
        userDefaults.removeObject(forKey: savedUserIdKey)
        userDefaults.removeObject(forKey: autoLoginEnabledKey)
        userDefaults.synchronize()
    }
    
    private func clearSavedUserData() {
        userDefaults.removeObject(forKey: savedUserEmailKey)
        userDefaults.removeObject(forKey: savedUserNameKey)
        userDefaults.removeObject(forKey: savedUserIdKey)
        userDefaults.removeObject(forKey: "accessToken")
        userDefaults.synchronize()
    }
    
    private func loadSavedUser() {
        _ = autoLogin()
    }
    
    // MARK: - Post Methods
    func createPost(title: String, content: String, images: [UIImage]) {
        guard let user = currentUser else { return }
        let newPost = Post(title: title, content: content, images: images, authorId: user.id, authorName: user.name)
        posts.insert(newPost, at: 0)
    }
    
    func getPosts() -> [Post] {
        return posts.sorted { $0.createdAt > $1.createdAt }
    }
    
    func getPost(by id: String) -> Post? {
        return posts.first { $0.id == id }
    }
    
    func searchPosts(query: String) -> [Post] {
        return posts.filter { 
            $0.title.localizedCaseInsensitiveContains(query) || 
            $0.content.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getMyPosts() -> [Post] {
        guard let userId = currentUser?.id else { return [] }
        return posts.filter { $0.authorId == userId }
    }
    
    // MARK: - Comment Methods
//    func createComment(content: String, postId: String, isPrivate: Bool) {
//        guard let user = currentUser else { return }
//        let newComment = Comment(content: content, authorId: user.id, authorName: user.name, postId: postId, isPrivate: isPrivate)
//        comments.append(newComment)
//        
//        if let index = posts.firstIndex(where: { $0.id == postId }) {
//            var updatedPost = posts[index]
//            updatedPost.commentCount += 1
//            posts[index] = updatedPost
//        }
//        
//        NotificationManager.shared.createNotification(type: .comment, message: "\(user.name)님이 댓글을 작성했습니다.", postId: postId)
//    }
//    
    func getComments(for postId: String) -> [Comment] {
        return comments.filter { $0.postId == postId }.sorted { $0.createdAt < $1.createdAt }
    }
    
    func getMyCommentedPosts() -> [Post] {
        guard let userId = currentUser?.id else { return [] }
        let myCommentedPostIds = Set(comments.filter { $0.authorId == userId }.map { $0.postId })
        return posts.filter { myCommentedPostIds.contains($0.id) }
    }
    
    // MARK: - Sample Data
    private func createSampleData() {
        let user1 = User(name: "김철수", email: "test@test.com")
        let user2 = User(name: "이영희", email: "test2@test.com")
        let user3 = User(name: "에어팟찾아삼만리", email: "airpods@test.com")
        let user4 = User(name: "프라푸치노에 자바칩 세번 추가", email: "frappuccino@test.com")
        users = [user1, user2, user3, user4]
        
        // Lost 타입 게시글
        let post1 = Post(title: "에어팟 왼쪽 찾아요 ㅠㅠ!", content: "에어팟 왼쪽 찾으신 분 계신가요 ㅠㅠ! 어제 학관 앞에서 10시쯤 잃어버렸습니다 ㅠㅠㅠㅠㅠㅠㅠ 찾으신 분들 있으실까요 실카방이랑 에타에도 올려놨는데 아직 연락이 없어요 ㅠㅠ", authorId: user3.id, authorName: user3.name, commentCount: 6, type: .lost)
        
        // Found 타입 게시글
        let post2 = Post(title: "에어팟 잃어버리신 분!", content: "학관 앞에서 주웠습니다! 아마 프로 2세대 같은데 이거 제가 가져가도 되나요? 주인 찾아요!", authorId: user4.id, authorName: user4.name, commentCount: 6, type: .found)
        
        let post3 = Post(title: "학생증 찾습니다", content: "도서관에서 학생증을 잃어버렸습니다. 찾으신 분은 연락 부탁드립니다.", authorId: user1.id, authorName: user1.name, commentCount: 2, type: .lost)
        posts = [post1, post2, post3]
        
        let comment1 = Comment(content: "저 그거 어제 학관 분실물 보관함 쪽지 것 같은데 한번 우리학교 분실물 보관 해보세요", authorId: user2.id, authorName: "줍줍했줍", postId: post1.id)
        let comment2 = Comment(content: "분실물 보관함 확인해보세요", authorId: user1.id, authorName: "이 세상은 나의 것", postId: post1.id, isPrivate: true, parentCommentId: comment1.id)
        let comment3 = Comment(content: "혹시 이름이 어떻게 되시나요?", authorId: user2.id, authorName: user2.name, postId: post3.id)
        comments = [comment1, comment2, comment3]
    }
}

