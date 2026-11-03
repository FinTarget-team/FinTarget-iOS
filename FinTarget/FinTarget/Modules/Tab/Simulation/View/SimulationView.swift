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

    @State private var monthlySaving: String = ""

    /// 시뮬레이션 이력 조회 범위
    @State private var selectedHistoryType: SimulationHistoryType = .currentGoal

    // MARK: - History Type

    private enum SimulationHistoryType: String, CaseIterable {

        case currentGoal = "현재 목표"
        case all = "전체 이력"
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

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

                            // MARK: - 시뮬레이션 이력

                            simulationHistorySection

                        // MARK: - 목표가 없는 경우

                        } else {

                            VStack(spacing: 16) {

                                Image(systemName: "target")
                                    .font(.system(size: 48))
                                    .foregroundColor(.gray)

                                Text("등록된 목표가 없습니다.")
                                    .font(.PretendardBold(size: 20))

                                Text(
                                    "시뮬레이션을 실행하려면\n먼저 목표를 설정해 주세요."
                                )
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

                // 목표 조회
                homeViewModel.fetchGoal()

                // 전체 시뮬레이션 이력 조회
                viewModel.getSimulations()
            }
            .onReceive(homeViewModel.$goal) { goal in

                // 목표 조회 성공 시 해당 목표의 이력 조회
                guard let goal = goal else { return }

                viewModel.getSimulationsByGoal(
                    goalId: goal.goalId
                )
            }
        }
    }

    // MARK: - 시뮬레이션 이력 영역

    private var simulationHistorySection: some View {

        VStack(alignment: .leading, spacing: 16) {

            // MARK: - Section Header

            HStack {

                Text("시뮬레이션 이력")
                    .font(.PretendardBold(size: 22))

                Spacer()
            }

            // MARK: - History Type Picker

            HStack(spacing: 8) {

                ForEach(
                    SimulationHistoryType.allCases,
                    id: \.self
                ) { type in

                    Button {

                        selectedHistoryType = type

                    } label: {

                        Text(type.rawValue)
                            .font(.PretendardMedium(size: 14))
                            .foregroundColor(
                                selectedHistoryType == type
                                ? .white
                                : .gray
                            )
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                selectedHistoryType == type
                                ? Color.blue
                                : Color.white
                            )
                            .cornerRadius(10)
                    }
                }
            }

            // MARK: - History Content

            historyContent
        }
        .padding(.top, 12)
    }

    // MARK: - 이력 목록

    @ViewBuilder
    private var historyContent: some View {

        let isLoading = selectedHistoryType == .currentGoal
            ? viewModel.isGoalSimulationsLoading
            : viewModel.isSimulationsLoading

        let error = selectedHistoryType == .currentGoal
            ? viewModel.goalSimulationsError
            : viewModel.simulationsError

        let hasLoaded = selectedHistoryType == .currentGoal
            ? viewModel.hasLoadedGoalSimulations
            : viewModel.hasLoadedSimulations

        let simulations = selectedHistoryType == .currentGoal
            ? viewModel.goalSimulations
            : viewModel.simulations

        if isLoading {

            ProgressView("시뮬레이션 이력을 불러오는 중...")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)

        } else if let error = error {

            VStack(spacing: 12) {

                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 28))
                    .foregroundColor(.orange)

                Text("시뮬레이션 이력을 불러오지 못했습니다.")
                    .font(.PretendardMedium(size: 14))

                Text(error)
                    .font(.PretendardMedium(size: 12))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 30)

        } else if hasLoaded && simulations.isEmpty {

            VStack(spacing: 12) {

                Image(systemName: "clock.arrow.circlepath")
                    .font(.system(size: 36))
                    .foregroundColor(.gray)

                Text("아직 시뮬레이션 이력이 없습니다.")
                    .font(.PretendardMedium(size: 15))
                    .foregroundColor(.gray)

                Text("시뮬레이션을 실행하면\n결과가 이곳에 저장됩니다.")
                    .font(.PretendardMedium(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)

        } else if hasLoaded {

            LazyVStack(spacing: 12) {

                ForEach(simulations) { simulation in

                    NavigationLink {

                        SimulationHistoryDetailView(
                            simulation: simulation
                        )

                    } label: {

                        SimulationHistoryCard(
                            simulation: simulation
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    // MARK: - 시뮬레이션 실행

    private func runSimulation() {

        guard let goal = homeViewModel.goal else {

            print("❌ 목표 정보가 없습니다.")
            return
        }

        let normalizedSaving = monthlySaving
            .replacingOccurrences(of: ",", with: "")

        guard let amount = Int(normalizedSaving),
              amount > 0 else {

            print("❌ 올바른 월 저축액을 입력해 주세요.")
            return
        }

        viewModel.runSimulation(
            goalId: goal.goalId,
            monthlySaving: amount
        )

        print("🚀 시뮬레이션 실행 요청")
        print("Goal ID: \(goal.goalId)")
        print("월 저축액: \(amount)")
    }
}
