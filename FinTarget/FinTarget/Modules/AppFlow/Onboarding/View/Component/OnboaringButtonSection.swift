
//  OnboaringButtonSection.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingButtonSection: View {

    let action: () -> Void
    var isEnabled: Bool = true

    // MARK: - Body

    var body: some View {
        Button {
            action()
        } label: {
            Text("다음")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    isEnabled
                    ? Color(red: 0.20, green: 0.39, blue: 0.91)
                    : Color.gray.opacity(0.4)
                )
                .clipShape(RoundedRectangle(cornerRadius: 18))
        }
        .disabled(!isEnabled)
        .padding(.horizontal, 24)
    }
}
