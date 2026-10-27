//
//  GoalView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.

import SwiftUI

struct SimulationView: View {

    @State private var selectedPeriod = "6개월"

    let periods = ["6개월", "1년", "3년", "전체"]

    var body: some View {

        VStack(spacing: 0) {

            // MARK: Header

            HStack {

                Text("시뮬레이션")
                    .font(.PretendardBold(size: 32))

                Spacer()

                Button {

                } label: {
                    Image(systemName: "info.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            ScrollView(showsIndicators: false) {

                VStack(spacing: 20) {

                    // MARK: D-Day Card

                    VStack(alignment: .leading, spacing: 20) {

                        VStack(alignment: .leading, spacing: 8) {

                            Text("전세 자금 1억 목표까지")
                                .font(.PretendardMedium(size: 14))
                                .foregroundColor(.gray)

                            HStack {

                                Text("D-247")
                                    .font(.PretendardBold(size: 50))

                                Spacer()

                                Text("정책 적용 시 43일 단축")
                                    .font(.PretendardSemiBold(size: 14))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(20)
                            }

                            Text("목표일 2027년 1월 8일")
                                .font(.PretendardMedium(size: 15))
                                .foregroundColor(.gray)
                        }

                        Divider()

                        Text("이 D-Day가 산출된 근거")
                            .font(.PretendardBold(size: 18))

                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 12
                        ) {

                            metricCard(
                                title: "현재 누적 자산",
                                value: "3,240만원",
                                sub: "목표 대비 32%"
                            )

                            metricCard(
                                title: "월 납입금",
                                value: "55만원",
                                sub: "소득 대비 34%"
                            )

                            metricCard(
                                title: "정책 월 기여분",
                                value: "+8.3만원",
                                sub: "청년도약계좌 기준",
                                valueColor: .blue
                            )

                            metricCard(
                                title: "예상 월 순저축",
                                value: "63.3만원",
                                sub: "납입금 + 정책 혜택"
                            )
                        }

                        VStack(alignment: .leading, spacing: 8) {

                            HStack {

                                Text("목표 달성률")
                                    .font(.PretendardMedium(size: 14))

                                Spacer()

                                Text("63% (정책 적용 시)")
                                    .font(.PretendardBold(size: 14))
                                    .foregroundColor(.blue)
                            }

                            ProgressView(value: 0.63)
                                .tint(.blue)

                            HStack(spacing: 16) {

                                Label(
                                    "정책 미적용 52%",
                                    systemImage: "circle.fill"
                                )

                                Label(
                                    "정책 적용 63%",
                                    systemImage: "circle.fill"
                                )
                            }
                            .font(.PretendardMedium(size: 12))
                            .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)

                    // MARK: 기간 선택

                    HStack(spacing: 0) {

                        ForEach(periods, id: \.self) { period in

                            Button {

                                selectedPeriod = period

                            } label: {

                                Text(period)
                                    .font(.PretendardSemiBold(size: 16))
                                    .foregroundColor(
                                        selectedPeriod == period
                                        ? .blue
                                        : .gray
                                    )
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        selectedPeriod == period
                                        ? Color.white
                                        : Color.clear
                                    )
                            }
                        }
                    }
                    .padding(4)
                    .background(Color(.systemGray5))
                    .cornerRadius(14)

                    // MARK: 그래프 카드

                    VStack(alignment: .leading, spacing: 20) {

                        HStack {

                            Text("자산 성장 시뮬레이션")
                                .font(.PretendardBold(size: 22))

                            Spacer()

                            HStack(spacing: 12) {

                                Label("정책 적용", systemImage: "circle.fill")
                                    .foregroundColor(.blue)

                                Label("기본", systemImage: "circle.fill")
                                    .foregroundColor(.gray.opacity(0.4))
                            }
                            .font(.PretendardMedium(size: 12))
                        }

                        ZStack {

                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.05))

                            VStack {

                                Spacer()

                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 60))
                                    .foregroundColor(.blue)

                                Text("그래프 영역")
                                    .foregroundColor(.gray)

                                Spacer()
                            }
                        }
                        .frame(height: 220)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)

                    // MARK: 시나리오 비교

                    VStack(alignment: .leading, spacing: 16) {

                        Text("시나리오 비교")
                            .font(.PretendardBold(size: 22))

                        HStack(spacing: 12) {

                            scenarioCard(
                                title: "현재",
                                amount: "55만원/월",
                                dday: "D-247",
                                selected: false
                            )

                            scenarioCard(
                                title: "+10% 절약",
                                amount: "60만원/월",
                                dday: "D-218 (-29일)",
                                selected: true
                            )

                            scenarioCard(
                                title: "+20% 절약",
                                amount: "66만원/월",
                                dday: "D-193 (-54일)",
                                selected: false
                            )
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color(.systemGray6))
    }
}

// MARK: Metric Card

private func metricCard(
    title: String,
    value: String,
    sub: String,
    valueColor: Color = .primary
) -> some View {

    VStack(alignment: .leading, spacing: 8) {

        Text(title)
            .font(.PretendardMedium(size: 13))
            .foregroundColor(.gray)

        Text(value)
            .font(.PretendardBold(size: 26))
            .foregroundColor(valueColor)

        Text(sub)
            .font(.PretendardMedium(size: 12))
            .foregroundColor(.gray)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding()
    .background(Color(.systemGray6))
    .cornerRadius(12)
}

// MARK: Scenario Card

private func scenarioCard(
    title: String,
    amount: String,
    dday: String,
    selected: Bool
) -> some View {

    VStack(spacing: 8) {

        Text(title)
            .font(.PretendardMedium(size: 13))
            .foregroundColor(selected ? .blue : .gray)

        Text(amount)
            .font(.PretendardBold(size: 18))

        Text(dday)
            .font(.PretendardMedium(size: 12))
            .foregroundColor(selected ? .blue : .gray)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
    .background(Color.white)
    .overlay(
        RoundedRectangle(cornerRadius: 12)
            .stroke(
                selected ? Color.blue : Color.gray.opacity(0.2),
                lineWidth: selected ? 2 : 1
            )
    )
    .cornerRadius(12)
}//


#Preview{
    SimulationView()
}
