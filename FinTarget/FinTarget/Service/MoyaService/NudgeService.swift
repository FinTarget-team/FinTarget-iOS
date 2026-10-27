//
//  NudgeService.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.
import Foundation
import CombineMoya
import Moya
import Combine

protocol NudgeServiceProtocol {
    /// 알림 목록 조회
    func getNudges() -> AnyPublisher<NudgeListResponseDTO, APIError>

    /// 알림 읽음 처리
    func readNudge(nudgeId: String) -> AnyPublisher<NudgeReadResponseDTO, APIError>
    
    /// 지정한 넛지 삭제
    func deleteNudge(nudgeId: String) -> AnyPublisher<NudgeDeleteResponseDTO, APIError>
}

final class NudgeService: NudgeServiceProtocol {

    let provider: MoyaProvider<NudgeRouter>

    init(provider: MoyaProvider<NudgeRouter> = APIManager.shared.createProvider(for: NudgeRouter.self)) {
        self.provider = provider
    }

    // MARK: - 알림 목록 조회
    func getNudges() -> AnyPublisher<NudgeListResponseDTO, APIError> {
        provider.requestResponse(.getNudges, type: NudgeListResponseDTO.self)
    }

    // MARK: - 알림 읽음 처리
    func readNudge(nudgeId: String) -> AnyPublisher<NudgeReadResponseDTO, APIError> {
        provider.requestResponse(.readNudge(nudgeId: nudgeId), type: NudgeReadResponseDTO.self)
    }
    
    // MARK: - 알림 삭제 처리
    func deleteNudge(nudgeId: String) -> AnyPublisher<NudgeDeleteResponseDTO, APIError> {
        provider.requestResponse(.deleteNudge(nudgeId: nudgeId), type: NudgeDeleteResponseDTO.self )
    }

}
