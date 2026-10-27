//
//  GoalService.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import Foundation
import CombineMoya
import Moya
import Combine

protocol GoalServiceProtocol {
    
    /// 내 목표 조회
    func getGoal() -> AnyPublisher<GetGoalResponseDTO, APIError>
    
    /// 목표 생성
    func createGoal(request: CreateGoalRequestDTO) -> AnyPublisher<CreateGoalResponseDTO, APIError>
    
    /// 목표 수정
    func updateGoal(request: UpdateGoalRequestDTO) -> AnyPublisher<UpdateGoalResponseDTO, APIError>
    
    /// 목표 삭제
    func deleteGoal() -> AnyPublisher<DeleteGoalResponseDTO, APIError>
}

/// 목표 API를 사용하는 서비스
final class GoalService: GoalServiceProtocol {
    
    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<GoalRouter>
    
    init(provider: MoyaProvider<GoalRouter> = APIManager.shared.createProvider(for: GoalRouter.self)) {
        self.provider = provider
    }
    
    // MARK: - 내 목표 조회
    
    func getGoal() -> AnyPublisher<GetGoalResponseDTO, APIError> {
        provider.requestResponse(.getGoal, type: GetGoalResponseDTO.self)
    }
    
    // MARK: - 목표 생성
    
    func createGoal(request: CreateGoalRequestDTO) -> AnyPublisher<CreateGoalResponseDTO, APIError> {
        provider.requestResponse(.createGoal(request: request), type: CreateGoalResponseDTO.self)
    }
    
    // MARK: - 목표 수정
    
    func updateGoal(request: UpdateGoalRequestDTO) -> AnyPublisher<UpdateGoalResponseDTO, APIError> {
        provider.requestResponse(.updateGoal(request: request), type: UpdateGoalResponseDTO.self)
    }
    
    // MARK: - 목표 삭제
    
    func deleteGoal() -> AnyPublisher<DeleteGoalResponseDTO, APIError> {
        provider.requestResponse(.deleteGoal, type: DeleteGoalResponseDTO.self)
    }
}
