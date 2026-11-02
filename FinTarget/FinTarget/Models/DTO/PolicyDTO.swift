//
//  PolicyDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.

import Foundation

// MARK: - 정책
/// 정책 정보 DTO
struct PolicyDTO: Decodable {
    let policyId: String /// 정책 ID
    let name: String /// 정책명
    let description: String? /// 정책 설명
    let minAge: Int? /// 최소 지원 나이
    let maxAge: Int? /// 최대 지원 나이
    let incomeLimit: Int? /// 소득 기준
    let benefitAmount: Int? /// 지원 금액
    let policyType: String /// 정책 유형
}


// MARK: - 내가 스크랩한 정책 목록 조회
/// 스크랩 정책 목록 조회 응답 DTO
struct GetMyPoliciesResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: [UserPolicyDTO] /// 스크랩한 정책 목록
}

/// 사용자가 스크랩한 정책 DTO
struct UserPolicyDTO: Decodable {
    let userPolicyId: String /// 사용자 정책 스크랩 ID
    let policy: PolicyDTO /// 정책 정보
    let status: String /// 정책 스크랩 상태
}


// MARK: - 정책 스크랩 등록
/// 정책 스크랩 등록 요청 DTO
struct CreateUserPolicyRequestDTO: Encodable {
    let policyId: String /// 등록할 정책 ID
    let status: String /// 정책 스크랩 상태
}

/// 정책 스크랩 등록 응답 DTO
struct CreateUserPolicyResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: UserPolicyDTO /// 등록된 정책 정보
}


// MARK: - 나에게 맞는 정책 목록 조회
/// 맞춤 정책 목록 조회 응답 DTO
struct GetMatchingPoliciesResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: [PolicyDTO] /// 조건에 맞는 정책 목록
}


// MARK: - 정책 스크랩 삭제
/// 정책 스크랩 삭제 응답 DTO
struct DeleteUserPolicyResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: String? /// 삭제 성공 시 null
}

// MARK: - 정책 AI 질문

/// 정책 AI 질문 요청 DTO
struct PolicyAIChatRequestDTO: Encodable {
    let question: String /// 사용자가 입력한 질문
    let conversationId: String? /// 기존 대화 ID (첫 질문에서는 nil)
}

/// 정책 AI 질문 응답 DTO
struct PolicyAIChatResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: PolicyAIChatDataDTO /// AI 답변 데이터
}

/// 정책 AI 답변 데이터 DTO
struct PolicyAIChatDataDTO: Decodable {
    let conversationId: String /// 현재 대화 ID
    let answer: String /// AI 답변
    let remainingTurns: Int /// 남은 질문 횟수
    let sourceLimited: Bool /// 정책 원문 정보 부족 여부
}

// MARK: - 정책 AI 대화 삭제

/// 정책 AI 대화 삭제 응답 DTO
struct DeletePolicyAIChatResponseDTO: Decodable {
    let status: Int /// 응답 상태 코드
    let message: String /// 응답 메시지
    let data: String? /// 삭제 성공 시 null
}
