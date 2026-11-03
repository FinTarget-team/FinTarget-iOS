//
//  PolicyViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.

import Foundation
import Combine
import Moya

@MainActor
final class PolicyViewModel: ObservableObject {
    
    // MARK: - Published Properties

    /// 나에게 맞는 정책 목록
    @Published var matchingPolicies: [PolicyDTO] = []

    /// 내가 스크랩한 정책 목록
    @Published var myPolicies: [UserPolicyDTO] = []

    /// 맞춤 정책 조회 상태
    @Published var isMatchingPoliciesLoading = false
    @Published var matchingPoliciesError: String?


    /// 스크랩 정책 API 요청 진행 여부
    @Published var isMyPoliciesLoading = false

    /// 스크랩 정책 API 에러 메시지
    @Published var myPoliciesError: String?

    /// 스크랩 정책 API 조회 완료 여부
    @Published var hasLoadedMyPolicies = false
    
    /// 맞춤 정책 조회 완료 여부
    @Published var hasLoadedMatchingPolicies = false
    
    
    // MARK: - Properties
    
    private let policyService: PolicyServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Init
    
    init(policyService: PolicyServiceProtocol = PolicyService()) {
        self.policyService = policyService
    }
    
    // MARK: - 나에게 맞는 정책 목록 조회
    func getMatchingPolicies(policyType: String? = nil) {

        isMatchingPoliciesLoading = true
        matchingPoliciesError = nil
        hasLoadedMatchingPolicies = false

        policyService.getMatchingPolicies(policyType: policyType)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in

                guard let self else { return }

                self.isMatchingPoliciesLoading = false
                self.hasLoadedMatchingPolicies = true

                switch completion {

                case .finished:
                    print("✅ 맞춤 정책 API 요청 완료")

                case .failure(let error):
                    self.matchingPoliciesError = error.localizedDescription

                    print("❌ 맞춤 정책 조회 실패: \(error)")
                }

            } receiveValue: { [weak self] response in

                guard let self else { return }

                self.matchingPolicies = response.data

                print("✅ 맞춤 정책 조회 성공")
                print("정책 개수: \(response.data.count)")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 스크랩한 정책 목록 조회
    func getMyPolicies() {

        isMyPoliciesLoading = true
        myPoliciesError = nil
        hasLoadedMyPolicies = false

        policyService.getMyPolicies()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in

                guard let self else { return }

                // API 요청 완료
                self.isMyPoliciesLoading = false
                self.hasLoadedMyPolicies = true

                switch completion {

                case .finished:
                    print("✅ 스크랩 정책 조회 완료")

                case .failure(let error):
                    self.myPoliciesError = error.localizedDescription
                    print("❌ 스크랩 정책 조회 실패: \(error)")
                }

            } receiveValue: { [weak self] response in

                guard let self else { return }

                self.myPolicies = response.data

                print("✅ 스크랩 정책 조회 성공")
                print("스크랩 정책 개수: \(response.data.count)")
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - 정책 스크랩 등록
    func createUserPolicy(policyId: String, status: String = "INTEREST") {
        let request = CreateUserPolicyRequestDTO(
            policyId: policyId,
            status: status
        )
        
        policyService.createUserPolicy(request: request)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.myPoliciesError = error.localizedDescription
                    print("❌ 정책 스크랩 등록 실패: \(error)")
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                
                self.myPolicies.append(response.data)
                
                print("✅ 정책 스크랩 등록 성공")
                print("정책: \(response.data.policy.name)")
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - 정책 스크랩 삭제
    func deleteUserPolicy(userPolicyId: String) {
        policyService.deleteUserPolicy(userPolicyId: userPolicyId)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.myPoliciesError = error.localizedDescription
                    print("❌ 정책 스크랩 삭제 실패: \(error)")
                }
            } receiveValue: { [weak self] _ in
                guard let self else { return }
                
                self.myPolicies.removeAll {
                    $0.userPolicyId == userPolicyId
                }
                
                print("✅ 정책 스크랩 삭제 성공")
                print("삭제된 userPolicyId: \(userPolicyId)")
            }
            .store(in: &cancellables)
    }
}
