//
//  OnboardingRouer.swift
//  FinTarget
//
//  Created by 박병선 on 9/14/26.
//
import Foundation
import Moya

// MARK: - Onboarding Router

/// 온보딩 관련 API를 정의하는 Router
enum OnboardingRouter {
    
    /// 온보딩 단계 조회
    /// - Parameter : step(조회할 온보딩 단계)
    case getStep(step: Int)
    /// 온보딩 답변 제출
    case submitAnswer(request: OnboardingAnswerRequestDTO)
}


// MARK: - TargetType

extension OnboardingRouter: TargetType {
    ///서버 URL
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }
    
    
    /// API Endpoint
    var path: String {
        switch self {
        case .getStep:
            return "/onboarding/step"
            
        case .submitAnswer:
            return "/onboarding/answer"
        }
    }
    
    
    /// HTTP Method
    var method: Moya.Method {
        switch self {
        case .getStep:
            return .get
            
        case .submitAnswer:
            return .post
        }
    }
    
    
    /// API 요청 Task
    var task: Task {
        switch self {
            
        case .getStep(let step):
            return .requestParameters(
                parameters: [
                    "step": step
                ],
                encoding: URLEncoding.queryString
            )
            
        case .submitAnswer(let request):
                    return .requestJSONEncodable(request)
        }
    }
    
    
    /// 요청 Header
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
