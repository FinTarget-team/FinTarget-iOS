//
//  AIChatHeaderSection.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

// MARK: - AIChatHeaderSection

/// 정책 AI 채팅 화면 상단 헤더
struct AIChatHeaderSection: View {

    // MARK: - Properties
    
    /// 현재 정책 이름
    let policyName: String

    /// 남은 질문 횟수
    let remainingTurns: Int

    /// 삭제 버튼 표시 여부
    let showDeleteButton: Bool

    /// 뒤로 가기 액션
    let onBack: () -> Void

    /// 대화 삭제 액션
    let onDelete: () -> Void


    // MARK: - Body

    var body: some View {

        HStack(spacing: 12) {

            // 뒤로 가기 버튼
            Button {
                onBack()
            } label: {

                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 32, height: 44)
            }

            // 정책 정보
            VStack(alignment: .leading, spacing: 5) {

                Text(policyName)
                    .font(.PretendardBold(size: 18))
                    .foregroundColor(.black)
                    .lineLimit(1)

                Text("AI 질문 · 정책 원문 기준")
                    .font(.PretendardRegular(size: 12))
                    .foregroundColor(
                        AIChatStyle.secondaryTextColor
                    )
            }

            Spacer(minLength: 4)

            // 남은 질문 횟수
            Text("남은 \(remainingTurns)회")
                .font(.PretendardSemiBold(size: 12))
                .foregroundColor(
                    AIChatStyle.primaryBlue
                )
                .padding(.horizontal, 11)
                .padding(.vertical, 8)
                .background(
                    AIChatStyle.primaryBlue.opacity(0.07)
                )
                .clipShape(Capsule())

            // 대화 삭제 버튼
            if showDeleteButton {

                Button {
                    onDelete()
                } label: {

                    Image(systemName: "trash")
                        .font(.system(size: 18))
                        .foregroundColor(
                            AIChatStyle.secondaryTextColor
                        )
                        .frame(width: 32, height: 44)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(AIChatStyle.backgroundColor)
    }
}
