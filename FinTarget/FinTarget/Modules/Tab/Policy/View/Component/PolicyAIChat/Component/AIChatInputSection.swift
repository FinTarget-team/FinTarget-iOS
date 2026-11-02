//
//  AIChatInputSection.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//

import SwiftUI

// MARK: - AIChatInputView

/// 정책 AI 채팅 질문 입력 영역
struct AIChatInputSection: View {

    // MARK: - Properties

    /// 사용자가 입력한 질문
    @Binding var questionText: String

    /// 남은 질문 횟수
    let remainingTurns: Int

    /// AI 답변 로딩 여부
    let isLoading: Bool

    /// 대화 삭제 진행 여부
    var isDeleting: Bool = false

    /// 질문 전송 액션
    let onSend: () -> Void

    /// 입력창 포커스 상태
    @FocusState private var isFocused: Bool


    // MARK: - Computed Properties

    /// 질문 전송 가능 여부
    private var canSend: Bool {

        let trimmedText = questionText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        return !trimmedText.isEmpty
            && trimmedText.count <= 500
            && remainingTurns > 0
            && !isLoading
            && !isDeleting
    }


    // MARK: - Body

    var body: some View {

        VStack(spacing: 12) {

            HStack(alignment: .bottom, spacing: 10) {

                // 질문 입력창
                TextField(
                    "궁금한 점을 물어보세요",
                    text: $questionText,
                    axis: .vertical
                )
                .font(.PretendardRegular(size: 15))
                .lineLimit(1...4)
                .focused($isFocused)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(
                    AIChatStyle.backgroundColor
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 26)
                )
                .overlay {

                    RoundedRectangle(cornerRadius: 26)
                        .stroke(
                            isFocused
                                ? AIChatStyle.primaryBlue
                                : AIChatStyle.borderColor,
                            lineWidth: 1.2
                        )
                }
                .disabled(
                    isLoading ||
                    isDeleting ||
                    remainingTurns == 0
                )
                .onChange(of: questionText) { _, newValue in

                    // 최대 500자 제한
                    if newValue.count > 500 {
                        questionText = String(newValue.prefix(500))
                    }
                }

                // 질문 전송 버튼
                Button {

                    isFocused = false

                    onSend()

                } label: {

                    Image(systemName: "arrow.up")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 50, height: 50)
                        .background(
                            canSend
                                ? AIChatStyle.primaryBlue
                                : Color.gray.opacity(0.35)
                        )
                        .clipShape(Circle())
                }
                .disabled(!canSend)
            }

            // 하단 안내 문구 및 글자 수
            HStack(alignment: .top, spacing: 8) {

                Text(
                    "AI 답변은 참고용이에요. 신청 전 공고 원문을 꼭 확인하세요."
                )
                .font(.PretendardRegular(size: 11))
                .foregroundColor(
                    AIChatStyle.secondaryTextColor
                )
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )

                Spacer(minLength: 4)

                Text("\(questionText.count) / 500")
                    .font(.PretendardRegular(size: 11))
                    .foregroundColor(
                        AIChatStyle.secondaryTextColor
                    )
                    .fixedSize()
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .background(.white)
    }
}
