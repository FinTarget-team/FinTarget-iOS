//
//  AuthRouter.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import Foundation
import Moya

// 인증관련 API Router
enum AuthRouter {
    // MARK: -로그인
    case kakaoLogin(request: KakaoLoginRequestDTO) /// 카카오 로그인
    case naverLogin(request: NaverLoginRequestDTO) /// 네이버 로그인
    case appleLogin(request: AppleLoginRequestDTO) /// 애플 로그인
    
    // MARK: -토큰
    case refreshToken(request: RefreshTokenRequestDTO)
    
    // MARK: -로그아웃
    case logout
}

extension AuthRouter: APITargetType {
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            return "/auth/kakao/login/token"
        case .naverLogin:
            return "/auth/naver/login"
        case .appleLogin:
            return "/auth/apple/login"
            
        case .refreshToken:
            return "/auth/token/refresh"
            
        case .logout:
            return "/auth/logout"

        }
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin, .naverLogin, .appleLogin, .refreshToken, .logout:
            return .post
            
        }
    }
    
    var task: Task {
        switch self {

        case let .kakaoLogin(request):
            return .requestJSONEncodable(request)

        case let .naverLogin(request):
            return .requestJSONEncodable(request)

        case let .appleLogin(request):
            return .requestJSONEncodable(request)

        case let .refreshToken(request):
             return .requestJSONEncodable(request)
            
        case let .logout:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
