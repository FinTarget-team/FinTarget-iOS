//
//  SimulationHistoryCard.swift
//  FinTarget
//
//  Created by 박병선 on 11/3/26.
//
import SwiftUI

struct SimulationHistoryCard: View {

    let simulation: SimulationDTO

    var body: some View {

        VStack(alignment: .leading, spacing: 16) {

            // MARK: - 실행 날짜

            HStack {

                Text(formattedCreatedAt)
                    .font(.PretendardMedium(size: 13))
                    .foregroundColor(.gray)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.gray)
            }

            Divider()

            // MARK: - 월 저축액

            HStack {

                Text("월 저축액")
                    .font(.PretendardMedium(size: 14))
                    .foregroundColor(.gray)

                Spacer()

                Text("\(simulation.monthlySaving.formatted())원")
                    .font(.PretendardBold(size: 15))
                    .foregroundColor(.black)
            }

            // MARK: - 예상 달성일

            HStack {

                Text("예상 목표 달성일")
                    .font(.PretendardMedium(size: 14))
                    .foregroundColor(.gray)

                Spacer()

                Text(formattedCompletionDate)
                    .font(.PretendardBold(size: 15))
                    .foregroundColor(.blue)
            }

            // MARK: - 목표 달성 확률

            HStack {

                Text("목표 달성 확률")
                    .font(.PretendardMedium(size: 14))
                    .foregroundColor(.gray)

                Spacer()

                Text(
                    "\(Int(simulation.successProbability * 100))%"
                )
                .font(.PretendardBold(size: 15))
                .foregroundColor(.black)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
    }

    // MARK: - 날짜 포맷

    private var formattedCreatedAt: String {

        guard let createdAt = simulation.createdAt else {
            return "날짜 정보 없음"
        }

        return String(createdAt.prefix(10))
            .replacingOccurrences(of: "-", with: ".")
    }

    private var formattedCompletionDate: String {

        simulation.expectedCompletionDate
            .replacingOccurrences(of: "-", with: ".")
    }
}
