//
//  UserService.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
//
import Foundation
import CombineMoya
import Moya
import Combine

protocol UserServiceProtocol {
    
    /// 내 프로필 조회
    func getMyProfile() -> AnyPublisher<UserProfileResponseDTO, APIError>
    
    /// 프로필 수정
    func updateMyProfile(request: UpdateUserProfileRequestDTO) -> AnyPublisher<UserProfileResponseDTO, APIError>
    
    /// 회원탈퇴
    func withdraw() -> AnyPublisher<WithdrawResponseDTO, APIError>
}


/// 사용자 API를 사용하는 서비스
final class UserService: UserServiceProtocol {
    
    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<UserRouter>
    
    init(provider: MoyaProvider<UserRouter> = APIManager.shared.createProvider(for: UserRouter.self))
    {
        self.provider = provider
    }
    
    // MARK: - 내 프로필 조회
    func getMyProfile() -> AnyPublisher<UserProfileResponseDTO, APIError> {
        provider.requestResponse(UserRouter.getMyProfile, type: UserProfileResponseDTO.self)
    }
    
    // MARK: - 프로필 수정
    func updateMyProfile(request: UpdateUserProfileRequestDTO) -> AnyPublisher<UserProfileResponseDTO, APIError> {
        provider.requestResponse(UserRouter.updateMyProfile(request: request), type: UserProfileResponseDTO.self)
    }
    
    // MARK: - 회원탈퇴
    func withdraw() -> AnyPublisher<WithdrawResponseDTO, APIError> {
        provider.requestResponse(UserRouter.withdraw, type: WithdrawResponseDTO.self)
    }
}
