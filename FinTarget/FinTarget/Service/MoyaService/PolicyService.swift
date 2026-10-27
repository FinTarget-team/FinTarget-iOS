//
//  PolicyService.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.

import Foundation
import CombineMoya
import Moya
import Combine

protocol PolicyServiceProtocol {
    
    /// 내가 스크랩한 정책 목록 조회
    func getMyPolicies() -> AnyPublisher<GetMyPoliciesResponseDTO, APIError>
    
    /// 정책 스크랩 등록(관리자전용)
    func createUserPolicy(request: CreateUserPolicyRequestDTO) -> AnyPublisher<CreateUserPolicyResponseDTO, APIError>
    
    /// 나에게 맞는 정책 목록 조회
    func getMatchingPolicies(policyType: String?) -> AnyPublisher<GetMatchingPoliciesResponseDTO, APIError>
    
    /// 정책 스크랩 삭제
    func deleteUserPolicy(userPolicyId: String) -> AnyPublisher<DeleteUserPolicyResponseDTO, APIError>
}


/// 정책 관련 API를 사용하는 서비스
final class PolicyService: PolicyServiceProtocol {
    
    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<PolicyRouter>
    
    init(provider: MoyaProvider<PolicyRouter> = APIManager.shared.createProvider(for: PolicyRouter.self)) {
        self.provider = provider
    }
    
    
    // MARK: - 내가 스크랩한 정책 목록 조회
    func getMyPolicies() -> AnyPublisher<GetMyPoliciesResponseDTO, APIError> {
        return provider.requestResponse(.getMyPolicies, type: GetMyPoliciesResponseDTO.self)
    }
    
    
    // MARK: - 정책 스크랩 등록(관리자 전용)
    func createUserPolicy(request: CreateUserPolicyRequestDTO) -> AnyPublisher<CreateUserPolicyResponseDTO, APIError> {
        return provider.requestResponse(.createUserPolicy(request: request), type: CreateUserPolicyResponseDTO.self)
    }
    
    
    // MARK: - 나에게 맞는 정책 목록 조회
    func getMatchingPolicies(policyType: String?) -> AnyPublisher<GetMatchingPoliciesResponseDTO, APIError> {
        return provider.requestResponse(.getMatchingPolicies(policyType: policyType), type: GetMatchingPoliciesResponseDTO.self)
    }
    
    
    // MARK: - 정책 스크랩 삭제
    func deleteUserPolicy(userPolicyId: String) -> AnyPublisher<DeleteUserPolicyResponseDTO, APIError> {
        return provider.requestResponse(.deleteUserPolicy(userPolicyId: userPolicyId), type: DeleteUserPolicyResponseDTO.self)
    }
}
