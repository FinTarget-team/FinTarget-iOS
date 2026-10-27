//
//  MatchingPolicyView.swift
//  FinTarget
//
//  Created by 박병선 on 10/10/26.
//
import SwiftUI

struct MatchingPolicyView: View {
    
    @ObservedObject var viewModel: PolicyViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            if viewModel.isLoading {
                Spacer()
                
                ProgressView("맞춤 정책을 찾는 중...")
                
                Spacer()
                
            } else if let errorMessage = viewModel.errorMessage {
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
                
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        Text("내 조건에 맞는 정책 \(viewModel.matchingPolicies.count)개를 찾았어요")
                            .font(.PretendardMedium(size: 15))
                            .foregroundColor(.gray)
                        
                        ForEach(viewModel.matchingPolicies, id: \.policyId) { policy in
                            MatchingPolicyCardView(
                                policy: policy,
                                isScrapped: isScrapped(policy),
                                onScrapTapped: {
                                    toggleScrap(policy)
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
        .task {
            loadPolicies()
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


// MARK: - 맞춤 정책 카드

struct MatchingPolicyCardView: View {
    
    let policy: PolicyDTO
    let isScrapped: Bool
    let onScrapTapped: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // MARK: - 정책 유형 + 스크랩
            
            HStack {
                Text(policyTypeTitle)
                    .font(.PretendardMedium(size: 12))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
                
                Button {
                    onScrapTapped()
                } label: {
                    Image(systemName: isScrapped ? "bookmark.fill" : "bookmark")
                        .font(.system(size: 20))
                        .foregroundColor(isScrapped ? .orange : .gray)
                }
            }
            
            
            // MARK: - 정책명
            
            Text(policy.name)
                .font(.PretendardBold(size: 21))
                .foregroundColor(.black)
            
            
            // MARK: - 정책 설명
            
            Text(policy.description)
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray)
                .lineSpacing(4)
            
            
            Divider()
            
            
            // MARK: - 지원 정보
            
            HStack(spacing: 0) {
                policyInfoItem(
                    title: "지원 나이",
                    value: "\(policy.minAge)~\(policy.maxAge)세"
                )
                
                Spacer()
                
                policyInfoItem(
                    title: "소득 기준",
                    value: formatAmount(policy.incomeLimit)
                )
                
                Spacer()
                
                policyInfoItem(
                    title: "지원 혜택",
                    value: formatAmount(policy.benefitAmount)
                )
            }
            
            
            // MARK: - 상세보기
            
            HStack {
                Spacer()
                
                Button {
                    // 추후 상세 화면 연결
                } label: {
                    HStack(spacing: 4) {
                        Text("자세히 보기")
                            .font(.PretendardBold(size: 14))
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .bold))
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .cornerRadius(16)
    }
    
    
    // MARK: - 정책 정보
    
    private func policyInfoItem(
        title: String,
        value: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.PretendardMedium(size: 12))
                .foregroundColor(.gray)
            
            Text(value)
                .font(.PretendardBold(size: 14))
                .foregroundColor(.black)
        }
    }
    
    
    // MARK: - 정책 유형
    
    private var policyTypeTitle: String {
        switch policy.policyType {
        case "HOUSING":
            return "주거"
            
        case "FINANCE_WELFARE":
            return "금융 · 복지"
            
        case "STARTUP":
            return "창업"
            
        case "ETC":
            return "기타"
            
        default:
            return policy.policyType
        }
    }
    
    
    // MARK: - 금액 변환
    
    private func formatAmount(_ amount: Int) -> String {
        if amount >= 10_000 {
            return "\(amount / 10_000)만원"
        }
        
        return "\(amount)원"
    }
}
