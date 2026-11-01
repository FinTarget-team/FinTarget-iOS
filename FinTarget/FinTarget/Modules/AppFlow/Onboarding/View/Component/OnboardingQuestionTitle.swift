//
//  Untitled.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingQuestionTitle: View {

    let title: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {

            // MARK: - AI Icon

            RoundedRectangle(cornerRadius: 16)
                .fill(.white)
                .frame(width: 54, height: 54)
                .overlay {
                    Image(systemName: "scope")
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundStyle(.cyan)
                }
                .shadow(color: .black.opacity(0.04), radius: 8, y: 4)

            // MARK: - Question Bubble

            Text(title)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(Color.primary)
                .lineSpacing(5)
                .padding(.horizontal, 20)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 6,
                        bottomLeadingRadius: 24,
                        bottomTrailingRadius: 24,
                        topTrailingRadius: 24
                    )
                )
        }
        .padding(.horizontal, 24)
    }
}
