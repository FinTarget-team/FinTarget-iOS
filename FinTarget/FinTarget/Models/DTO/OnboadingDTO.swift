//
//  OnboadingDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
//
import Foundation

// MARK: - 온보딩 단계 조회 Response DTO
/// 온보딩 단계 조회 API의 전체 응답 DTO
struct OnboardingStepResponseDTO: Decodable {
    let status: Int /// HTTP 상태 코드
    let message: String /// 서버 응답 메시지
    let data: OnboardingStepDataDTO /// 현재 온보딩 단계 정보
}

// MARK: - 온보딩 단계 Data DTO
/// 현재 온보딩 단계의 상세 정보를 담는 DTO
struct OnboardingStepDataDTO: Decodable {
    let step: Int /// 현재 단계
    let totalSteps: Int /// 전체 온보딩 단계 수
    let progress: Double /// 온보딩 진행률
    let question: String /// 현재 단계의 질문
    let answerType: String /// 질문의 답변 타입
    let options: [OnboardingOptionDTO] /// 선택 가능한 답변 목록
    let complete: Bool /// 온보딩 완료 여부
}

// MARK: - 온보딩 답변 제출 Request DTO
/// 온보딩 질문에 대한 사용자의 답변을 서버에 전달하기 위한 DTO
struct OnboardingAnswerRequestDTO: Encodable {
    let step: Int /// 답변을 제출할 온보딩 단계
    let value: String /// 사용자가 선택하거나 입력한 답변 값
}

// MARK: - 온보딩 선택지 DTO
/// 온보딩 질문의 선택지 정보를 담는 DTO
struct OnboardingOptionDTO: Decodable, Equatable {
    let label: String /// 사용자에게 표시할 선택지 텍스트
    let value: String /// 서버에 전달되는 선택지 값
}
