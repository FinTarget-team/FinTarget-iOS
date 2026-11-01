//
//  OnboardingQuestionSection.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingQuestionSection: View {

    let title: String
    let items: [OnboardingOptionDTO]

    @Binding var selectedItem: OnboardingOptionDTO?

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {

            // MARK: - Question

            OnboardingQuestionTitle(title: title)

            // MARK: - Options

            OnboardingWrapButtonView(
                items: items,
                selectedItem: $selectedItem
            )
            .padding(20)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(.horizontal, 24)
        }
    }
}
