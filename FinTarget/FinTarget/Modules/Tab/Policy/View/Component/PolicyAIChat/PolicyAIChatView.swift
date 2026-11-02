//
//  PolicyAIChatView.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

/// 정책 AI 채팅 메인 화면
struct PolicyAIChatView: View {

    // MARK: - Properties
    @StateObject private var viewModel: PolicyAIChatViewModel

    let policyName: String

    @Environment(\.dismiss) private var dismiss
    @Environment(\.isTabBarHidden) private var isTabBarHidden

    @State private var showDeleteAlert = false

    // MARK: - Init

    init(
        policyId: String,
        policyName: String
    ) {
        self.policyName = policyName

        _viewModel = StateObject(
            wrappedValue: PolicyAIChatViewModel(
                policyId: policyId
            )
        )
    }

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            AIChatHeaderSection(
                policyName: policyName,
                remainingTurns: viewModel.remainingTurns,
                showDeleteButton: viewModel.hasConversation,
                onBack: {
                    dismiss()
                },
                onDelete: {
                    showDeleteAlert = true
                }
            )

            Divider()

            chatContentView

            AIChatInputSection(
                questionText: $viewModel.questionText,
                remainingTurns: viewModel.remainingTurns,
                isLoading: viewModel.isLoading,
                isDeleting: viewModel.isDeleting,
                onSend: {
                    viewModel.sendMessage()
                }
            )
        }
        .background(AIChatStyle.backgroundColor)
        .navigationBarBackButtonHidden()
        .task {
            viewModel.getMyProfile()
        }
        .alert(
            "대화 내역 삭제",
            isPresented: $showDeleteAlert
        ) {

            Button("취소", role: .cancel) {}

            Button("삭제", role: .destructive) {
                viewModel.deleteConversation()
            }

        } message: {

            Text("현재 AI 채팅 내역을 삭제하시겠습니까?")
        }
        .alert(
            "안내",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: { isPresented in
                    if !isPresented {
                        viewModel.errorMessage = nil
                    }
                }
            )
        ) {

            Button("확인", role: .cancel) {
                viewModel.errorMessage = nil
            }

        } message: {

            Text(viewModel.errorMessage ?? "")
        }
    }


    // MARK: - Chat Content

    /// 채팅 메시지 영역
    private var chatContentView: some View {

        ScrollViewReader { proxy in

            ScrollView {

                VStack(spacing: 20) {

                    if viewModel.hasConversation {

                        AIUserInfoSection(
                            userProfile: viewModel.userProfile,
                            isCollapsible: true
                        )

                        LazyVStack(spacing: 20) {

                            ForEach(viewModel.messages) { message in

                                AIChatBubble(message: message)
                            }
                        }

                    } else {

                        AIChatWelcomeSection()

                        AIUserInfoSection(
                            userProfile: viewModel.userProfile,
                            isCollapsible: false
                        )

                        AIRecommendedQuestionSection(
                            onSelectQuestion: { question in

                                viewModel.sendMessage(
                                    question: question
                                )
                            },
                            isDisabled: viewModel.isLoading
                        )
                    }

                    if viewModel.isLoading {

                        AIChatLoadingSection()
                    }

                    Color.clear
                        .frame(height: 1)
                        .id("BOTTOM")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: viewModel.messages.count) { _, _ in

                withAnimation(.easeOut(duration: 0.25)) {

                    proxy.scrollTo(
                        "BOTTOM",
                        anchor: .bottom
                    )
                }
            }
            .onChange(of: viewModel.isLoading) { _, _ in

                withAnimation(.easeOut(duration: 0.25)) {

                    proxy.scrollTo(
                        "BOTTOM",
                        anchor: .bottom
                    )
                }
            }
        }
    }
}
