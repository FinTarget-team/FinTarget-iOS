//
//  NudgeDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.

import Foundation

//////////////////////////////////////////////////////////
// MARK: - Nudge List
//////////////////////////////////////////////////////////

/// 알림 목록 조회 응답 DTO
struct NudgeListResponseDTO: Decodable {
    /// HTTP 상태 코드
    let status: Int
    /// 서버 응답 메시지
    let message: String
    /// 알림 목록 데이터
    let data: NudgeListDataDTO
}

/// 알림 목록 데이터 DTO
struct NudgeListDataDTO: Decodable {
    /// 알림 목록
    let nudges: [NudgeDTO]
    /// 읽지 않은 알림 수 (배지 표시용)
    let unreadCount: Int
}

/// 개별 알림 DTO
struct NudgeDTO: Decodable {
    let nudgeId: String /// 알림 ID
    let type: String /// 알림 유형
    let message: String /// 알림 메시지
    let relatedCategory: String? /// 알림과 관련된 지출 카테고리
    let savedAmount: Int? /// 실천 시 절약 가능한 금액
    let dDayShortenIfActed: Int? /// 행동 실천 시 목표 달성일 단축 일수
    let createdAt: String /// 알림 생성 시간
    let isRead: Bool /// 알림 읽음 여부
    
    enum CodingKeys: String, CodingKey {
        case nudgeId
        case type
        case message
        case relatedCategory
        case savedAmount
        case dDayShortenIfActed
        case createdAt
        case isRead = "read"
    }
}

// MARK: - 넛지 읽음 처리 DTO
struct NudgeReadResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: EmptyData? // 성공 시 응답 데이터 반환 안 함
}

// MARK: - 넛지 삭제
struct NudgeDeleteResponseDTO: Decodable {
    let status: Int
    let message: String
    let data: EmptyData? // 성공 시 별도의 응답 데이터를 반환하지 않음
}
