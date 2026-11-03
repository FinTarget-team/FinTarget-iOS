//
//  OnboardingView.swift
//  FinTarget
//
//  Created by 박병선 on 5/8/26.
//
import SwiftUI

struct OnboardingView: View {

    // MARK: - Properties

    @StateObject private var viewModel: OnboardingViewModel
    @State private var selectedBirthYear: Int = 2000

    private let primaryColor = Color(
        red: 0.20,
        green: 0.39,
        blue: 0.91
    )

    // MARK: - Init

    init(sessionManager: SessionManager) {
        _viewModel = StateObject(
            wrappedValue: OnboardingViewModel(
                sessionManager: sessionManager
            )
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header

            if !viewModel.isCompleted {
                OnboardingProgressHeader(
                    currentStep: viewModel.stepData?.step ?? 1,
                    totalSteps: viewModel.stepData?.totalSteps ?? 7,
                    backAction: {
                        viewModel.goToPreviousStep()
                    }
                )
            }

            // MARK: - Conversation

            conversationView

            // MARK: - Bottom Input Area

            if !viewModel.isCompleted {
                bottomInputView
            }
        }
        .background(Color(.systemGray6))
        .onChange(of: viewModel.selectedOption) { _, newValue in
            guard newValue != nil,
                  !viewModel.isLoading,
                  viewModel.stepData?.answerType == "CHIP" else {
                return
            }

            viewModel.submitAnswer()
        }
        .task {
            if viewModel.stepData == nil && !viewModel.isCompleted {
                viewModel.fetchStep()
            }
        }
    }

    // MARK: - Conversation View

    private var conversationView: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // MARK: - Previous Answers

                    ForEach(viewModel.answeredQuestions) { item in
                        VStack(spacing: 16) {
                            OnboardingQuestionTitle(
                                title: item.question
                            )

                            OnboardingAnswerBubble(
                                text: item.answer
                            )
                        }
                    }

                    // MARK: - Current Question

                    if !viewModel.isCompleted,
                       let stepData = viewModel.stepData {

                        currentQuestionView(stepData: stepData)
                            .id("currentQuestion")
                    }

                    // MARK: - Error Message

                    if let errorMessage = viewModel.errorMessage {
                        HStack(spacing: 8) {
                            Image(systemName: "exclamationmark.circle.fill")

                            Text(errorMessage)
                                .font(.system(size: 14))
                        }
                        .foregroundStyle(.red)
                        .padding(.horizontal, 24)
                    }

                    // MARK: - Loading

                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    }

                    // MARK: - Complete

                    if viewModel.isCompleted {
                        completedView
                    }
                }
                .padding(.vertical, 30)
            }
            .onChange(of: viewModel.stepData?.step) { _, _ in
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        proxy.scrollTo(
                            "currentQuestion",
                            anchor: .top
                        )
                    }
                }
            }
        }
    }

    // MARK: - Current Question View

    @ViewBuilder
    private func currentQuestionView(
        stepData: OnboardingStepDataDTO
    ) -> some View {

        VStack(alignment: .leading, spacing: 24) {

            // MARK: - Question Bubble

            OnboardingQuestionTitle(
                title: stepData.question
            )

            // MARK: - CHIP Input

            if stepData.answerType == "CHIP" {

                if stepData.step == 5 {

                    // 거주 지역 선택

                    OnboardingRegionSelectionView(
                        items: stepData.options,
                        selectedItem: $viewModel.selectedOption
                    )

                } else {

                    // 직업 / 소득 / 주택 보유 여부 선택

                    OnboardingWrapButtonView(
                        items: stepData.options,
                        selectedItem: $viewModel.selectedOption
                    )
                    .padding(20)
                    .background(.white)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 24)
                    )
                    .padding(.horizontal, 24)
                }

            // MARK: - TEXT Input

            } else if stepData.answerType == "TEXT" {

                OnboardingTextInputView(
                    text: $viewModel.textInput
                )

            // MARK: - NUMBER Input

            } else if stepData.answerType == "NUMBER" {

                if stepData.step == 7 {

                    OnboardingAmountInputView(
                        amount: $viewModel.numberInput
                    )
                }
            }
        }
    }

    // MARK: - Bottom Input View

    @ViewBuilder
    private var bottomInputView: some View {

        if let stepData = viewModel.stepData {

            // MARK: - Birth Year Picker

            if stepData.answerType == "NUMBER",
               stepData.step == 2 {

                VStack(spacing: 0) {

                    OnboardingBirthYearPicker(
                        selectedYear: $selectedBirthYear
                    )

                    OnboardingButtonSection(
                        action: {
                            viewModel.numberInput = String(selectedBirthYear)
                            viewModel.submitAnswer()
                        },
                        isEnabled: !viewModel.isLoading
                    )
                    .padding(.bottom, 24)
                    .background(.white)
                }

            // MARK: - Name Input Button

            } else if stepData.answerType == "TEXT" {

                OnboardingButtonSection(
                    action: {
                        viewModel.submitAnswer()
                    },
                    isEnabled: !viewModel.textInput
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty && !viewModel.isLoading
                )
                .padding(.vertical, 16)

            // MARK: - Goal Amount Button

            } else if stepData.answerType == "NUMBER",
                      stepData.step == 7 {

                OnboardingButtonSection(
                    action: {
                        viewModel.submitAnswer()
                    },
                    isEnabled: !viewModel.numberInput.isEmpty
                        && !viewModel.isLoading
                )
                .padding(.vertical, 16)
            }
        }
    }

    // MARK: - Completed View

    private var completedView: some View {
        VStack(spacing: 24) {

            // MARK: - Complete Icon

            Circle()
                .stroke(primaryColor, lineWidth: 2)
                .frame(width: 90, height: 90)
                .overlay {
                    Image(systemName: "checkmark")
                        .font(.title)
                        .foregroundStyle(primaryColor)
                }

            // MARK: - Complete Message

            VStack(spacing: 8) {
                Text("분석 완료!")
                    .font(.title2.bold())

                Text("입력하신 정보를 바탕으로\n맞춤 정책과 자산 시뮬레이션을 준비했어요.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
            }

            // MARK: - Answer Summary
            VStack(alignment: .leading, spacing: 12) {
                ForEach(viewModel.answeredQuestions) { item in
                    OnboardingSummaryRow(
                        title: item.question,
                        value: formattedAnswer(item)
                    )
                }
            }
            .padding()
            .background(.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 20)
            )

            // MARK: - Move To Home

            Button {
                viewModel.moveToHome()
            } label: {
                Text("내 플랜 보러가기")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(primaryColor)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 18)
                    )
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - 온보딩 답변 포맷팅

    private func formattedAnswer(_ item: OnboardingAnswer) -> String {

        // 목표 금액 질문인지 확인
        if item.question.contains("목표 자산") ||
           item.question.contains("목표 금액") {

            // 숫자만 추출
            let numbers = item.answer.filter {
                $0.isASCII && $0.isNumber
            }

            // 천 단위 쉼표 적용
            if let amount = Int(numbers) {
                return "\(amount.formatted())원"
            }
        }

        // 나머지 답변은 기존 값 유지
        return item.answer
    }
}
