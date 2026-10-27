//
//  SimulationViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.
//
import Foundation
import Combine

@MainActor
final class SimulationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// 시뮬레이션 이력
    @Published var simulations: [SimulationDTO] = []
    
    /// 시뮬레이션 실행 결과
    @Published var simulationResult: SimulationDTO?
    
    /// 로딩 상태
    @Published var isLoading: Bool = false
    
    /// 에러 메시지
    @Published var errorMessage: String?
    
    
    // MARK: - Properties
    
    /// 시뮬레이션 API 서비스
    private let simulationService: SimulationServiceProtocol
    
    /// Combine 구독 관리
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Init
    
    init(simulationService: SimulationServiceProtocol = SimulationService()) {
        self.simulationService = simulationService
    }
    
    
    // MARK: - 내 시뮬레이션 이력 전체 조회
    
    func getSimulations() {
        isLoading = true
        errorMessage = nil
        
        simulationService.getSimulations()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 시뮬레이션 이력 전체 조회 실패: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.simulations = response.data
                
                print("✅ 시뮬레이션 이력 전체 조회 성공")
                print("시뮬레이션 개수: \(response.data.count)")
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - 목표 달성 시뮬레이션 실행
    
    func runSimulation(
        goalId: String,
        monthlySaving: Int,
        userPolicyId: String?,
        annualInterestRate: Double
    ) {
        isLoading = true
        errorMessage = nil
        
        let request = RunSimulationRequestDTO(
            goalId: goalId,
            monthlySaving: monthlySaving,
            userPolicyId: userPolicyId,
            annualInterestRate: annualInterestRate
        )
        
        simulationService.runSimulation(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 시뮬레이션 실행 실패: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.simulationResult = response.data
                
                print("✅ 시뮬레이션 실행 성공")
                print("Simulation ID: \(response.data.simulationId)")
                print("예상 달성일: \(response.data.expectedCompletionDate)")
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - 특정 목표의 시뮬레이션 이력 조회
    
    func getSimulationsByGoal(goalId: String) {
        isLoading = true
        errorMessage = nil
        
        simulationService.getSimulationsByGoal(goalId: goalId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                    print("❌ 특정 목표 시뮬레이션 이력 조회 실패: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.simulations = response.data
                
                print("✅ 특정 목표 시뮬레이션 이력 조회 성공")
                print("Goal ID: \(goalId)")
                print("시뮬레이션 개수: \(response.data.count)")
            }
            .store(in: &cancellables)
    }
}
