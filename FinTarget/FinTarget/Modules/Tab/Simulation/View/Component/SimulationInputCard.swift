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

                Text("월 저축액")
                    .font(.PretendardSemiBold(size: 15))

                HStack {

                    TextField(
                        "예: 500000",
                        text: $monthlySaving
                    )
                    .keyboardType(.numberPad)
                    .font(.PretendardBold(size: 20))

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

    // MARK: - 입력값 검증

    private var isValidInput: Bool {

        guard let amount = Int(monthlySaving) else {
            return false
        }

        return amount > 0
    }
}
