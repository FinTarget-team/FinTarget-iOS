//
//  OnboardingService.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
//
import Foundation
import CombineMoya
import Moya
import Combine

protocol OnboardingServiceProtocol {
    
    /// 온보딩 단계 조회
    func getStep(step: Int) -> AnyPublisher<OnboardingStepResponseDTO, APIError>
    
    /// 온보딩 답변 제출
    func submitAnswer(request: OnboardingAnswerRequestDTO) -> AnyPublisher<OnboardingStepResponseDTO, APIError>
}


/// 온보딩 API를 사용하는 서비스
final class OnboardingService: OnboardingServiceProtocol {
    
    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<OnboardingRouter>
    
    init(
        provider: MoyaProvider<OnboardingRouter> = APIManager.shared.createProvider(
            for: OnboardingRouter.self
        )
    ) {
        self.provider = provider
    }
    
    
    // MARK: - 온보딩 단계 조회
    func getStep(step: Int) -> AnyPublisher<OnboardingStepResponseDTO, APIError> {
        provider.requestResponse(OnboardingRouter.getStep(step: step), type: OnboardingStepResponseDTO.self)
    }
    
    
    // MARK: - 온보딩 답변 제출
    func submitAnswer(request: OnboardingAnswerRequestDTO) -> AnyPublisher<OnboardingStepResponseDTO, APIError> {
        provider.requestResponse(OnboardingRouter.submitAnswer(request: request), type: OnboardingStepResponseDTO.self)
    }
}
