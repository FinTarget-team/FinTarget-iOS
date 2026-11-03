//
//  SimulationHistoryDetailView'.swift
//  FinTarget
//
//  Created by 박병선 on 11/3/26.
//
import SwiftUI

struct SimulationHistoryDetailView: View {

    let simulation: SimulationDTO

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 24) {

                // MARK: - Header

                VStack(alignment: .leading, spacing: 8) {

                    Text("시뮬레이션 상세 결과")
                        .font(.PretendardBold(size: 26))

                    Text("과거에 실행한 시뮬레이션 결과입니다.")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)
                }

                // MARK: - 월 저축액

                VStack(alignment: .leading, spacing: 12) {

                    Text("월 저축액")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)

                    Text("\(simulation.monthlySaving.formatted())원")
                        .font(.PretendardBold(size: 28))
                }
                .padding(20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(16)

                // MARK: - 예상 달성일

                VStack(alignment: .leading, spacing: 20) {

                    Text("목표 달성 예상 시점")
                        .font(.PretendardBold(size: 18))

                    detailRow(
                        title: "기본 예상 달성일",
                        value: formattedDate(
                            simulation.expectedCompletionDate
                        )
                    )

                    if let policyDate = simulation.policyCompletionDate {

                        detailRow(
                            title: "정책 적용 예상 달성일",
                            value: formattedDate(policyDate)
                        )
                    }

                    detailRow(
                        title: "낙관적 예상 달성일",
                        value: formattedDate(
                            simulation.optimisticCompletionDate
                        )
                    )

                    detailRow(
                        title: "비관적 예상 달성일",
                        value: formattedDate(
                            simulation.pessimisticCompletionDate
                        )
                    )
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)

                // MARK: - 성공 확률

                VStack(alignment: .leading, spacing: 20) {

                    Text("목표 달성 확률")
                        .font(.PretendardBold(size: 18))

                    detailRow(
                        title: "기본 달성 확률",
                        value: probabilityText(
                            simulation.successProbability
                        )
                    )

                    if let policyProbability =
                        simulation.policySuccessProbability {

                        detailRow(
                            title: "정책 적용 달성 확률",
                            value: probabilityText(
                                policyProbability
                            )
                        )
                    }
                }
                .padding(20)
                .background(Color.white)
                .cornerRadius(16)
            }
            .padding(20)
            .padding(.bottom, 80)
        }
        .background(Color(.systemGray6))
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Detail Row

    private func detailRow(
        title: String,
        value: String
    ) -> some View {

        HStack {

            Text(title)
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray)

            Spacer()

            Text(value)
                .font(.PretendardBold(size: 15))
        }
    }

    // MARK: - Formatting

    private func formattedDate(_ date: String) -> String {

        date.replacingOccurrences(of: "-", with: ".")
    }

    private func probabilityText(_ value: Double) -> String {

        String(format: "%.1f%%", value * 100)
    }
}
