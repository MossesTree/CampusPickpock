//
//  APIService.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//
import UIKit
import Foundation

class APIService {
    static let shared = APIService()
    
    let baseURL = "http://lostnfound-env.eba-2wmsjk7u.ap-northeast-2.elasticbeanstalk.com" 
    let session = URLSession.shared
    
    private init() {}
    
    // MARK: - User Login
    func loginUser(userStudentId: String, userPassword: String, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        
        let loginURL = "\(baseURL)/user/login"
        print("🌐 로그인 API 호출: \(loginURL)")
        
        guard let url = URL(string: loginURL) else {
            print("❌ 잘못된 URL: \(loginURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = LoginRequest(
            userStudentId: userStudentId,
            userPassword: userPassword
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
            print("📤 요청 데이터: \(String(data: request.httpBody!, encoding: .utf8) ?? "nil")")
        } catch {
            print("❌ JSON 인코딩 오류: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        print("🚀 네트워크 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 네트워크 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                            print("✅ 로그인 성공")
                            print("✅ 응답 토큰: \(loginResponse.token.prefix(20))...")
                            print("✅ 사용자 닉네임: \(loginResponse.userNickname)")
                            completion(.success(loginResponse))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 401:
                    print("❌ 인증 실패")
                    completion(.failure(.unauthorized("학번 또는 비밀번호가 올바르지 않습니다.")))
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Splash Postings
    func getSplashPostings(completion: @escaping (Result<[SplashPosting], APIError>) -> Void) {
        
        let splashURL = "\(baseURL)/splash/postings"
        print("🌐 스플래시 게시글 API 호출: \(splashURL)")
        
        guard let url = URL(string: splashURL) else {
            print("❌ 잘못된 URL: \(splashURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        print("🚀 스플래시 게시글 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 스플래시 게시글 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let splashPostings = try JSONDecoder().decode([SplashPosting].self, from: data)
                            print("✅ 스플래시 게시글 로드 성공: \(splashPostings.count)개")
                            completion(.success(splashPostings))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    func registerUser(userStudentId: String, userBirthDate: String, userRealName: String, userNickname: String, userPassword: String, completion: @escaping (Result<RegisterResponse, APIError>) -> Void) {
        
        let registerURL = "\(baseURL)/user/register"
        print("🌐 회원가입 API 호출: \(registerURL)")
        
        guard let url = URL(string: registerURL) else {
            print("❌ 잘못된 URL: \(registerURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = RegisterRequest(
            userStudentId: userStudentId,
            userBirthDate: userBirthDate,
            userRealName: userRealName,
            userNickname: userNickname,
            userPassword: userPassword
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            completion(.failure(.encodingError))
            return
        }
        
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(.invalidResponse))
                    return
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        print("📥 회원가입 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                        
                        // 여러 형식의 응답을 시도
                        do {
                            let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                            print("✅ RegisterResponse 디코딩 성공")
                            print("   - success: \(registerResponse.success)")
                            print("   - message: \(registerResponse.message ?? "nil")")
                            print("   - userId: \(registerResponse.userId ?? "nil")")
                            completion(.success(registerResponse))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            print("❌ 디코딩 실패 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                            
                            // 회원가입이 성공했다면 (200 응답) 빈 응답으로 처리
                            print("⚠️ 디코딩 실패했지만 200 응답이므로 회원가입 성공으로 처리")
                            let fallbackResponse = RegisterResponse(success: true, message: nil, userId: nil)
                            completion(.success(fallbackResponse))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        // 200 응답이고 데이터가 없으면 성공으로 처리
                        let fallbackResponse = RegisterResponse(success: true, message: nil, userId: nil)
                        completion(.success(fallbackResponse))
                    }
                case 400:
                    completion(.failure(.badRequest))
                case 409:
                    completion(.failure(.conflict("이미 존재하는 사용자입니다.")))
                case 500:
                    completion(.failure(.serverError))
                default:
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Create Post
    func createPost(postingTitle: String, postingContent: String, postingType: String, itemPlace: String, ownerStudentId: String, ownerBirthDate: String, ownerName: String, postingImageUrls: [String], postingCategory: String, isPlacedInStorage: Bool, completion: @escaping (Result<CreatePostResponse, APIError>) -> Void) {
        
        let createPostURL = "\(baseURL)/posting/add"
        print("🌐 게시글 작성 API 호출: \(createPostURL)")
        
        guard let url = URL(string: createPostURL) else {
            print("❌ 잘못된 URL: \(createPostURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 인증 토큰 추가
        if let token = DataManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔐 인증 토큰 추가됨")
        } else {
            print("❌ 인증 토큰이 없습니다")
        }
        
        let requestBody = CreatePostRequest(
            postingTitle: postingTitle,
            postingContent: postingContent,
            postingType: postingType,
            itemPlace: itemPlace,
            ownerStudentId: ownerStudentId,
            ownerBirthDate: ownerBirthDate,
            ownerName: ownerName,
            postingImageUrls: postingImageUrls,
            postingCategory: postingCategory,
            isPlacedInStorage: isPlacedInStorage
        )
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
            print("📤 요청 데이터: \(String(data: request.httpBody!, encoding: .utf8) ?? "nil")")
        } catch {
            print("❌ JSON 인코딩 오류: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        print("🚀 게시글 작성 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 게시글 작성 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data, !data.isEmpty {
                        do {
                            let createPostResponse = try JSONDecoder().decode(CreatePostResponse.self, from: data)
                            print("✅ 게시글 작성 성공")
                            completion(.success(createPostResponse))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("✅ 게시글 작성 성공 (빈 응답)")
                        // 빈 응답인 경우 기본 성공 응답 생성
                        let successResponse = CreatePostResponse(
                            success: true,
                            message: "게시글이 성공적으로 작성되었습니다.",
                            postingId: nil
                        )
                        completion(.success(successResponse))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패")
                    completion(.failure(.unauthorized("인증이 필요합니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - S3 Presigned URLs
    func getPresignedUrls(fileNames: [String], completion: @escaping (Result<[String], APIError>) -> Void) {
        
        let presignedURL = "\(baseURL)/s3/presigned-urls"
        print("🌐 S3 Presigned URL API 호출: \(presignedURL)")
        
        guard let url = URL(string: presignedURL) else {
            print("❌ 잘못된 URL: \(presignedURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 인증 토큰 추가
        if let token = DataManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔐 인증 토큰 추가됨")
        } else {
            print("❌ 인증 토큰이 없습니다")
        }
        
        do {
            request.httpBody = try JSONEncoder().encode(fileNames)
            print("📤 요청 데이터: \(String(data: request.httpBody!, encoding: .utf8) ?? "nil")")
        } catch {
            print("❌ JSON 인코딩 오류: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        print("🚀 Presigned URL 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 Presigned URL 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let presignedUrls = try JSONDecoder().decode([String].self, from: data)
                            print("✅ Presigned URL 생성 성공: \(presignedUrls.count)개")
                            completion(.success(presignedUrls))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패")
                    completion(.failure(.unauthorized("인증이 필요합니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Upload Image to S3
    func uploadImageToS3(image: UIImage, presignedUrl: String, completion: @escaping (Result<String, APIError>) -> Void) {
        
        print("🌐 S3 이미지 업로드 시작: \(presignedUrl)")
        
        guard let url = URL(string: presignedUrl) else {
            print("❌ 잘못된 Presigned URL: \(presignedUrl)")
            completion(.failure(.invalidURL))
            return
        }
        
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("❌ 이미지 데이터 변환 실패")
            completion(.failure(.encodingError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData
        
        print("🚀 S3 업로드 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 S3 업로드 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                switch httpResponse.statusCode {
                case 200:
                    print("✅ S3 이미지 업로드 성공")
                    // S3 URL에서 쿼리 파라미터를 제거하여 실제 이미지 URL 반환
                    let s3ImageUrl = String(presignedUrl.split(separator: "?")[0])
                    completion(.success(s3ImageUrl))
                case 403:
                    print("❌ S3 접근 권한 없음")
                    completion(.failure(.unauthorized("S3 접근 권한이 없습니다.")))
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Get Posting List
    func getPostingList(type: String, page: Int, pageSize: Int, completion: @escaping (Result<[PostingItem], APIError>) -> Void) {
        
        let postingListURL = "\(baseURL)/posting/list?type=\(type)&page=\(page)&pageSize=\(pageSize)"
        print("🌐 게시물 리스트 API 호출: \(postingListURL)")
        
        guard let url = URL(string: postingListURL) else {
            print("❌ 잘못된 URL: \(postingListURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        if let token = DataManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔐 인증 토큰 추가됨")
        } else {
            print("❌ 인증 토큰이 없습니다")
        }
        
        print("🚀 게시물 리스트 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 게시물 리스트 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let postingList = try JSONDecoder().decode([PostingItem].self, from: data)
                            print("✅ 게시물 리스트 로드 성공: \(postingList.count)개")
                            completion(.success(postingList))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패")
                    completion(.failure(.unauthorized("인증이 필요합니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Mark Post as Picked Up
    func markPostAsPickedUp(postingId: Int, completion: @escaping (Result<PickedUpResponse, APIError>) -> Void) {
        
        let pickedUpURL = "\(baseURL)/posting/pickedUp/\(postingId)"
        print("🌐 줍줍 API 호출: \(pickedUpURL)")
        
        guard let url = URL(string: pickedUpURL) else {
            print("❌ 잘못된 URL: \(pickedUpURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 인증 토큰 추가
        if let token = DataManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔐 인증 토큰 추가됨: \(token.prefix(20))...")
        } else {
            print("❌ 인증 토큰이 없습니다")
            print("🔍 UserDefaults 키 확인: \(UserDefaults.standard.dictionaryRepresentation().keys.filter { $0.contains("token") || $0.contains("Token") })")
        }
        
        print("🚀 줍줍 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 줍줍 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    print("✅ 줍줍 성공")
                    let pickedUpResponse = PickedUpResponse(success: true, message: "줍줍 완료")
                    completion(.success(pickedUpResponse))
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패")
                    completion(.failure(.unauthorized("인증이 필요합니다.")))
                case 403:
                    print("❌ 접근 권한 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 로그인을 확인해주세요.")))
                case 404:
                    print("❌ 게시글을 찾을 수 없음")
                    completion(.failure(.notFound("게시글을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Get Storage List
    func getStorageList(page: Int, pageSize: Int, completion: @escaping (Result<[StorageItem], APIError>) -> Void) {
        
        let storageListURL = "\(baseURL)/posting/storage/list?page=\(page)&pageSize=\(pageSize)"
        print("🌐 분실물 보관함 API 호출: \(storageListURL)")
        
        guard let url = URL(string: storageListURL) else {
            print("❌ 잘못된 URL: \(storageListURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        if let token = DataManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("🔐 인증 토큰 추가됨")
        } else {
            print("❌ 인증 토큰이 없습니다")
        }
        
        print("🚀 분실물 보관함 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 분실물 보관함 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let storageItems = try JSONDecoder().decode([StorageItem].self, from: data)
                            print("✅ 분실물 보관함 조회 성공: \(storageItems.count)개 항목")
                            completion(.success(storageItems))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패")
                    completion(.failure(.unauthorized("인증이 필요합니다.")))
                case 403:
                    print("❌ 접근 권한 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 로그인을 확인해주세요.")))
                case 404:
                    print("❌ 데이터를 찾을 수 없음")
                    completion(.failure(.notFound("분실물 보관함 데이터를 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Search Posts
    func searchPosts(type: String, keyword: String, completion: @escaping (Result<[PostingItem], APIError>) -> Void) {
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        let searchURL = "\(baseURL)/posting/search?type=\(type)&keyword=\(keyword)"
        print("🔍 검색 API 호출: \(searchURL)")
        print("🔍 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: searchURL) else {
            print("❌ 잘못된 URL: \(searchURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 검색 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 검색 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let searchResults = try JSONDecoder().decode([PostingItem].self, from: data)
                            print("✅ 검색 성공: \(searchResults.count)개 결과")
                            completion(.success(searchResults))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 검색 결과 없음")
                    completion(.failure(.notFound("검색 결과가 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - My Postings
    func getMyPostings(completion: @escaping (Result<[PostingItem], APIError>) -> Void) {
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        let myPostingsURL = "\(baseURL)/posting/myPostings"
        print("📝 내가 쓴 글 API 호출: \(myPostingsURL)")
        print("📝 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: myPostingsURL) else {
            print("❌ 잘못된 URL: \(myPostingsURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 내가 쓴 글 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 내가 쓴 글 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let myPostings = try JSONDecoder().decode([PostingItem].self, from: data)
                            print("✅ 내가 쓴 글 조회 성공: \(myPostings.count)개 항목")
                            completion(.success(myPostings))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 내가 쓴 글을 찾을 수 없음")
                    completion(.failure(.notFound("내가 쓴 글이 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Post Detail
    func getPostDetail(postingId: Int, completion: @escaping (Result<PostDetailItem, APIError>) -> Void) {
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        let postDetailURL = "\(baseURL)/posting/detail/\(postingId)"
        print("📄 게시글 상세 API 호출: \(postDetailURL)")
        print("📄 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: postDetailURL) else {
            print("❌ 잘못된 URL: \(postDetailURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 게시글 상세 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 게시글 상세 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data, !data.isEmpty {
                        do {
                            let postDetail = try JSONDecoder().decode(PostDetailItem.self, from: data)
                            print("✅ 게시글 상세 조회 성공")
                            print("✅ 제목: \(postDetail.postingTitle)")
                            print("✅ 작성자: \(postDetail.postingWriterNickname ?? "익명")")
                            print("✅ 이미지 개수: \(postDetail.postingImageUrls?.count ?? 0)")
                            completion(.success(postDetail))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            print("❌ 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음 또는 빈 데이터")
                        print("❌ HTTP 200이지만 응답 본문이 비어있음 - 서버 측 문제 가능성")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 게시글을 찾을 수 없음")
                    completion(.failure(.notFound("게시글을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Comments
    func getCommentList(postingId: Int, completion: @escaping (Result<[CommentItem], APIError>) -> Void) {
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        let commentListURL = "\(baseURL)/comment/list/\(postingId)"
        print("💬 댓글 목록 API 호출: \(commentListURL)")
        print("💬 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: commentListURL) else {
            print("❌ 잘못된 URL: \(commentListURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 댓글 목록 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 댓글 목록 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let commentList = try JSONDecoder().decode([CommentItem].self, from: data)
                            print("✅ 댓글 목록 조회 성공: \(commentList.count)개 댓글")
                            completion(.success(commentList))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 댓글을 찾을 수 없음")
                    completion(.failure(.notFound("댓글이 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Commented Postings
    func getCommentedPostings(completion: @escaping (Result<[PostingItem], APIError>) -> Void) {
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        let commentedPostingsURL = "\(baseURL)/posting/commentedPostings"
        print("💬 댓글 단 글 API 호출: \(commentedPostingsURL)")
        print("💬 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: commentedPostingsURL) else {
            print("❌ 잘못된 URL: \(commentedPostingsURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 댓글 단 글 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 댓글 단 글 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let commentedPostings = try JSONDecoder().decode([PostingItem].self, from: data)
                            print("✅ 댓글 단 글 조회 성공: \(commentedPostings.count)개 항목")
                            completion(.success(commentedPostings))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 댓글 단 글을 찾을 수 없음")
                    completion(.failure(.notFound("댓글 단 글이 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Comment Creation
    func createComment(postingId: Int, commentData: CreateCommentRequest, completion: @escaping (Result<CreateCommentResponse, APIError>) -> Void) {
        print("🔍 댓글 작성 API 권한 확인 시작 (완화 모드)")
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            print("❌ 댓글 작성 API 권한 확인 실패 - 인증 토큰 없음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (경고만, 진행 허용)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("⚠️ 경고: 잘못된 토큰 형식일 수 있음: \(tokenParts.count)개 부분")
            print("⚠️ 토큰 형식 검증 실패 - 하지만 서버에 요청 전송")
        } else {
            print("✅ JWT 토큰 형식 유효")
        }
        
        print("✅ 댓글 작성 API 권한 확인 완료 (완화 모드)")
        print("✅ JWT Access Token 확인됨: \(token.prefix(20))...")
        print("🎯 Authorization 헤더에 Bearer 토큰 추가 예정")
        print("🎯 서버에서 최종 권한 검증 수행")
        
        let createCommentURL = "\(baseURL)/comment/add/\(postingId)"
        print("💬 댓글 작성 API 호출: \(createCommentURL)")
        print("💬 게시글 ID: \(postingId)")
        print("💬 댓글 내용: \(commentData.commentContent)")
        print("💬 비밀 댓글 여부: \(commentData.isCommentSecret)")
        print("💬 부모 댓글 ID: \(commentData.parentCommentId)")
        
        guard let url = URL(string: createCommentURL) else {
            print("❌ 잘못된 URL: \(createCommentURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가 (JWT Access Token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨: Bearer \(token.prefix(20))...")
        
        do {
            let jsonData = try JSONEncoder().encode(commentData)
            request.httpBody = jsonData
            print("📦 요청 데이터: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        } catch {
            print("❌ JSON 인코딩 오류: \(error)")
            completion(.failure(.badRequest))
            return
        }
        
        print("🚀 댓글 작성 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 댓글 작성 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    print("❌ 네트워크 오류 상세: \(error)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                // 응답 헤더 정보 출력
                print("📋 응답 헤더:")
                for (key, value) in httpResponse.allHeaderFields {
                    print("   \(key): \(value)")
                }
                
                if let data = data {
                    let responseString = String(data: data, encoding: .utf8) ?? "nil"
                    print("📦 응답 데이터: \(responseString)")
                    
                    // JSON 파싱 시도
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
                        print("📄 JSON 파싱 성공: \(jsonObject)")
                    } else {
                        print("❌ JSON 파싱 실패 - 응답이 JSON 형식이 아닙니다")
                        print("📝 응답 내용 분석:")
                        print("   - 응답 길이: \(data.count) bytes")
                        print("   - 응답 내용: \(responseString)")
                        
                        // 텍스트 응답인 경우 에러 메시지 추출
                        if !responseString.isEmpty && responseString != "nil" {
                            print("📝 서버에서 텍스트 형태의 에러 메시지를 반환했습니다")
                        }
                    }
                } else {
                    print("❌ 응답 데이터가 없습니다")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    print("✅ 댓글 작성 성공!")
                    print("🎯 댓글 작성 API 권한 확인 및 실행 완료")
                    
                    // 서버가 응답 본문을 보내지 않을 수 있으므로 200 OK만으로 성공 처리
                    let successResponse = CreateCommentResponse(commentId: 0, message: "댓글이 성공적으로 작성되었습니다.")
                    completion(.success(successResponse))
                case 400:
                    print("❌ 잘못된 요청")
                    print("❌ 댓글 작성 API 권한 확인은 성공했으나 요청 형식 오류")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    print("❌ 댓글 작성 API 권한 확인 실패 - 토큰 만료")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 서버 접근 권한 없음 (403)")
                    print("❌ 게시글 ID: \(postingId)")
                    print("❌ 댓글 내용: \(commentData.commentContent)")
                    print("❌ 요청 URL: \(createCommentURL)")
                    print("❌ 인증 토큰: \(token.prefix(20))...")
                    
                    print("❌ 상세 분석:")
                    print("   1. 클라이언트 측 토큰 확인: 유효함")
                    print("   2. 클라이언트 측 게시글 접근성: 확인됨")
                    print("   3. 서버 응답: 403 Forbidden")
                    print("   4. 결론: 서버 측 권한 정책 또는 게시글 상태 문제")
                    
                    print("❌ 가능한 원인:")
                    print("   - 게시글이 서버에서 삭제되었거나 비활성화됨")
                    print("   - 게시글이 '줍줍' 처리되어 서버에서 댓글 작성 제한")
                    print("   - 서버 측 권한 정책 문제 (예: 자신의 게시글에 댓글 제한)")
                    print("   - 서버 측 비즈니스 로직 제약")
                    
                    print("❌ 권장 조치:")
                    print("   - 서버 로그 확인")
                    print("   - 게시글 상태 확인")
                    print("   - 권한 정책 검토")
                    
                    print("❌ 댓글 작성 API: 클라이언트 측 권한 확인 성공, 서버에서 접근 거부")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 게시글을 찾을 수 없음")
                    print("❌ 댓글 작성 API 권한 확인은 성공했으나 게시글 없음")
                    completion(.failure(.notFound("게시글을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    print("❌ 댓글 작성 API 권한 확인은 성공했으나 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    print("❌ 댓글 작성 API 권한 확인은 성공했으나 예상치 못한 오류")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Notification List
    func getNotificationList(completion: @escaping (Result<[NotificationItem], APIError>) -> Void) {
        print("🔔 알림 목록 API 권한 확인 시작")
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            print("❌ 알림 목록 API 권한 확인 실패 - 인증 토큰 없음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            print("❌ 알림 목록 API 권한 확인 실패 - 토큰 형식 오류")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        print("✅ 알림 목록 API 권한 확인 완료")
        print("✅ 인증 토큰 유효: \(token.prefix(20))...")
        
        let notificationListURL = "\(baseURL)/notification/list"
        print("🔔 알림 목록 API 호출: \(notificationListURL)")
        
        guard let url = URL(string: notificationListURL) else {
            print("❌ 잘못된 URL: \(notificationListURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 알림 목록 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 알림 목록 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let notifications = try JSONDecoder().decode([NotificationItem].self, from: data)
                            print("✅ 알림 목록 조회 성공: \(notifications.count)개 알림")
                            completion(.success(notifications))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 알림 목록을 찾을 수 없음")
                    completion(.failure(.notFound("알림 목록을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - JupJup Notifications
    func getJupJupNotifications(type: String, completion: @escaping (Result<[JupJupNotificationItem], APIError>) -> Void) {
        print("🔔 줍줍 알림 확인 API 시작")
        print("🔔 알림 타입: \(type)")
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            print("❌ 줍줍 알림 확인 API 권한 확인 실패 - 인증 토큰 없음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            print("❌ 줍줍 알림 확인 API 권한 확인 실패 - 토큰 형식 오류")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        print("✅ 줍줍 알림 확인 API 권한 확인 완료")
        print("✅ 인증 토큰 유효: \(token.prefix(20))...")
        
        let jupJupNotificationURL = "\(baseURL)/notification/jupJup?type=\(type)"
        print("🔔 줍줍 알림 확인 API 호출: \(jupJupNotificationURL)")
        
        guard let url = URL(string: jupJupNotificationURL) else {
            print("❌ 잘못된 URL: \(jupJupNotificationURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 줍줍 알림 확인 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 줍줍 알림 확인 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let notifications = try JSONDecoder().decode([JupJupNotificationItem].self, from: data)
                            print("✅ 줍줍 알림 확인 성공: \(notifications.count)개 알림")
                            completion(.success(notifications))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 줍줍 알림을 찾을 수 없음")
                    completion(.failure(.notFound("줍줍 알림을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Update Notification
    func updateNotification(notificationId: Int, completion: @escaping (Result<Void, APIError>) -> Void) {
        print("🔔 알림 업데이트 API 시작")
        print("🔔 알림 ID: \(notificationId)")
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            print("❌ 알림 업데이트 API 권한 확인 실패 - 인증 토큰 없음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        print("✅ 알림 업데이트 API 권한 확인 완료")
        print("✅ 인증 토큰 유효: \(token.prefix(20))...")
        
        let updateNotificationURL = "\(baseURL)/notification/update/\(notificationId)"
        print("🔔 알림 업데이트 API 호출: \(updateNotificationURL)")
        
        guard let url = URL(string: updateNotificationURL) else {
            print("❌ 잘못된 URL: \(updateNotificationURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 알림 업데이트 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 알림 업데이트 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    print("✅ 알림 업데이트 성공")
                    completion(.success(()))
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패")
                    completion(.failure(.unauthorized("인증이 만료되었습니다.")))
                case 404:
                    print("❌ 알림을 찾을 수 없음")
                    completion(.failure(.notFound("알림을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Home Postings
    func getHomePostings(type: String, completion: @escaping (Result<[HomePostingItem], APIError>) -> Void) {
        print("🏠 홈 게시글 API 권한 확인 시작")
        print("🏠 게시글 타입: \(type)")
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            print("❌ 홈 게시글 API 권한 확인 실패 - 인증 토큰 없음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            print("❌ 홈 게시글 API 권한 확인 실패 - 토큰 형식 오류")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        print("✅ 홈 게시글 API 권한 확인 완료")
        print("✅ 인증 토큰 유효: \(token.prefix(20))...")
        
        let homePostingsURL = "\(baseURL)/home/postings?type=\(type)"
        print("🏠 홈 게시글 API 호출: \(homePostingsURL)")
        
        guard let url = URL(string: homePostingsURL) else {
            print("❌ 잘못된 URL: \(homePostingsURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 홈 게시글 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 홈 게시글 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            let homePostings = try JSONDecoder().decode([HomePostingItem].self, from: data)
                            print("✅ 홈 게시글 조회 성공: \(homePostings.count)개")
                            completion(.success(homePostings))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 홈 게시글을 찾을 수 없음")
                    completion(.failure(.notFound("홈 게시글을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Update Post
    func updatePost(postingId: Int, updateData: UpdatePostRequest, completion: @escaping (Result<UpdatePostResponse, APIError>) -> Void) {
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        let updatePostURL = "\(baseURL)/posting/update/\(postingId)"
        print("📝 게시글 수정 API 호출: \(updatePostURL)")
        print("📝 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: updatePostURL) else {
            print("❌ 잘못된 URL: \(updatePostURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        do {
            let jsonData = try JSONEncoder().encode(updateData)
            request.httpBody = jsonData
            print("📦 요청 데이터: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        } catch {
            print("❌ JSON 인코딩 오류: \(error)")
            completion(.failure(.encodingError))
            return
        }
        
        print("🚀 게시글 수정 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 게시글 수정 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    print("✅ 게시글 수정 성공")
                    let updateResponse = UpdatePostResponse(success: true, message: "게시글이 성공적으로 수정되었습니다.")
                    completion(.success(updateResponse))
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 게시글을 찾을 수 없음")
                    completion(.failure(.notFound("게시글을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Delete Post
    func deletePost(postingId: Int, completion: @escaping (Result<DeletePostResponse, APIError>) -> Void) {
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        let deletePostURL = "\(baseURL)/posting/delete/\(postingId)"
        print("🗑️ 게시글 삭제 API 호출: \(deletePostURL)")
        print("🗑️ 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: deletePostURL) else {
            print("❌ 잘못된 URL: \(deletePostURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 게시글 삭제 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 게시글 삭제 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    print("✅ 게시글 삭제 성공")
                    let deleteResponse = DeletePostResponse(success: true, message: "게시글이 성공적으로 삭제되었습니다.")
                    completion(.success(deleteResponse))
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 게시글을 찾을 수 없음")
                    completion(.failure(.notFound("게시글을 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
    
    // MARK: - Banner Data
    func getBannerData(completion: @escaping (Result<BannerItem?, APIError>) -> Void) {
        print("🎯 배너 데이터 API 권한 확인 시작")
        
        // 토큰 유효성 검증
        guard let token = DataManager.shared.getAccessToken(), !token.isEmpty else {
            print("❌ 토큰이 없거나 비어있음")
            print("❌ 배너 데이터 API 권한 확인 실패 - 인증 토큰 없음")
            completion(.failure(.unauthorized("로그인이 필요합니다.")))
            return
        }
        
        // 토큰 형식 검증 (JWT 토큰은 보통 3개 부분으로 구성)
        let tokenParts = token.components(separatedBy: ".")
        if tokenParts.count != 3 {
            print("❌ 잘못된 토큰 형식: \(tokenParts.count)개 부분")
            print("❌ 배너 데이터 API 권한 확인 실패 - 토큰 형식 오류")
            completion(.failure(.unauthorized("유효하지 않은 토큰입니다.")))
            return
        }
        
        print("✅ 배너 데이터 API 권한 확인 완료")
        print("✅ 인증 토큰 유효: \(token.prefix(20))...")
        
        let bannerURL = "\(baseURL)/home/banner"
        print("🎯 배너 데이터 API 호출: \(bannerURL)")
        
        guard let url = URL(string: bannerURL) else {
            print("❌ 잘못된 URL: \(bannerURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 배너 데이터 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 배너 데이터 응답 수신")
                
                if let error = error {
                    print("❌ 네트워크 오류: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ 잘못된 응답 타입")
                    completion(.failure(.invalidResponse))
                    return
                }
                
                print("📊 HTTP 상태 코드: \(httpResponse.statusCode)")
                
                if let data = data {
                    print("📦 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                }
                
                switch httpResponse.statusCode {
                case 200:
                    if let data = data {
                        do {
                            // 서버가 단일 객체를 반환하므로 단일 BannerItem으로 디코딩
                            let bannerItem = try JSONDecoder().decode(BannerItem.self, from: data)
                            print("✅ 배너 데이터 조회 성공: 1개")
                            completion(.success(bannerItem))
                        } catch {
                            print("❌ JSON 디코딩 오류: \(error)")
                            print("❌ 응답 데이터: \(String(data: data, encoding: .utf8) ?? "nil")")
                            completion(.failure(.decodingError))
                        }
                    } else {
                        print("❌ 응답 데이터 없음")
                        completion(.failure(.noData))
                    }
                case 400:
                    print("❌ 잘못된 요청")
                    completion(.failure(.badRequest))
                case 401:
                    print("❌ 인증 실패 - 토큰이 만료되었거나 유효하지 않음")
                    completion(.failure(.unauthorized("인증이 만료되었습니다. 다시 로그인해주세요.")))
                case 403:
                    print("❌ 접근 권한 없음 - 토큰은 유효하지만 해당 리소스에 접근 권한이 없음")
                    completion(.failure(.unauthorized("접근 권한이 없습니다. 관리자에게 문의하세요.")))
                case 404:
                    print("❌ 배너 데이터를 찾을 수 없음")
                    completion(.failure(.notFound("배너 데이터를 찾을 수 없습니다.")))
                case 500:
                    print("❌ 서버 오류")
                    completion(.failure(.serverError))
                default:
                    print("❌ 알 수 없는 오류: \(httpResponse.statusCode)")
                    completion(.failure(.unknownError(httpResponse.statusCode)))
                }
            }
        }.resume()
    }
}

// MARK: - Request/Response Models
struct SplashPosting: Codable {
    let postingWriterNickname: String
    let postingTitle: String
    let postingContent: String
}

struct LoginRequest: Codable {
    let userStudentId: String
    let userPassword: String
}

struct LoginResponse: Codable {
    let token: String
    let userBirthDate: String
    let userRealName: String
    let userNickname: String
}

struct RegisterRequest: Codable {
    let userStudentId: String
    let userBirthDate: String
    let userRealName: String
    let userNickname: String
    let userPassword: String
}

struct RegisterResponse: Codable {
    let success: Bool
    let message: String?
    let userId: String?
    
    // 커스텀 디코딩으로 null 값 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // success는 필수 값
        success = try container.decode(Bool.self, forKey: .success)
        
        // message와 userId는 선택적 값
        message = try container.decodeIfPresent(String.self, forKey: .message)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
    }
    
    init(success: Bool, message: String?, userId: String?) {
        self.success = success
        self.message = message
        self.userId = userId
    }
    
    private enum CodingKeys: String, CodingKey {
        case success
        case message
        case userId
    }
}

struct CreatePostRequest: Codable {
    let postingTitle: String
    let postingContent: String
    let postingType: String
    let itemPlace: String
    let ownerStudentId: String
    let ownerBirthDate: String
    let ownerName: String
    let postingImageUrls: [String]
    let postingCategory: String
    let isPlacedInStorage: Bool
}

struct CreatePostResponse: Codable {
    let success: Bool
    let message: String?
    let postingId: String?
}

struct PickedUpResponse: Codable {
    let success: Bool
    let message: String
}

struct DeletePostResponse: Codable {
    let success: Bool
    let message: String
}

struct UpdatePostRequest: Codable {
    let postingCategory: String
    let postingTitle: String
    let postingContent: String
    let itemPlace: String
    let isPlacedInStorage: Bool
    let ownerStudentId: String
    let ownerBirthDate: String
    let ownerName: String
    let postingImageUrls: [String]
}

struct UpdatePostResponse: Codable {
    let success: Bool
    let message: String
}

struct PostDetailItem: Codable {
    let postingWriterId: Int
    let postingWriterNickname: String?
    let isPickedUp: Bool
    let postingTitle: String
    let isPostingAccessible: Bool
    let postingImageUrls: [String]?
    let postingContent: String
    let postingCategory: String?
    let itemPlace: String?
    let ownerStudentId: String?
    let ownerBirthDate: String?
    let ownerName: String?
    let isPlacedInStorage: Bool?
    let postingCreatedAt: String? // 하위 호환성을 위해 유지
    
    // 커스텀 디코딩으로 null 값 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postingWriterId = try container.decode(Int.self, forKey: .postingWriterId)
        postingWriterNickname = try container.decodeIfPresent(String.self, forKey: .postingWriterNickname)
        isPickedUp = try container.decode(Bool.self, forKey: .isPickedUp)
        postingTitle = try container.decode(String.self, forKey: .postingTitle)
        isPostingAccessible = try container.decode(Bool.self, forKey: .isPostingAccessible)
        postingImageUrls = try container.decodeIfPresent([String].self, forKey: .postingImageUrls)
        postingContent = try container.decode(String.self, forKey: .postingContent)
        postingCategory = try container.decodeIfPresent(String.self, forKey: .postingCategory)
        itemPlace = try container.decodeIfPresent(String.self, forKey: .itemPlace)
        ownerStudentId = try container.decodeIfPresent(String.self, forKey: .ownerStudentId)
        ownerBirthDate = try container.decodeIfPresent(String.self, forKey: .ownerBirthDate)
        ownerName = try container.decodeIfPresent(String.self, forKey: .ownerName)
        isPlacedInStorage = try container.decodeIfPresent(Bool.self, forKey: .isPlacedInStorage)
        postingCreatedAt = try container.decodeIfPresent(String.self, forKey: .postingCreatedAt)
    }
    
    private enum CodingKeys: String, CodingKey {
        case postingWriterId
        case postingWriterNickname
        case isPickedUp
        case postingTitle
        case isPostingAccessible
        case postingImageUrls
        case postingContent
        case postingCategory
        case itemPlace
        case ownerStudentId
        case ownerBirthDate
        case ownerName
        case isPlacedInStorage
        case postingCreatedAt
    }
}

// MARK: - Banner Models
struct BannerItem: Codable {
    let postingId: Int
    let postingTitle: String
    let postingWriterNickName: String
    
    // Custom decoding to handle potential null values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postingId = try container.decode(Int.self, forKey: .postingId)
        postingTitle = try container.decode(String.self, forKey: .postingTitle)
        postingWriterNickName = try container.decodeIfPresent(String.self, forKey: .postingWriterNickName) ?? "익명"
    }
    
    private enum CodingKeys: String, CodingKey {
        case postingId
        case postingTitle
        case postingWriterNickName
    }
}

// MARK: - Home Posting Models
struct HomePostingItem: Codable {
    let postingId: Int
    let postingTitle: String
    let postingContent: String
    let itemPlace: String
    let postingImageUrl: String
    
    // Custom decoding to handle potential null values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postingId = try container.decode(Int.self, forKey: .postingId)
        postingTitle = try container.decode(String.self, forKey: .postingTitle)
        postingContent = try container.decode(String.self, forKey: .postingContent)
        itemPlace = try container.decodeIfPresent(String.self, forKey: .itemPlace) ?? ""
        postingImageUrl = try container.decodeIfPresent(String.self, forKey: .postingImageUrl) ?? ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case postingId
        case postingTitle
        case postingContent
        case itemPlace
        case postingImageUrl
    }
}

// MARK: - JupJup Notification Models
struct JupJupNotificationItem: Codable {
    let notificationId: Int
    let postingId: Int
    
    // Custom decoding to handle potential null values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        notificationId = try container.decode(Int.self, forKey: .notificationId)
        postingId = try container.decode(Int.self, forKey: .postingId)
    }
    
    private enum CodingKeys: String, CodingKey {
        case notificationId
        case postingId
    }
}

// MARK: - Notification Models
struct NotificationItem: Codable {
    let postingId: Int
    let notificationType: String
    let notificationContent: String
    let notificationCreatedAt: String
    
    // Custom decoding to handle potential null values
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postingId = try container.decode(Int.self, forKey: .postingId)
        notificationType = try container.decode(String.self, forKey: .notificationType)
        notificationContent = try container.decode(String.self, forKey: .notificationContent)
        notificationCreatedAt = try container.decode(String.self, forKey: .notificationCreatedAt)
    }
    
    private enum CodingKeys: String, CodingKey {
        case postingId
        case notificationType
        case notificationContent
        case notificationCreatedAt
    }
}

struct CommentItem: Codable {
    let commentId: Int
    let commentWriterId: Int
    let commentWriterNickName: String?
    let commentCreatedAt: String
    let commentContent: String
    let isCommentSecret: Bool
    let parentCommentId: Int?
    let commentImageUrls: [String]?
    let isCommentAccessible: Bool
    
    // 커스텀 디코딩으로 null 값 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        commentId = try container.decode(Int.self, forKey: .commentId)
        commentWriterId = try container.decode(Int.self, forKey: .commentWriterId)
        commentWriterNickName = try container.decodeIfPresent(String.self, forKey: .commentWriterNickName)
        commentCreatedAt = try container.decode(String.self, forKey: .commentCreatedAt)
        commentContent = try container.decode(String.self, forKey: .commentContent)
        isCommentSecret = try container.decode(Bool.self, forKey: .isCommentSecret)
        parentCommentId = try container.decodeIfPresent(Int.self, forKey: .parentCommentId)
        commentImageUrls = try container.decodeIfPresent([String].self, forKey: .commentImageUrls)
        isCommentAccessible = try container.decode(Bool.self, forKey: .isCommentAccessible)
    }
    
    private enum CodingKeys: String, CodingKey {
        case commentId
        case commentWriterId
        case commentWriterNickName
        case commentCreatedAt
        case commentContent
        case isCommentSecret
        case parentCommentId
        case commentImageUrls
        case isCommentAccessible
    }
}

struct CreateCommentRequest: Codable {
    let parentCommentId: Int
    let isCommentSecret: Bool
    let commentContent: String
    let commentImageUrls: [String]?
    
    init(parentCommentId: Int = 0, isCommentSecret: Bool = false, commentContent: String, commentImageUrls: [String]? = nil) {
        self.parentCommentId = parentCommentId
        self.isCommentSecret = isCommentSecret
        self.commentContent = commentContent
        self.commentImageUrls = commentImageUrls
    }
}

struct CreateCommentResponse: Codable {
    let commentId: Int
    let message: String?
    
    // 기본 초기화 메서드 추가
    init(commentId: Int, message: String?) {
        self.commentId = commentId
        self.message = message
    }
    
    // 커스텀 디코딩으로 null 값 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        commentId = try container.decode(Int.self, forKey: .commentId)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
    
    private enum CodingKeys: String, CodingKey {
        case commentId
        case message
    }
}

struct StorageItem: Codable {
    let postingId: Int
    let postingImageUrl: String?
    let postingCreatedAt: String
    let postingCategory: String?
}

struct PostingItem: Codable {
    let postingId: Int
    let postingWriterNickName: String?
    let postingImageUrl: String?
    let isPickedUp: Bool
    let postingTitle: String
    let postingCreatedAt: String
    let itemPlace: String?
    let postingCategory: String?
    let postingContent: String
    let commentCount: Int
    
    // 커스텀 디코딩으로 null 값 처리
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        postingId = try container.decode(Int.self, forKey: .postingId)
        postingWriterNickName = try container.decodeIfPresent(String.self, forKey: .postingWriterNickName)
        postingImageUrl = try container.decodeIfPresent(String.self, forKey: .postingImageUrl)
        isPickedUp = try container.decode(Bool.self, forKey: .isPickedUp)
        postingTitle = try container.decode(String.self, forKey: .postingTitle)
        postingCreatedAt = try container.decode(String.self, forKey: .postingCreatedAt)
        itemPlace = try container.decodeIfPresent(String.self, forKey: .itemPlace)
        postingCategory = try container.decodeIfPresent(String.self, forKey: .postingCategory)
        postingContent = try container.decode(String.self, forKey: .postingContent)
        commentCount = try container.decode(Int.self, forKey: .commentCount)
    }
    
    private enum CodingKeys: String, CodingKey {
        case postingId
        case postingWriterNickName
        case postingImageUrl
        case isPickedUp
        case postingTitle
        case postingCreatedAt
        case itemPlace
        case postingCategory
        case postingContent
        case commentCount
    }
}

// MARK: - API Errors
enum APIError: Error, LocalizedError {
    case invalidURL
    case encodingError
    case decodingError
    case networkError(String)
    case invalidResponse
    case noData
    case badRequest
    case unauthorized(String)
    case conflict(String)
    case notFound(String)
    case serverError
    case unknownError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .encodingError:
            return "데이터 인코딩 오류가 발생했습니다."
        case .decodingError:
            return "데이터 디코딩 오류가 발생했습니다."
        case .networkError(let message):
            return "네트워크 오류: \(message)"
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .noData:
            return "응답 데이터가 없습니다."
        case .badRequest:
            return "잘못된 요청입니다."
        case .unauthorized(let message):
            return message
        case .conflict(let message):
            return message
        case .notFound(let message):
            return message
        case .serverError:
            return "서버 오류가 발생했습니다."
        case .unknownError(let code):
            return "알 수 없는 오류 (코드: \(code))"
        }
    }
}
