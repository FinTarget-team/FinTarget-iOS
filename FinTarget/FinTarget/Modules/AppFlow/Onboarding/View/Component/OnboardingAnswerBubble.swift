//
//  OnboardingAnswerBubble.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingAnswerBubble: View {

    let text: String

    var body: some View {
        HStack {
            Spacer(minLength: 60)

            Text(text)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 16)
                .background(Color(red: 0.20, green: 0.39, blue: 0.91))
                .clipShape(
                    UnevenRoundedRectangle(
                        topLeadingRadius: 24,
                        bottomLeadingRadius: 24,
                        bottomTrailingRadius: 6,
                        topTrailingRadius: 24
                    )
                )
        }
        .padding(.horizontal, 24)
    }
}
