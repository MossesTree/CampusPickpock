//
//  CommentAPIService.swift
//  CampusPickPock
//
//  Created by AI Assistant
//

import Foundation

// MARK: - Comment API Models
struct UpdateCommentRequest: Codable {
    let isCommentSecret: Bool
    let commentContent: String
    let commentImageUrls: [String]
    
    init(isCommentSecret: Bool, commentContent: String, commentImageUrls: [String] = []) {
        self.isCommentSecret = isCommentSecret
        self.commentContent = commentContent
        self.commentImageUrls = commentImageUrls
    }
}

struct UpdateCommentResponse: Codable {
    let success: Bool
    let message: String
    
    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}

struct DeleteCommentResponse: Codable {
    let success: Bool
    let message: String
    
    init(success: Bool, message: String) {
        self.success = success
        self.message = message
    }
}

// MARK: - Comment API Service
extension APIService {
    
    // MARK: - Update Comment
    func updateComment(commentId: Int, updateData: UpdateCommentRequest, completion: @escaping (Result<UpdateCommentResponse, APIError>) -> Void) {
        
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
        
        let updateCommentURL = "\(baseURL)/comment/update/\(commentId)"
        print("📝 댓글 수정 API 호출: \(updateCommentURL)")
        print("📝 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: updateCommentURL) else {
            print("❌ 잘못된 URL: \(updateCommentURL)")
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
        
        print("🚀 댓글 수정 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 댓글 수정 응답 수신")
                
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
                    print("✅ 댓글 수정 성공")
                    let updateResponse = UpdateCommentResponse(success: true, message: "댓글이 성공적으로 수정되었습니다.")
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
                    print("❌ 댓글을 찾을 수 없음")
                    completion(.failure(.notFound("댓글을 찾을 수 없습니다.")))
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
    
    // MARK: - Delete Comment
    func deleteComment(commentId: Int, completion: @escaping (Result<DeleteCommentResponse, APIError>) -> Void) {
        
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
        
        let deleteCommentURL = "\(baseURL)/comment/delete/\(commentId)"
        print("🗑️ 댓글 삭제 API 호출: \(deleteCommentURL)")
        print("🗑️ 토큰 검증 완료: \(token.prefix(20))...")
        
        guard let url = URL(string: deleteCommentURL) else {
            print("❌ 잘못된 URL: \(deleteCommentURL)")
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // 인증 토큰 추가
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔐 인증 토큰 추가됨")
        
        print("🚀 댓글 삭제 요청 시작")
        session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                print("📥 댓글 삭제 응답 수신")
                
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
                    print("✅ 댓글 삭제 성공")
                    let deleteResponse = DeleteCommentResponse(success: true, message: "댓글이 성공적으로 삭제되었습니다.")
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
                    print("❌ 댓글을 찾을 수 없음")
                    completion(.failure(.notFound("댓글을 찾을 수 없습니다.")))
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

