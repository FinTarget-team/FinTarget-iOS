//
//  AuthService.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//  카카오,네이버,애플 로그인
//  토큰재발급, 로그아웃
import Foundation
import CombineMoya
import Moya
import Combine

protocol AuthServiceProtocol {
    
    /// 카카오 로그인
    func kakaoLogin(request: KakaoLoginRequestDTO) -> AnyPublisher<SocialLoginResponseDTO, APIError>
    
    /// 네이버 로그인
    func naverLogin(request: NaverLoginRequestDTO) -> AnyPublisher<SocialLoginResponseDTO, APIError>
    
    /// 애플 로그인
    func appleLogin(request: AppleLoginRequestDTO) -> AnyPublisher<SocialLoginResponseDTO, APIError>
    
    /// 토큰 재발급
    func refreshToken(request: RefreshTokenRequestDTO) -> AnyPublisher<RefreshTokenResponseDTO, APIError>
    
    /// 로그아웃
    func logout() -> AnyPublisher<LogoutResponseDTO, APIError>
}


/// 인증 API를 사용하는 서비스
final class AuthService: AuthServiceProtocol {
    
    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<AuthRouter>
    
    init(provider: MoyaProvider<AuthRouter> = APIManager.shared.createProvider(for: AuthRouter.self))
    {
        self.provider = provider
    }
    
    // MARK: - 카카오 로그인
    func kakaoLogin(request: KakaoLoginRequestDTO) -> AnyPublisher<SocialLoginResponseDTO, APIError> {
        provider.requestResponse(AuthRouter.kakaoLogin(request: request),type: SocialLoginResponseDTO.self)
    }
    
    // MARK: - 네이버 로그인
    func naverLogin(request: NaverLoginRequestDTO) -> AnyPublisher<SocialLoginResponseDTO, APIError> {
        provider.requestResponse(AuthRouter.naverLogin(request: request), type: SocialLoginResponseDTO.self)
    }
    
    // MARK: - 애플 로그인
    func appleLogin(request: AppleLoginRequestDTO) -> AnyPublisher<SocialLoginResponseDTO, APIError> {
        provider.requestResponse(AuthRouter.appleLogin(request: request), type: SocialLoginResponseDTO.self)
    }
    
    // MARK: - 토큰 재발급
    func refreshToken(request: RefreshTokenRequestDTO) -> AnyPublisher<RefreshTokenResponseDTO, APIError> {
        provider.requestResponse(AuthRouter.refreshToken(request: request),type: RefreshTokenResponseDTO.self)
    }
    
    // MARK: - 로그아웃
    func logout() -> AnyPublisher<LogoutResponseDTO, APIError> {
        provider.requestResponse(AuthRouter.logout,type: LogoutResponseDTO.self)
    }
}
