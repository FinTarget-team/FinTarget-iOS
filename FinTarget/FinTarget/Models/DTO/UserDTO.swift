//
//  UserDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.

import Foundation

// MARK: - 내 프로필 조회

/// 내 프로필 조회 응답 DTO
struct UserProfileResponseDTO: Decodable {
    let status: Int ///HTTP 상태 코드
    let message: String /// 서버 메세지 
    let data: UserProfileDataDTO
}

/// 사용자 프로필 데이터 DTO
struct UserProfileDataDTO: Decodable {
    let userId: String /// 사용자ID
    let name: String?
    let email: String?
    let region: String?
    let provider: String /// 수정할 사용자 거주 지역
    let ageGroup: String?
    let employmentType: String?
    let incomeBracket: String?
}

// MARK: - 프로필 수정
/// 프로필 수정 요청 DTO
struct UpdateUserProfileRequestDTO: Encodable {
    let name: String?
    let region: String?
    let ageGroup: String?
    let employmentType: String?
    let incomeBracket: String?
}

// MARK: - 회원 탈퇴

/// 회원탈퇴 응답 DTO
struct WithdrawResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: String? /// 회원 탈퇴 성공 시 null

}
