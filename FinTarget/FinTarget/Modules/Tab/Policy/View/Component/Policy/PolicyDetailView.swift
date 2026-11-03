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

    @Environment(\.isTabBarHidden) private var isTabBarHidden

    // MARK: - Body

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 28) {

                // MARK: - 정책 기본 정보

                VStack(alignment: .leading, spacing: 16) {

                    Text(
                        PolicyFormatter.formatPolicyType(
                            policy.policyType
                        )
                    )
                    .font(.PretendardMedium(size: 13))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)

                    Text(policy.name)
                        .font(.PretendardBold(size: 26))
                        .foregroundColor(.black)
                        .fixedSize(horizontal: false, vertical: true)

                    // 정책 설명은 상세 화면에서만 전체 표시
                    Text(
                        policy.description
                        ?? "정책 설명이 제공되지 않았습니다."
                    )
                    .font(.PretendardMedium(size: 15))
                    .foregroundColor(.gray)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                }

                Divider()

                // MARK: - 정책 지원 정보

                VStack(alignment: .leading, spacing: 20) {

                    Text("지원 정보")
                        .font(.PretendardBold(size: 20))
                        .foregroundColor(.black)

                    VStack(spacing: 20) {

                        // 지원 나이
                        infoRow(
                            title: "지원 나이",
                            value: PolicyFormatter.formatAgeRange(
                                minAge: policy.minAge,
                                maxAge: policy.maxAge,
                                ageCondition: policy.ageCondition
                            )
                        )

                        Divider()

                        // 소득 기준
                        infoRow(
                            title: "소득 기준",
                            value: PolicyFormatter.formatIncomeCondition(
                                incomeCondition: policy.incomeCondition,
                                incomeLimit: policy.incomeLimit
                            )
                        )

                        Divider()

                        // 지원 혜택
                        infoRow(
                            title: "지원 혜택",
                            value: PolicyFormatter.formatSupportContent(
                                supportContent: policy.supportContent,
                                benefitAmount: policy.benefitAmount
                            )
                        )
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }

                // MARK: - AI 정책 도우미

                VStack(alignment: .leading, spacing: 16) {

                    // AI 도우미 제목
                    HStack(spacing: 8) {

                        Image(systemName: "sparkles")
                            .font(.system(size: 20))
                            .foregroundColor(.blue)

                        Text("AI 정책 도우미")
                            .font(.PretendardBold(size: 20))
                            .foregroundColor(.black)
                    }

                    // AI 기능 안내
                    VStack(alignment: .leading, spacing: 8) {

                        Text("이 정책, 나도 신청할 수 있을까요?")
                            .font(.PretendardBold(size: 17))
                            .foregroundColor(.black)

                        Text("신청 자격부터 지원 내용까지\n궁금한 점을 AI에게 물어보세요.")
                            .font(.PretendardMedium(size: 14))
                            .foregroundColor(.gray)
                            .lineSpacing(5)
                    }

                    // AI 채팅 화면 이동
                    NavigationLink {

                        PolicyAIChatView(
                            policyId: policy.policyId,
                            policyName: policy.name
                        )

                    } label: {

                        HStack(spacing: 8) {

                            Image(systemName: "sparkles")

                            Text("AI에게 질문하기")

                            Spacer()

                            Image(systemName: "arrow.right")
                        }
                        .font(.PretendardBold(size: 15))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .frame(height: 52)
                        .background(Color.blue)
                        .cornerRadius(12)
                    }

                    // 안내 문구
                    Text("AI 답변은 참고용이며, 정확한 내용은 공고 원문을 확인해 주세요.")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(20)
                .background(
                    LinearGradient(
                        colors: [
                            Color.blue.opacity(0.08),
                            Color.white
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            Color.blue.opacity(0.12),
                            lineWidth: 1
                        )
                }

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
                    .background(
                        isScrapped ? Color.gray : Color.blue
                    )
                    .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)

            } // VStack 종료
            .padding(20)

        } // ScrollView 종료
        .navigationTitle("정책 상세")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isTabBarHidden.wrappedValue = true
        }
        .onDisappear {
            isTabBarHidden.wrappedValue = false
        }

    } // body 종료

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

        VStack(alignment: .leading, spacing: 8) {

            Text(title)
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray)

            Text(value)
                .font(.PretendardBold(size: 15))
                .foregroundColor(.black)
                .lineSpacing(5)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

} // PolicyDetailView 종료
