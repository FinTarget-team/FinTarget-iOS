//
//  OnboardingView.swift
//  FinTarget
//
//  Created by 박병선 on 5/8/26.
//
import SwiftUI

struct OnboardingView: View {
    
    @StateObject private var viewModel: OnboardingViewModel
    
    init(sessionManager: SessionManager) {
        _viewModel = StateObject(
            wrappedValue: OnboardingViewModel(
                sessionManager: sessionManager
            )
        )
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 40) {
                    
                    // MARK: - Header
                    
                    VStack(spacing: 20) {
                        HStack {
                            Button("← 뒤로") {}
                            
                            Spacer()
                            
                            Text("프로필 설정")
                                .font(.headline)
                            
                            Spacer()
                        }
                        
                        ProgressView(value: viewModel.stepData?.progress ?? 0)
                            .tint(.cyan)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top)
                    
                    // MARK: - Previous Answers
                    
                    ForEach(viewModel.answeredQuestions) { item in
                        OnboardingQuestionTitle(
                            title: item.question
                        )
                        
                        OnboardingAnswerBubble(
                            text: item.answer
                        )
                    }
                    
                    // MARK: - Current Question
                    
                    if !viewModel.isCompleted,
                       let stepData = viewModel.stepData {
                        
                        Group {
                            if stepData.answerType == "CHIP" {
                                
                                // MARK: CHIP 타입
                                
                                OnboardingQuestionSection(
                                    title: stepData.question,
                                    items: stepData.options,
                                    selectedItem: $viewModel.selectedOption
                                )
                                .onChange(of: viewModel.selectedOption) { _, newValue in
                                    guard newValue != nil else { return }
                                    viewModel.submitAnswer()
                                }
                                
                            } else if stepData.answerType == "NUMBER" {
                                
                                // MARK: NUMBER 타입
                                
                                VStack(alignment: .leading, spacing: 20) {
                                    OnboardingQuestionTitle(
                                        title: stepData.question
                                    )
                                    
                                    HStack(spacing: 12) {
                                        TextField(
                                            "목표 금액을 입력해주세요",
                                            text: $viewModel.numberInput
                                        )
                                        .keyboardType(.numberPad)
                                        .font(.body)
                                        .padding(.horizontal, 20)
                                        .frame(height: 56)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        
                                        Text("원")
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    if !viewModel.numberInput.isEmpty {
                                        OnboardingButtonSection {
                                            viewModel.submitAnswer()
                                        }
                                    }
                                }
                                .padding(.horizontal, 24)
                            }
                        }
                        .id("currentQuestion")
                    }
                    
                    // MARK: - Loading
                    
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                    
                    // MARK: - Complete
                    if viewModel.isCompleted {
                        VStack(spacing: 24) {
                            Circle()
                                .stroke(Color.cyan, lineWidth: 2)
                                .frame(width: 90, height: 90)
                                .overlay {
                                    Image(systemName: "checkmark")
                                        .font(.title)
                                        .foregroundStyle(.cyan)
                                }
                            
                            VStack(spacing: 8) {
                                Text("분석 완료!")
                                    .font(.title2.bold())
                                
                                Text("입력하신 정보를 바탕으로\n맞춤 정책과 자산 시뮬레이션을 준비했어요.")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.gray)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                ForEach(viewModel.answeredQuestions) { item in
                                    OnboardingSummaryRow(
                                        title: item.question,
                                        value: item.answer
                                    )
                                }
                            }
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            
                            Button {
                                viewModel.moveToHome()
                            } label: {
                                Text("내 플랜 보러가기")
                                    .foregroundStyle(.white)
                                    .fontWeight(.bold)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color.cyan)
                                    .clipShape(Capsule())
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                }
                .padding(.bottom, 40)
            }
            .background(Color(.systemGray6))
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
            .task {
                viewModel.fetchStep()
            }
        }
    }
}
