//
//  GoalDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
//
import Foundation

// MARK: - Request DTO

/// 목표 생성 요청 DTO
struct CreateGoalRequestDTO: Encodable {
    let title: String /// 목표 제목
    let targetAmount: Int /// 목표 금액
    let currentAmount: Int /// 현재 보유 금액
    let deadline: String /// 목표 달성 기한
}

/// 목표 수정 요청 DTO
struct UpdateGoalRequestDTO: Encodable {
    let title: String /// 목표 제목
    let targetAmount: Int /// 목표 금액
    let currentAmount: Int /// 현재 보유 금액
    let deadline: String /// 목표 달성 기한
}
/*
 let request = GoalUpdateRequestDTO(
     title: title,
     targetAmount: targetAmount,
     currentAmount: currentAmount,
     deadline: deadline
 )
 
 */
// MARK: - Response DTO

/// 목표 조회 응답 DTO
struct GetGoalResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: GoalDataDTO? /// 목표 정보
}

/// 목표 생성 응답 DTO
struct CreateGoalResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: GoalDataDTO /// 생성된 목표 정보
}

/// 목표 수정 응답 DTO
struct UpdateGoalResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: GoalDataDTO /// 수정된 목표 정보
}

/// 목표 삭제 응답 DTO
struct DeleteGoalResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: String? /// 삭제 응답 데이터

}

/// 목표 데이터 DTO
struct GoalDataDTO: Decodable {
    let goalId: String /// 목표 ID
    let title: String /// 목표 제목
    let targetAmount: Int /// 목표 금액
    let currentAmount: Int /// 현재 보유 금액
    let deadline: String /// 목표 달성 기한
    let status: String /// 목표 상태
    let createdAt: String /// 목표 생성 시간
    let updatedAt: String /// 목표 수정 시간
    let progressRate: Int /// 목표 진행률
    let dDay: Int /// 목표일까지 남은 일수
}
