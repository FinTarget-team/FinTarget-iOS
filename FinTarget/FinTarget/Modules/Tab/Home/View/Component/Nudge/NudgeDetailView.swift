//
//  NudgeDetailView.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct NudgeDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HomeViewModel()
    
    @State private var selectedFilter: NudgeFilter = .unread

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // MARK: - 읽음 / 안 읽음 필터
                filterView
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)
                
                // MARK: - 넛지 목록
                
                if viewModel.isLoading {
                    Spacer()
                    
                    ProgressView("알림을 불러오는 중...")
                    
                    Spacer()
                    
                } else if filteredNudges.isEmpty {
                    Spacer()
                    
                    emptyView
                    
                    Spacer()
                    
                } else {
                    nudgeList
                }
            }
            .navigationTitle("Nudge")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundStyle(.black)
                    }
                }
            }
            .task {
                viewModel.fetchNudges()
            }
        }
    }
}

// MARK: - Filter

extension NudgeDetailView {
    
    enum NudgeFilter {
        case unread
        case read
    }
    
    /// 현재 선택된 필터에 따라 넛지 목록 분류
    private var filteredNudges: [NudgeDTO] {
        switch selectedFilter {
        case .unread:
            return viewModel.nudges.filter { !$0.isRead }
            
        case .read:
            return viewModel.nudges.filter { $0.isRead }
        }
    }
    
    /// 읽음 / 안 읽음 선택
    private var filterView: some View {
        HStack(spacing: 8) {
            filterButton(
                title: "안 읽음",
                count: viewModel.unreadCount,
                filter: .unread
            )
            
            filterButton(
                title: "읽음",
                count: viewModel.nudges.filter { $0.isRead }.count,
                filter: .read
            )
        }
        .padding(4)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    /// 필터 버튼
    private func filterButton(
        title: String,
        count: Int,
        filter: NudgeFilter
    ) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedFilter = filter
            }
        } label: {
            HStack(spacing: 6) {
                Text(title)
                
                Text("\(count)")
                    .font(.caption)
            }
            .font(.PretendardSemiBold(size: 14))
            .foregroundStyle(
                selectedFilter == filter
                ? Color.primary
                : Color.secondary
            )
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background {
                if selectedFilter == filter {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.regularMaterial)
                        .shadow(
                            color: .black.opacity(0.08),
                            radius: 4,
                            y: 2
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Nudge List

extension NudgeDetailView {
    private var nudgeList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(filteredNudges, id: \.nudgeId) { nudge in
                    NudgeCellView(
                        nudge: nudge,
                        onRead: {
                            viewModel.readNudge(
                                nudgeId: nudge.nudgeId
                            )
                        },
                        onDelete: {
                            viewModel.deleteNudge(
                                nudgeId: nudge.nudgeId
                            )
                        }
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
    }
}

// MARK: - Empty View

extension NudgeDetailView {
    
    private var emptyView: some View {
        VStack(spacing: 12) {
            Image(
                systemName: selectedFilter == .unread
                ? "bell"
                : "checkmark.circle"
            )
            .font(.system(size: 40))
            .foregroundStyle(.secondary)
            
            Text(
                selectedFilter == .unread
                ? "읽지 않은 알림이 없어요"
                : "읽은 알림이 없어요"
            )
            .font(.PretendardSemiBold(size: 17))
            
            Text(
                selectedFilter == .unread
                ? "새로운 알림이 생기면 여기에서 확인할 수 있어요."
                : "읽음 처리한 알림이 여기에서 표시돼요."
            )
            .font(.PretendardRegular(size: 14))
            .foregroundStyle(.secondary)
            .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 30)
    }
}

#Preview {
    NudgeDetailView()
}
