//
//  SimulationGoalCard.swift
//  FinTarget
//
//  Created by 박병선 on 10/28/26.
//
import SwiftUI

struct SimulationGoalCard: View {

    // MARK: - Properties

    let simulation: SimulationDTO
    let goalTitle: String

    // MARK: - Body

    var body: some View {

        VStack(alignment: .leading, spacing: 20) {

            VStack(alignment: .leading, spacing: 8) {

                Text("\(goalTitle) 목표까지")
                    .font(.PretendardMedium(size: 14))
                    .foregroundColor(.gray)

                HStack {

                    Text(ddayText)
                        .font(.PretendardBold(size: 50))

                    Spacer()

                    if let savedDays = policySavedDays,
                       savedDays > 0 {

                        Text("정책 적용 시 \(savedDays)일 단축")
                            .font(.PretendardSemiBold(size: 13))
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(20)
                    }
                }

                Text("예상 달성일 \(formattedDate(simulation.expectedCompletionDate))")
                    .font(.PretendardMedium(size: 15))
                    .foregroundColor(.gray)
            }

            Divider()

            // MARK: - 시뮬레이션 결과

            Text("시뮬레이션 결과")
                .font(.PretendardBold(size: 18))

            LazyVGrid(
                columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ],
                spacing: 12
            ) {

                SimulationMetricCard(
                    title: "월 저축액",
                    value: formatAmount(simulation.monthlySaving),
                    sub: "시뮬레이션 기준"
                )

                SimulationMetricCard(
                    title: "목표 달성 확률",
                    value: probabilityText,
                    sub: "목표 마감일 기준",
                    valueColor: .blue
                )

                SimulationMetricCard(
                    title: "낙관적 달성일",
                    value: formattedDate(simulation.optimisticCompletionDate),
                    sub: "낙관적 시나리오"
                )

                SimulationMetricCard(
                    title: "비관적 달성일",
                    value: formattedDate(simulation.pessimisticCompletionDate),
                    sub: "비관적 시나리오"
                )
            }

            // MARK: - 성공 확률

            VStack(alignment: .leading, spacing: 8) {

                HStack {

                    Text("목표 달성 성공 확률")
                        .font(.PretendardMedium(size: 14))

                    Spacer()

                    Text(probabilityText)
                        .font(.PretendardBold(size: 14))
                        .foregroundColor(.blue)
                }

                ProgressView(
                    value: min(max(simulation.successProbability, 0), 1)
                )
                .tint(.blue)
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(20)
    }

    // MARK: - D-Day 계산

    private var ddayText: String {

        guard let targetDate = parseDate(
            simulation.expectedCompletionDate
        ) else {
            return "D-Day 정보 없음"
        }

        let days = Calendar.current.dateComponents(
            [.day],
            from: Calendar.current.startOfDay(for: Date()),
            to: Calendar.current.startOfDay(for: targetDate)
        ).day ?? 0

        if days > 0 {
            return "D-\(days)"
        } else if days == 0 {
            return "D-Day"
        } else {
            return "D+\(abs(days))"
        }
    }

    // MARK: - 정책 적용 시 단축 일수

    private var policySavedDays: Int? {

        guard let policyDateString = simulation.policyCompletionDate,
              let expectedDate = parseDate(simulation.expectedCompletionDate),
              let policyDate = parseDate(policyDateString) else {
            return nil
        }

        return Calendar.current.dateComponents(
            [.day],
            from: policyDate,
            to: expectedDate
        ).day
    }

    // MARK: - 성공 확률

    private var probabilityText: String {
        String(
            format: "%.1f%%",
            simulation.successProbability * 100
        )
    }

    // MARK: - 날짜 변환

    private func parseDate(_ dateString: String) -> Date? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter.date(from: dateString)
    }

    // MARK: - 날짜 표시

    private func formattedDate(_ dateString: String) -> String {

        guard let date = parseDate(dateString) else {
            return dateString
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"

        return formatter.string(from: date)
    }

    // MARK: - 금액 포맷

    private func formatAmount(_ amount: Int) -> String {
        amount.formatted() + "원"
    }
}
