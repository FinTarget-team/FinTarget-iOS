//
//  AIChatWelcomSection.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//

import SwiftUI

// MARK: - AIChatWelcomeSection

/// AI 채팅 초기 환영 메시지
struct AIChatWelcomeSection: View {

    // MARK: - Body

    var body: some View {

        HStack(alignment: .top, spacing: 12) {

            // AI 아이콘
            AIChatIconView()

            // 환영 메시지
            Text(
                "안녕하세요! 이 정책의 원문을 바탕으로 궁금한 점에 답해드려요."
            )
            .font(.PretendardRegular(size: 15))
            .foregroundColor(.black)
            .lineSpacing(5)
            .padding(18)
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )
        }
    }
}


// MARK: - AIChatIconView

/// AI 채팅에서 공통으로 사용하는 아이콘
struct AIChatIconView: View {

    var body: some View {

        Image(systemName: "sparkles")
            .font(.system(size: 19, weight: .semibold))
            .foregroundColor(AIChatStyle.aiColor)
            .frame(width: 40, height: 40)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 13)
            )
            .shadow(
                color: .black.opacity(0.05),
                radius: 6,
                y: 3
            )
    }
}
