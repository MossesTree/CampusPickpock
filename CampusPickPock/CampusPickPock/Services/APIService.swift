//
//  APIService.swift
//  campusPickPock
//
//  Created by Kim Kyengdong on 10/21/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private let baseURL = "http://lostnfound-env.eba-2wmsjk7u.ap-northeast-2.elasticbeanstalk.com" 
    private let session = URLSession.shared
    
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
                        do {
                            let registerResponse = try JSONDecoder().decode(RegisterResponse.self, from: data)
                            completion(.success(registerResponse))
                        } catch {
                            completion(.failure(.decodingError))
                        }
                    } else {
                        completion(.failure(.noData))
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
        case .serverError:
            return "서버 오류가 발생했습니다."
        case .unknownError(let code):
            return "알 수 없는 오류 (코드: \(code))"
        }
    }
}
