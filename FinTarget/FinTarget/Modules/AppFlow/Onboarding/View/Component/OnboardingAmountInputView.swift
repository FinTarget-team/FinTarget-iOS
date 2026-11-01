//
//  OnboardingAmountInputView.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
/// 기존에는 숫자를 입력하는 단순 TextField였지만, 이번에는 금액을 입력하면 천 단위 쉼표가 자동으로 표시되도록 구현
import SwiftUI

struct OnboardingAmountInputView: View {

    @Binding var amount: String

    // MARK: - Properties

    private var formattedAmount: Binding<String> {
        Binding(
            get: {
                guard let number = Int(amount) else {
                    return amount
                }
                return number.formatted()
            },
            set: { newValue in
                amount = newValue.filter { $0.isASCII && $0.isNumber }
            }
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("목표 금액")
                .font(.system(size: 18, weight: .bold))

            HStack(spacing: 12) {
                TextField(
                    "목표 금액을 입력해 주세요",
                    text: formattedAmount
                )
                .keyboardType(.numberPad)
                .font(.system(size: 20, weight: .semibold))

                Text("원")
                    .font(.system(size: 17, weight: .semibold))
            }
            .padding(.horizontal, 20)
            .frame(height: 64)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))

            Text("달성하고 싶은 목표 금액을 입력해 주세요.")
                .font(.system(size: 13))
                .foregroundStyle(.gray)
        }
        .padding(24)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 24)
    }
}
