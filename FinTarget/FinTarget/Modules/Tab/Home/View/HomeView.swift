//
//  HomeView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
/// 홈화면에 필요한 API
import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: BaseTab
    
    @State private var showNudge = false
    @State private var showCreateGoal = false
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        ///아직은 하드코딩된 값
                        ///나중에는
                        ///HomeHeaderView( userName: viewModel.userName, onMyPageTapped: {selectedTab = .my)} 이런 식으로 바뀌어야함
                        HomeHeaderView(userName: viewModel.userName,  onMyPageTapped: { selectedTab = .my })
                        
                        GoalCardView()
                        
                        NavigationLink {
                            ExpenseDetailView(
                                viewModel: viewModel
                            )
                        } label: {
                            SpendingPatternView(
                                expenseStats: viewModel.expenseStats
                            )
                        }
                        .buttonStyle(.plain)
                        
                        NudgeCardView(
                            unreadCount: viewModel.unreadCount,
                            nudgeDetail: {
                                showNudge = true
                            }
                        )
                        
                        PolicyCardView()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 100)
                }
            }
            .background(Color(.systemGroupedBackground))
            .ignoresSafeArea(.keyboard)
            .onAppear{
                viewModel.fetchHomeData()
            }
            .fullScreenCover(isPresented: $showNudge) {
                NudgeDetailView()
            }
            .fullScreenCover(isPresented: $showCreateGoal) {
                CreateGoalView()
            }
        }
    }    
}
