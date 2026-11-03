//
//  MatchingPolicyView.swift
//  FinTarget
//
//  Created by 박병선 on 10/10/26.
//
import SwiftUI

struct MatchingPolicyView: View {
    
    @ObservedObject var viewModel: PolicyViewModel
    @State private var selectedPolicy: PolicyDTO?
    @State private var showPolicyDetail = false

    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - 로딩
            if viewModel.isMatchingPoliciesLoading
                || !viewModel.hasLoadedMatchingPolicies {
                
                Spacer()
                
                ProgressView("맞춤 정책을 찾는 중...")
                
                Spacer()
                
            // MARK: - 에러
            } else if let errorMessage = viewModel.matchingPoliciesError {
                
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("정책을 불러오지 못했어요")
                        .font(.PretendardBold(size: 18))
                    
                    Text(errorMessage)
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)
                    
                    Button {
                        loadPolicies()
                    } label: {
                        Text("다시 시도")
                            .font(.PretendardBold(size: 14))
                    }
                }
                
                Spacer()
                
            // MARK: - 빈 목록
            } else if viewModel.matchingPolicies.isEmpty {
                
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("조건에 맞는 정책이 없어요")
                        .font(.PretendardBold(size: 18))
                    
                    Text("현재 조건에 해당하는 정책을 찾지 못했어요")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
            // MARK: - 맞춤 정책 목록
            } else {
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("내 조건에 맞는 정책 \(viewModel.matchingPolicies.count)개를 찾았어요")
                            .font(.PretendardMedium(size: 15))
                            .foregroundColor(.gray)
                        
                        ForEach(
                            viewModel.matchingPolicies,
                            id: \.policyId
                        ) { policy in
                            
                            MatchingPolicySection(
                                policy: policy,
                                isScrapped: isScrapped(policy),
                                onScrapTapped: {
                                    toggleScrap(policy)
                                },
                                onDetailTapped: {
                                    selectedPolicy = policy
                                    showPolicyDetail = true
                                }
                            )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationTitle("맞춤 정책")
        .navigationBarTitleDisplayMode(.inline)
        
        // MARK: - 화면 진입 시 API 호출
        .task {
            loadPolicies()
        }
        
        // MARK: - 정책 상세 화면 이동
        .navigationDestination(isPresented: $showPolicyDetail) {
            if let selectedPolicy {
                PolicyDetailView(
                    viewModel: viewModel,
                    policy: selectedPolicy
                )
            }
        }
    }
    
    
    // MARK: - 정책 목록 조회
    private func loadPolicies() {
        viewModel.getMatchingPolicies()
        viewModel.getMyPolicies()
    }
    
    
    // MARK: - 스크랩 여부
    private func isScrapped(_ policy: PolicyDTO) -> Bool {
        viewModel.myPolicies.contains {
            $0.policy.policyId == policy.policyId
        }
    }
    
    
    // MARK: - 스크랩 정책 찾기
    private func scrappedPolicy(for policy: PolicyDTO) -> UserPolicyDTO? {
        viewModel.myPolicies.first {
            $0.policy.policyId == policy.policyId
        }
    }
    
    
    // MARK: - 정책 스크랩 추가 / 삭제
    private func toggleScrap(_ policy: PolicyDTO) {
        
        // 이미 스크랩된 정책인 경우 → 스크랩 삭제
        if let userPolicy = scrappedPolicy(for: policy) {
            
            viewModel.deleteUserPolicy(
                userPolicyId: userPolicy.userPolicyId
            )
            
        // 스크랩되지 않은 정책인 경우 → 스크랩 추가
        } else {
            
            viewModel.createUserPolicy(
                policyId: policy.policyId,
                status: "INTEREST"
            )
        }
    }
}

