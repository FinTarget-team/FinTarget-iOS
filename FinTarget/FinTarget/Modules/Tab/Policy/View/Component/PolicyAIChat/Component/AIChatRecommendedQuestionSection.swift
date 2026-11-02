//
//  AIChatRecommendedQuestionSection.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

// MARK: - AIRecommendedQuestionView

/// AI 채팅 추천 질문 목록
struct AIRecommendedQuestionSection: View {

    // MARK: - Properties

    /// 질문 선택 시 실행할 액션
    let onSelectQuestion: (String) -> Void

    /// 질문 버튼 비활성화 여부
    var isDisabled: Bool = false

    /// 추천 질문 목록
    private let questions = [
        "제가 신청할 수 있나요?",
        "어떤 서류가 필요한가요?",
        "신청 기간과 방법이 궁금해요",
        "지원 내용이 무엇인가요?"
    ]


    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("이렇게 물어볼 수 있어요")
                .font(.PretendardSemiBold(size: 13))
                .foregroundColor(
                    AIChatStyle.secondaryTextColor
                )
                .padding(.bottom, 4)

            ForEach(questions, id: \.self) { question in

                Button {

                    onSelectQuestion(question)

                } label: {

                    HStack {

                        Text(question)
                            .font(.PretendardRegular(size: 15))
                            .foregroundColor(.black)
                            .multilineTextAlignment(.leading)

                        Spacer()

                        Image(systemName: "chevron.right")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 18)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: 56
                    )
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    .overlay {

                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                AIChatStyle.borderColor,
                                lineWidth: 1
                            )
                    }
                }
                .disabled(isDisabled)
            }
        }
    }
}
