//
//  ExpenseService.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.

import Foundation
import CombineMoya
import Moya
import Combine

protocol ExpenseServiceProtocol {
    /// 지출 내역 동기화
    func syncExpenses(request: [ExpenseSyncRequestDTO]) -> AnyPublisher<ExpenseSyncResponseDTO, APIError>
    
    /// 전체 지출 내역 조회
    func getExpenses() -> AnyPublisher<ExpenseListResponseDTO, APIError>
    
    /// 기간별 지출 내역 조회
    func getExpensesByPeriod(start: String, end: String) -> AnyPublisher<ExpenseListResponseDTO, APIError>
    
    
    /// 기간별 카테고리 통계 조회
    func getExpenseStats(start: String, end: String) -> AnyPublisher<ExpenseStatsResponseDTO, APIError>
}

final class ExpenseService: ExpenseServiceProtocol {
    
    let provider: MoyaProvider<ExpenseRouter>
    
    init(provider: MoyaProvider<ExpenseRouter> = APIManager.shared.createProvider(for: ExpenseRouter.self)) {
        self.provider = provider
    }
    
    // MARK: - 지출 내역 동기화
    func syncExpenses(request: [ExpenseSyncRequestDTO]) -> AnyPublisher<ExpenseSyncResponseDTO, APIError> {
        provider.requestResponse(.syncExpenses(request: request), type: ExpenseSyncResponseDTO.self)
    }
    
    // MARK: - 전체 지출 내역 조회
    func getExpenses() -> AnyPublisher<ExpenseListResponseDTO, APIError> {
        provider.requestResponse(.getExpenses, type: ExpenseListResponseDTO.self)
    }
    
    // MARK: - 기간별 지출 내역 조회
    func getExpensesByPeriod(start: String, end: String) -> AnyPublisher<ExpenseListResponseDTO, APIError> {
        provider.requestResponse(.getExpensesByPeriod(start: start, end: end), type: ExpenseListResponseDTO.self)
    }
    
    // MARK: - 기간별 카테고리 통계 조회
    func getExpenseStats(start: String, end: String) -> AnyPublisher<ExpenseStatsResponseDTO, APIError> {
        provider.requestResponse(.getExpenseStats(start: start, end: end), type: ExpenseStatsResponseDTO.self)
    }
}
