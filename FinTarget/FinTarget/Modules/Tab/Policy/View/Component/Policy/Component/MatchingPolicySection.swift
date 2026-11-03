//
//  MatchingPolicySection.swift
//  FinTarget
//
//  Created by 박병선 on 11/3/26.
//
import SwiftUI

// MARK: - 맞춤 정책 카드
struct MatchingPolicySection: View {
    
    let policy: PolicyDTO
    let isScrapped: Bool
    let onScrapTapped: () -> Void
    let onDetailTapped: () -> Void
    
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
            
            /*
            // MARK: - 정책 설명
            Text(policy.description ?? "정책 설명이 제공되지 않았습니다.")
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray)
                .lineSpacing(4)
            */
            
            Divider()
            

            // MARK: - 지원 정보
            HStack(alignment: .top, spacing: 12) {

                policyInfoItem(
                    title: "지원 나이",
                    value: formatAgeRange(
                        minAge: policy.minAge,
                        maxAge: policy.maxAge,
                        ageCondition: policy.ageCondition
                    )
                )

                policyInfoItem(
                    title: "소득 기준",
                    value: policy.incomeCondition ?? "정보 없음"
                )

                policyInfoItem(
                    title: "지원 혜택",
                    value: policy.supportContent ?? "정보 없음"
                )
            }
            
            // MARK: - 상세보기
            HStack {
                Spacer()
                
                Button {
                    onDetailTapped()
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
    private func formatAmount(_ amount: Int?) -> String {
        guard let amount = amount else {
            return "정보 없음"
        }
        if amount >= 10_000 {
            return "\(amount / 10_000)만원"
        }
        return "\(amount)원"
    }
    
    // MARK: - 지원 나이 포맷팅
    private func formatAgeRange(
        minAge: Int?,
        maxAge: Int?,
        ageCondition: String?
    ) -> String {

        // 1. 숫자 형태의 나이 정보가 있는 경우
        switch (minAge, maxAge) {

        case let (min?, max?):
            return "만 \(min)세 ~ 만 \(max)세"

        case let (min?, nil):
            return "만 \(min)세 이상"

        case let (nil, max?):
            return "만 \(max)세 이하"

        case (nil, nil):
            break
        }

        // 2. 숫자 정보가 없으면 문자열 조건 확인
        if let condition = ageCondition?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !condition.isEmpty {

            return condition
        }

        // 3. 모든 정보가 없는 경우
        return "제한 없음"
    }
}

