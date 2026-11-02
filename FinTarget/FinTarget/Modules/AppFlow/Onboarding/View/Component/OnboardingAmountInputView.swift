//
//  OnboardingAmountInputView.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
/// 기존에는 숫자를 입력하는 단순 TextField였지만, 이번에는 금액 입력과 동시에 천 단위 쉼표가 자동으로 표시되도록 구현
import SwiftUI

struct OnboardingAmountInputView: View {

    @Binding var amount: String

    // MARK: - Properties

    /// TextField에 표시할 금액
    @State private var displayAmount: String = ""

    /// 천 단위 쉼표 포맷터
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        return formatter
    }()

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            Text("목표 금액")
                .font(.system(size: 18, weight: .bold))

            HStack(spacing: 12) {

                TextField(
                    "목표 금액을 입력해 주세요",
                    text: $displayAmount
                )
                .keyboardType(.numberPad)
                .font(.system(size: 20, weight: .semibold))
                .onChange(of: displayAmount) { _, newValue in
                    updateAmount(newValue)
                }

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
        .onAppear {
            updateAmount(amount)
        }
        .onChange(of: amount) { _, newValue in
            let rawAmount = displayAmount.filter {
                $0.isASCII && $0.isNumber
            }

            if rawAmount != newValue {
                updateAmount(newValue)
            }
        }
    }

    // MARK: - 금액 포맷팅

    private func updateAmount(_ input: String) {

        // 1. 숫자만 추출
        let numbers = input.filter {
            $0.isASCII && $0.isNumber
        }

        // 2. 빈 문자열 처리
        guard !numbers.isEmpty else {
            if !displayAmount.isEmpty {
                displayAmount = ""
            }

            if !amount.isEmpty {
                amount = ""
            }
            return
        }

        // 3. 숫자로 변환
        guard let number = Int(numbers) else {
            return
        }

        // 4. 천 단위 쉼표 추가
        let formatted = numberFormatter.string(
            from: NSNumber(value: number)
        ) ?? numbers

        // 5. 화면 표시값 업데이트
        if displayAmount != formatted {
            displayAmount = formatted
        }

        // 6. 실제 저장값 업데이트
        let rawValue = String(number)

        if amount != rawValue {
            amount = rawValue
        }
    }
}
