//
//  UserDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.

import Foundation

// MARK: - 내 프로필 조회

/// 내 프로필 조회 응답 DTO, 프로필 수정응답 DTO
struct UserProfileResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: UserProfileDataDTO
}

struct UserProfileDataDTO: Decodable {
    let userId: String
    let name: String?
    let email: String?
    let region: String?
    let provider: String
    let birthYear: Int?
    let employmentType: String?
    let incomeBracket: String?
    let housingStatus: String?
    let onboardingCompleted: Bool?
}


// MARK: - 프로필 수정 요청 DTO

struct UpdateUserProfileRequestDTO: Encodable {
    let name: String?
    let email: String?
    let region: String?
    let birthYear: Int?
    let employmentType: String?
    let incomeBracket: String? /// 소득 구간
    let housingStatus: String? /// 주택 소유 여부
}

// MARK: - 회원 탈퇴

/// 회원탈퇴 응답 DTO
struct WithdrawResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: String? /// 회원 탈퇴 성공 시 null

}
