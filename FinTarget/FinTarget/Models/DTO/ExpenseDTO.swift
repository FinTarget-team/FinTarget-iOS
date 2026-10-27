//
//  ExpenseDTO.swift
//  FinTarget
//
//  Created by 박병선 on 9/15/26.
import Foundation


// MARK: - 지출 내역 동기화
struct ExpenseSyncRequestDTO: Encodable {
    let amount: Int /// 지출 금액
    let category: String /// 지출 카테고리
    let description: String /// 지출 설명
    let spentAt: String /// 지출 날짜 (yyyy-MM-dd)
}

struct ExpenseSyncResponseDTO: Decodable {
    let status: Int /// HTTP 상태 코드
    let message: String /// 응답 메시지
    let data: String? /// 동기화 성공 시 항상 null
}


// MARK: - 지출 내역 조회
struct ExpenseListResponseDTO: Decodable {
    let status: Int /// HTTP 상태 코드
    let message: String /// 응답 메시지
    let data: [ExpenseDTO] /// 지출 내역 목록
}

struct ExpenseDTO: Decodable, Identifiable {
    let expenseId: String /// 지출 ID
    let amount: Int /// 지출 금액
    let category: String /// 지출 카테고리
    let description: String /// 지출 설명
    let spentAt: String /// 지출 날짜
    let createdAt: String /// 지출 내역 생성 시간
    
    var id: String { expenseId } /// Identifiable 식별자
}


// MARK: - 카테고리별 지출 통계
struct ExpenseStatsResponseDTO: Decodable {
    let status: Int /// HTTP 상태 코드
    let message: String /// 응답 메시지
    let data: ExpenseStatsDataDTO /// 카테고리별 지출 통계
}

struct ExpenseStatsDataDTO: Decodable {
    let totalAmount: Int /// 기간 내 전체 지출 금액
    let byCategory: [ExpenseCategoryDTO] /// 카테고리별 지출 금액
}

struct ExpenseCategoryDTO: Decodable, Identifiable {
    let category: String /// 지출 카테고리
    let amount: Int /// 해당 카테고리의 총 지출 금액
    
    var id: String { category } /// Identifiable 식별자
}
