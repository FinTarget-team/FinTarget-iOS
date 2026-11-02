//
//  AIChatBubble.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//

import SwiftUI

// MARK: - AIChatBubble

/// 정책 AI 채팅 메시지 말풍선
struct AIChatBubble: View {

    // MARK: - Properties

    /// 표시할 채팅 메시지
    let message: AIChatMessage


    // MARK: - Body

    var body: some View {

        Group {

            if message.isUser {

                userMessageView

            } else {

                aiMessageView
            }
        }
    }


    // MARK: - User Message

    /// 사용자 메시지 말풍선
    private var userMessageView: some View {

        HStack {

            Spacer(minLength: 60)

            Text(message.content)
                .font(.PretendardRegular(size: 15))
                .foregroundColor(.white)
                .lineSpacing(5)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(
                    AIChatStyle.primaryBlue
                )
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 20,
                        bottomLeadingRadius: 20,
                        bottomTrailingRadius: 20,
                        topTrailingRadius: 5
                    )
                )
        }
    }


    // MARK: - AI Message

    /// AI 답변 말풍선
    private var aiMessageView: some View {

        HStack(alignment: .top, spacing: 12) {

            AIChatIconView()

            VStack(alignment: .leading, spacing: 10) {

                Text(message.content)
                    .font(.PretendardRegular(size: 15))
                    .foregroundColor(.black)
                    .lineSpacing(6)
                    .padding(18)
                    .frame(
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .background(.white)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 5,
                            bottomLeadingRadius: 20,
                            bottomTrailingRadius: 20,
                            topTrailingRadius: 20
                        )
                    )

                // 정책 원문 정보 부족 표시
                if message.sourceLimited {

                    Text("원문에 없는 내용")
                        .font(.PretendardSemiBold(size: 12))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        .background(
                            Color.orange.opacity(0.12)
                        )
                        .clipShape(Capsule())
                }
            }
        }
    }
}
