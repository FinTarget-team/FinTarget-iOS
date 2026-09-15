//
//  EditGoalView.swift
//  FinTarget
//
//  Created by 박병선 on 6/15/26.
//

import SwiftUI

struct EditGoalView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var selectedGoal = "전세/내집 마련"
    @State private var goalAmount = "1억"
    @State private var monthlySaving: Double = 500000

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 28) {

                // MARK: Header

                HStack {

                    Button {
                        dismiss()
                    } label: {
                        Text("← 뒤로")
                            .foregroundColor(.cyan)
                    }

                    Spacer()

                    Text("목표 수정")
                        .font(.PretendardBold(size: 28))

                    Spacer()

                    Button {

                    } label: {
                        Text("저장")
                            .foregroundColor(.cyan)
                    }
                }

                // MARK: 목표 유형

                Text("목표 유형")
                    .font(.PretendardBold(size: 18))

                VStack(spacing: 12) {

                    GoalTypeButton(
                        title: "전세/내집 마련",
                        selected: selectedGoal == "전세/내집 마련"
                    ) {
                        selectedGoal = "전세/내집 마련"
                    }

                    GoalTypeButton(
                        title: "비상금 마련",
                        selected: selectedGoal == "비상금 마련"
                    ) {
                        selectedGoal = "비상금 마련"
                    }

                    GoalTypeButton(
                        title: "여행/목돈 마련",
                        selected: selectedGoal == "여행/목돈 마련"
                    ) {
                        selectedGoal = "여행/목돈 마련"
                    }
                }

                // MARK: 목표 금액

                Text("목표 금액")
                    .font(.PretendardBold(size: 18))

                HStack {

                    Text(goalAmount)
                        .font(.PretendardBold(size: 40))

                    Spacer()

                    Text("원")
                        .font(.PretendardSemiBold(size: 20))
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan)
                }

                HStack(spacing: 24) {

                    amountChip("3,000만")
                    amountChip("5,000만")

                    amountChip(
                        "1억",
                        selected: true
                    )

                    amountChip("2억")
                }

                // MARK: 목표 기간

                Text("목표 기간")
                    .font(.PretendardBold(size: 18))

                HStack {

                    Text("2026. 03. 01")

                    Spacer()

                    Text("→ 2027. 03. 01")
                }
                .font(.PretendardSemiBold(size: 18))

                Text("목표 기간: 12개월 / 월 저축 필요액 483,000원")
                    .foregroundColor(.gray)

                // MARK: 월 저축 한도

                Text("월 저축 한도")
                    .font(.PretendardBold(size: 18))

                HStack {

                    Text("최소 100,000원")

                    Spacer()

                    Text("\(Int(monthlySaving).formatted())원")
                        .foregroundColor(.cyan)
                        .font(.PretendardBold(size: 18))
                }

                Slider(
                    value: $monthlySaving,
                    in: 100000...1000000,
                    step: 10000
                )
                .tint(.cyan)

                // MARK: Button

                Button {

                } label: {

                    Text("목표 업데이트")
                        .font(.PretendardBold(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.cyan)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

private struct GoalTypeButton: View {

    let title: String
    let selected: Bool
    let action: () -> Void

    var body: some View {

        Button(action: action) {

            HStack {

                Circle()
                    .fill(selected ? Color.cyan : Color.clear)
                    .frame(width: 18, height: 18)
                    .overlay {
                        Circle()
                            .stroke(Color.cyan)
                    }

                Text(title)
                    .foregroundColor(.black)

                Spacer()
            }
            .padding()
            .background(
                selected
                ? Color.cyan.opacity(0.15)
                : Color.clear
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        selected
                        ? Color.cyan
                        : Color.clear
                    )
            }
        }
    }
}

private func amountChip(
    _ title: String,
    selected: Bool = false
) -> some View {

    Text(title)
        .font(.PretendardMedium(size: 15))
        .foregroundColor(
            selected ? .cyan : .black
        )
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .overlay {
            Capsule()
                .stroke(
                    selected
                    ? Color.cyan
                    : Color.clear
                )
        }
}
