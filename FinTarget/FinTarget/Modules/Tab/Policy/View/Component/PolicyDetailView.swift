//
//  PolicyDetailView.swift
//  FinTarget
//
//  Created by 박병선 on 10/28/26.
//
import SwiftUI

struct PolicyDetailView: View {

    @ObservedObject var viewModel: PolicyViewModel

    let policy: PolicyDTO

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 28) {

                // MARK: - 정책 기본 정보

                VStack(alignment: .leading, spacing: 16) {

                    Text(policyTypeTitle)
                        .font(.PretendardMedium(size: 13))
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)

                    Text(policy.name)
                        .font(.PretendardBold(size: 26))
                        .foregroundColor(.black)

                    Text(policy.description ?? "정책 설명이 제공되지 않았습니다.")
                        .font(.PretendardMedium(size: 15))
                        .foregroundColor(.gray)
                        .lineSpacing(5)
                }

                Divider()

                // MARK: - 정책 지원 정보

                VStack(alignment: .leading, spacing: 20) {

                    Text("지원 정보")
                        .font(.PretendardBold(size: 20))

                    VStack(spacing: 20) {

                        infoRow(
                            title: "지원 나이",
                            value: formatAgeRange(
                                minAge: policy.minAge,
                                maxAge: policy.maxAge
                            )
                        )

                        Divider()

                        infoRow(
                            title: "소득 기준",
                            value: formatAmount(policy.incomeLimit)
                        )

                        Divider()

                        infoRow(
                            title: "지원 혜택",
                            value: formatAmount(policy.benefitAmount)
                        )
                    }
                    .padding(20)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }

                // MARK: - AI 신청 가능 여부 안내 (추후 구현)

                VStack(alignment: .leading, spacing: 16) {

                    Text("AI 신청 가능 여부 안내")
                        .font(.PretendardBold(size: 20))

                    Text("내 정보를 기준으로 이 정책을 신청할 수 있는지 확인해 보세요.")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)

                    Button {
                        // TODO: AI 신청 가능 여부 API 연결
                    } label: {

                        Text("AI 신청 가능 여부 확인하기")
                            .font(.PretendardBold(size: 15))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .disabled(true)
                    .opacity(0.5)

                    Text("AI 안내 기능은 추후 제공될 예정입니다.")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                }
                .padding(20)
                .background(Color(.systemGray6))
                .cornerRadius(16)

            }
            .padding(20)
        }
        .safeAreaInset(edge: .bottom) {

            // MARK: - 스크랩 버튼

            Button {
                toggleScrap()
            } label: {

                HStack(spacing: 8) {

                    Image(
                        systemName: isScrapped
                        ? "bookmark.fill"
                        : "bookmark"
                    )

                    Text(
                        isScrapped
                        ? "스크랩 취소하기"
                        : "관심 정책 스크랩하기"
                    )
                }
                .font(.PretendardBold(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isScrapped ? Color.gray : Color.blue)
                .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.white)
        }
        .navigationTitle("정책 상세")
        .navigationBarTitleDisplayMode(.inline)
    }


    // MARK: - 스크랩 여부

    private var isScrapped: Bool {
        viewModel.myPolicies.contains {
            $0.policy.policyId == policy.policyId
        }
    }


    // MARK: - 스크랩 정책 조회

    private var scrappedPolicy: UserPolicyDTO? {
        viewModel.myPolicies.first {
            $0.policy.policyId == policy.policyId
        }
    }


    // MARK: - 스크랩 추가 / 삭제

    private func toggleScrap() {

        if let userPolicy = scrappedPolicy {

            viewModel.deleteUserPolicy(
                userPolicyId: userPolicy.userPolicyId
            )

        } else {

            viewModel.createUserPolicy(
                policyId: policy.policyId,
                status: "INTEREST"
            )
        }
    }


    // MARK: - 지원 정보 행

    private func infoRow(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .font(.PretendardBold(size: 15))
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

        guard let amount else {
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
        maxAge: Int?
    ) -> String {

        switch (minAge, maxAge) {

        case let (min?, max?):
            return "\(min)~\(max)세"

        case let (min?, nil):
            return "\(min)세 이상"

        case let (nil, max?):
            return "\(max)세 이하"

        case (nil, nil):
            return "정보 없음"
        }
    }
}
