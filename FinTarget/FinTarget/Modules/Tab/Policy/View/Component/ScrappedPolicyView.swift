//
//  ScrappedPolicyView.swift
//  FinTarget
//
//  Created by 박병선 on 10/1/26.
import SwiftUI

struct ScrappedPolicyView: View {
    
    @ObservedObject var viewModel: PolicyViewModel
    @State private var selectedPolicy: PolicyDTO?
    @State private var showPolicyDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - 로딩
            
            if viewModel.isLoading {
                Spacer()
                
                ProgressView("스크랩한 정책을 불러오는 중...")
                
                Spacer()
                
            // MARK: - 에러
            
            } else if let errorMessage = viewModel.errorMessage {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "exclamationmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("스크랩한 정책을 불러오지 못했어요")
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
            
            } else if viewModel.myPolicies.isEmpty {
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("스크랩한 정책이 없어요")
                        .font(.PretendardBold(size: 18))
                    
                    Text("관심 있는 정책을 스크랩해보세요")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
            // MARK: - 스크랩 정책 목록
            
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("스크랩한 정책 \(viewModel.myPolicies.count)개")
                            .font(.PretendardMedium(size: 15))
                            .foregroundColor(.gray)
                        
                        ForEach(
                            viewModel.myPolicies,
                            id: \.userPolicyId
                        ) { userPolicy in

                            MatchingPolicyCardView(
                                policy: userPolicy.policy,
                                isScrapped: true,
                                onScrapTapped: {
                                    deleteScrap(
                                        userPolicyId: userPolicy.userPolicyId
                                    )
                                },
                                onDetailTapped: {
                                    selectedPolicy = userPolicy.policy
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
        .navigationTitle("스크랩한 정책")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            loadPolicies()
        }
    }
    
    
    // MARK: - 스크랩 정책 목록 조회
    private func loadPolicies() {
        viewModel.getMyPolicies()
    }
    
    
    // MARK: - 스크랩 정책 삭제
    private func deleteScrap(userPolicyId: String) {
        viewModel.deleteUserPolicy(
            userPolicyId: userPolicyId
        )
    }
}
