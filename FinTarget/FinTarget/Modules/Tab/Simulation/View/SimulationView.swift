//
//  GoalView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
import SwiftUI

struct SimulationView: View {

    // MARK: - ViewModel

    @StateObject private var viewModel = SimulationViewModel()
    @StateObject private var homeViewModel = HomeViewModel()

    // MARK: - State

    @State private var monthlySaving: String = "500000"

    // MARK: - Body

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Header

            HStack {

                Text("시뮬레이션")
                    .font(.PretendardBold(size: 32))

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 12)

            ScrollView(showsIndicators: false) {

                VStack(spacing: 20) {

                    // MARK: - 목표 조회 중

                    if homeViewModel.isLoading {

                        ProgressView("목표 정보를 불러오는 중...")
                            .padding(.top, 40)

                    // MARK: - 목표가 존재하는 경우

                    } else if let goal = homeViewModel.goal {

                        // MARK: - 시뮬레이션 입력

                        SimulationInputCard(
                            monthlySaving: $monthlySaving,
                            isLoading: viewModel.isLoading,
                            onRunSimulation: {
                                runSimulation()
                            }
                        )

                        // MARK: - 시뮬레이션 실행 중

                        if viewModel.isLoading {

                            ProgressView("시뮬레이션 실행 중...")
                                .padding()
                        }

                        // MARK: - 시뮬레이션 결과

                        if let result = viewModel.simulationResult {

                            SimulationGoalCard(
                                simulation: result,
                                goalTitle: goal.title
                            )
                        }

                        // MARK: - 에러 메시지

                        if let errorMessage = viewModel.errorMessage {

                            Text(errorMessage)
                                .font(.PretendardMedium(size: 14))
                                .foregroundColor(.red)
                        }

                    // MARK: - 목표가 없는 경우

                    } else {

                        VStack(spacing: 16) {

                            Image(systemName: "target")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)

                            Text("등록된 목표가 없습니다.")
                                .font(.PretendardBold(size: 20))

                            Text("시뮬레이션을 실행하려면\n먼저 목표를 설정해 주세요.")
                                .font(.PretendardMedium(size: 14))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 80)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color(.systemGray6))
        .onAppear {
            homeViewModel.fetchGoal()
        }
    }

    // MARK: - 시뮬레이션 실행

    private func runSimulation() {

        // 목표 정보 확인
        guard let goal = homeViewModel.goal else {
            print("❌ 목표 정보가 없습니다.")
            return
        }

        // 월 저축액 검증
        guard let amount = Int(monthlySaving),
              amount > 0 else {
            print("❌ 올바른 월 저축액을 입력해 주세요.")
            return
        }

        // 시뮬레이션 실행
        viewModel.runSimulation(
            goalId: goal.goalId,
            monthlySaving: amount
        )

        print("🚀 시뮬레이션 실행 요청")
        print("Goal ID: \(goal.goalId)")
        print("월 저축액: \(amount)")
    }
}
