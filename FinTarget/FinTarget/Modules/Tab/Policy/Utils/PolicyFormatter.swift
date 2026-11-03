//
//  PolicyFormatter.swift
//  FinTarget
//
//  Created by 박병선 on 11/3/26.
//
import Foundation

enum PolicyFormatter {

    // MARK: - 금액 포맷팅

    static func formatAmount(_ amount: Int?) -> String {

        guard let amount else {
            return "정보 없음"
        }

        if amount >= 10_000 {
            return "\(amount / 10_000)만원"
        }

        return "\(amount)원"
    }

    // MARK: - 지원 나이 포맷팅

    static func formatAgeRange(
        minAge: Int?,
        maxAge: Int?,
        ageCondition: String? = nil
    ) -> String {

        // 1. 숫자형 나이 조건 우선 사용
        switch (minAge, maxAge) {

        case let (min?, max?):
            return "\(min)~\(max)세"

        case let (min?, nil):
            return "\(min)세 이상"

        case let (nil, max?):
            return "\(max)세 이하"

        case (nil, nil):
            break
        }

        // 2. 숫자 조건이 없으면 문자열 조건 사용
        if let ageCondition,
           !ageCondition.trimmingCharacters(
               in: .whitespacesAndNewlines
           ).isEmpty {

            return ageCondition
        }

        // 3. 둘 다 없는 경우
        return "정보 없음"
    }

    // MARK: - 소득 기준 포맷팅

    static func formatIncomeCondition(
        incomeCondition: String?,
        incomeLimit: Int?
    ) -> String {

        if let incomeCondition,
           !incomeCondition.trimmingCharacters(
               in: .whitespacesAndNewlines
           ).isEmpty {

            return incomeCondition
        }

        if let incomeLimit {
            return "\(incomeLimit.formatted())원 이하"
        }

        return "정보 없음"
    }

    // MARK: - 지원 혜택 포맷팅

    static func formatSupportContent(
        supportContent: String?,
        benefitAmount: Int?
    ) -> String {

        if let supportContent,
           !supportContent.trimmingCharacters(
               in: .whitespacesAndNewlines
           ).isEmpty {

            return supportContent
        }

        if let benefitAmount {
            return "\(benefitAmount.formatted())원"
        }

        return "정보 없음"
    }
    
    // MARK: - 정책 유형 포맷팅

    static func formatPolicyType(_ policyType: String) -> String {

        switch policyType {

        case "HOUSING":
            return "주거"

        case "FINANCE_WELFARE":
            return "금융 · 복지"

        case "STARTUP":
            return "창업"

        case "ETC":
            return "기타"

        default:
            return policyType
        }
    }
}
