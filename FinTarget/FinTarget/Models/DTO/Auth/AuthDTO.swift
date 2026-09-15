//
//  AuthRouter.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//

import Foundation

// MARK: -Login
/// 소셜 로그인 제공자 종류
/// 서버 응답의 provider 값을 Enum으로 매핑하기 위한 타입
enum SocialProvider: String, Decodable {
    case kakao = "KAKAO"
    case naver = "NAVER"
    case apple = "APPLE"
}

/// 카카오 로그인 요청 DTO
/// Kakao SDK 로그인 성공 후 발급받은 Access Token을 서버에 전달합니다.
struct KakaoLoginRequestDTO: Encodable {
    /// Kakao SDK에서 발급받은 Access Token
    let accessToken: String
}


/// 네이버 로그인 요청 DTO
/// 네이버 로그인에 필요한 인가 코드와 state 값을 서버에 전달하는 구조체
struct NaverLoginRequestDTO: Encodable {
    let authorizationCode: String /// 네이버 로그인 후 발급받은 인가 코드
    let state: String /// CSRF 공격 방지를 위한 state 값
}

/// 애플 로그인 요청 DTO
/// 애플 로그인에 필요한 사용자 인증 정보를 서버에 전달하는 구조체
struct AppleLoginRequestDTO: Encodable {
    let identityToken: String /// Apple에서 발급한 Identity Token
    let authorizationCode: String /// Apple 로그인 후 발급받은 인가 코드
    let fullName: String /// 사용자 이름
    let email: String /// 사용자 이메일
}

/// 소셜 로그인 응답 DTO
/// 서버에서 공통으로 반환하는 로그인 응답 데이터를 담는 구조체
struct SocialLoginResponseDTO: Decodable {
    let status: Int /// HTTP 상태 코드
    let message: String /// 응답 메시지
    let data: SocialLoginDataDTO /// 로그인한 사용자 정보
}

/// 소셜 로그인 사용자 정보 DTO
/// 로그인 성공 시 반환되는 사용자 정보를 담는 구조체
struct SocialLoginDataDTO: Decodable {
    let userId: String
    let accessToken: String
    let refreshToken: String   /// Access Token 재발급에 사용할 Refresh Token
    let expiresIn: Int   /// Access Token 만료시간
    let provider: SocialProvider /// 로그인한 소셜 플랫폼
    let newUser: Bool /// 신규 회원 여부 (  true : 신규 회원, false : 기존 회원)
}

// MARK: -Token
/// 토큰 재발급 요청 DTO
/// Refresh Token을 서버에 전달하여 Access Token을 재발급받기 위한 구조체
struct RefreshTokenRequestDTO: Encodable {
    /// Refresh Token
    let refreshToken: String
}

/// 토큰 재발급 응답 DTO
/// 서버에서 반환하는 토큰 재발급 응답 데이터를 담는 구조체
struct RefreshTokenResponseDTO: Decodable {
    /// HTTP 상태 코드
    let status: Int
    /// 응답 메시지
    let message: String
    /// 재발급된 토큰 정보
    let data: RefreshTokenDataDTO
}

/// 토큰 재발급 데이터 DTO
/// 재발급된 Access Token 및 Refresh Token 정보를 담는 구조체(수정필요함)
struct RefreshTokenDataDTO: Decodable {
    /// 재발급된 Access Token
    let accessToken: String
    /// Access Token 만료 시간(초)
    let expiresIn: Int
}

// MARK: -로그아웃
struct LogoutResponseDTO: Decodable {
    let status: Int
    let message: String
    // let data: String?
}
