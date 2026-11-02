//
//  AIChatLoadingSection.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//

import SwiftUI

// MARK: - AIChatLoadingSection

/// AI 답변 생성 중 표시하는 로딩 컴포넌트
struct AIChatLoadingSection: View {

    // MARK: - Body

    var body: some View {

        HStack(alignment: .center, spacing: 12) {

            AIChatIconView()

            HStack(spacing: 10) {

                ProgressView()
                    .tint(AIChatStyle.primaryBlue)

                Text("AI가 답변을 작성하고 있어요...")
                    .font(.PretendardRegular(size: 13))
                    .foregroundColor(
                        AIChatStyle.secondaryTextColor
                    )
            }
            .padding(16)
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )

            Spacer()
        }
    }
}
