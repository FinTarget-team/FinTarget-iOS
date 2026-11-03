//
//  SimulationInputCard.swift
//  FinTarget
//
//  Created by 박병선 on 10/28/26.
//
import SwiftUI

struct SimulationInputCard: View {

    // MARK: - Properties

    @Binding var monthlySaving: String

    let isLoading: Bool
    let onRunSimulation: () -> Void

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            // MARK: - Title

            VStack(alignment: .leading, spacing: 8) {

                Text("목표 달성 시뮬레이션")
                    .font(.PretendardBold(size: 22))

                Text("매월 저축할 금액을 입력해 목표 달성 시점을 확인해 보세요.")
                    .font(.PretendardMedium(size: 14))
                    .foregroundColor(.gray)
            }

            // MARK: - 월 저축액 입력

            VStack(alignment: .leading, spacing: 10) {

                Text("월 저축액을 입력해주세요")
                    .font(.PretendardMedium(size: 15))

                HStack {

                    TextField(
                        "매월 저축할 금액을 입력해주세요",
                        text: $monthlySaving
                    )
                    .keyboardType(.numberPad)
                    .font(.PretendardBold(size: 20))
                    .onChange(of: monthlySaving) { _, newValue in
                        formatMonthlySaving(newValue)
                    }

                    Text("원")
                        .font(.PretendardMedium(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(16)
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }

            // MARK: - 시뮬레이션 실행 버튼

            Button {
                onRunSimulation()
            } label: {

                HStack(spacing: 8) {

                    if isLoading {

                        ProgressView()
                            .tint(.white)

                        Text("시뮬레이션 실행 중...")

                    } else {

                        Image(systemName: "chart.line.uptrend.xyaxis")

                        Text("시뮬레이션 실행하기")
                    }
                }
                .font(.PretendardBold(size: 16))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    isValidInput && !isLoading
                    ? Color.blue
                    : Color.gray
                )
                .cornerRadius(12)
            }
            .disabled(!isValidInput || isLoading)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
    }

    // MARK: - 입력 금액 포맷팅

    private func formatMonthlySaving(_ value: String) {

        // 숫자만 추출
        let numbers = value.filter { $0.isNumber }

        // 빈 값이면 초기화
        guard !numbers.isEmpty else {
            monthlySaving = ""
            return
        }

        // Int 변환
        guard let amount = Int(numbers) else {
            return
        }

        // 천 단위 콤마 적용
        let formatted = amount.formatted()

        // 값이 달라졌을 때만 업데이트
        if monthlySaving != formatted {
            monthlySaving = formatted
        }
    }

    // MARK: - 입력값 검증

    private var isValidInput: Bool {

        let normalized = monthlySaving
            .replacingOccurrences(of: ",", with: "")

        guard let amount = Int(normalized) else {
            return false
        }

        return amount > 0
    }
}
