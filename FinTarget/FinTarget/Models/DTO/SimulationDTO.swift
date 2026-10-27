//
//  SimulationDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
import Foundation

// MARK: - 시뮬레이션 실행
/// 시뮬레이션 실행 요청 DTO
struct RunSimulationRequestDTO: Encodable {
    let goalId: String /// 목표 ID
    let monthlySaving: Int /// 월 저축액
    let userPolicyId: String? /// 적용할 사용자 정책 ID
    let annualInterestRate: Double /// 연 이자율
}

/// 시뮬레이션 실행 응답 DTO
struct RunSimulationResponseDTO: Decodable {
    let status: Int /// HTTP 상태 코드
    let message: String /// 응답 메시지
    let data: SimulationDTO /// 시뮬레이션 결과
}

// MARK: - 시뮬레이션 이력 조회

/// 시뮬레이션 이력 조회 응답 DTO
struct SimulationListResponseDTO: Decodable {
    let status: Int /// HTTP 상태 코드
    let message: String /// 응답 메시지
    let data: [SimulationDTO] /// 시뮬레이션 이력 목록
}

// MARK: - 시뮬레이션

/// 개별 시뮬레이션 DTO
struct SimulationDTO: Decodable, Identifiable {
    let simulationId: String /// 시뮬레이션 ID
    let goalId: String /// 목표 ID
    let monthlySaving: Int /// 월 저축액
    let expectedCompletionDate: String /// 예상 목표 달성일
    let policyCompletionDate: String /// 정책 적용 시 예상 목표 달성일
    let optimisticCompletionDate: String /// 낙관적 예상 목표 달성일
    let pessimisticCompletionDate: String /// 비관적 예상 목표 달성일
    let successProbability: Double /// 목표 달성 성공 확률
    let createdAt: String /// 시뮬레이션 생성 시간
    
    var id: String { simulationId } /// Identifiable ID
}
