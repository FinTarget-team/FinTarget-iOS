//
//  SimulationService.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
import Foundation
import CombineMoya
import Moya
import Combine

protocol SimulationServiceProtocol {
    
    /// 내 시뮬레이션 이력 전체 조회
    func getSimulations() -> AnyPublisher<SimulationListResponseDTO, APIError>
    
    /// 목표 달성 시뮬레이션 실행
    func runSimulation(request: RunSimulationRequestDTO) -> AnyPublisher<RunSimulationResponseDTO, APIError>
    
    /// 특정 목표의 시뮬레이션 이력 조회
    func getSimulationsByGoal(goalId: String) -> AnyPublisher<SimulationListResponseDTO, APIError>
}


/// 시뮬레이션 API를 사용하는 서비스
final class SimulationService: SimulationServiceProtocol {
    
    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<SimulationRouter>
    
    init(provider: MoyaProvider<SimulationRouter> = APIManager.shared.createProvider(for: SimulationRouter.self))
    {
        self.provider = provider
    }
    
    // MARK: - 내 시뮬레이션 이력 전체 조회
    func getSimulations() -> AnyPublisher<SimulationListResponseDTO, APIError> {
        provider.requestResponse(SimulationRouter.getSimulations, type: SimulationListResponseDTO.self)
    }
    
    // MARK: - 목표 달성 시뮬레이션 실행
    func runSimulation(request: RunSimulationRequestDTO) -> AnyPublisher<RunSimulationResponseDTO, APIError> {
        provider.requestResponse(SimulationRouter.runSimulation(request: request), type: RunSimulationResponseDTO.self)
    }
    
    // MARK: - 특정 목표의 시뮬레이션 이력 조회
    func getSimulationsByGoal(goalId: String) -> AnyPublisher<SimulationListResponseDTO, APIError> {
        provider.requestResponse(SimulationRouter.getSimulationsByGoal(goalId: goalId), type: SimulationListResponseDTO.self)
    }
}
