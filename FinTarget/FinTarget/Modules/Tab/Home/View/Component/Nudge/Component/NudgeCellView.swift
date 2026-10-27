//
//  NudgeCellView.swift
//  FinTarget
//
//  Created by 박병선 on 9/30/26.
//
import SwiftUI

struct NudgeCellView: View {
    let nudge: NudgeDTO
    let onRead: () -> Void
    let onDelete: () -> Void
    
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // MARK: - 카테고리
            HStack {
                if let category = nudge.relatedCategory{
                    Text(category)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                }

                Spacer()
                
                if !nudge.isRead {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 8, height: 8)
                }
            }
            
            // MARK: - 알림 내용
            
            Text(nudge.message)
                .font(.body)
                .fontWeight(.medium)
                .frame(
                    maxWidth: .infinity,
                    alignment: .leading
                )
            
            // MARK: - 절약 정보
            
            HStack(spacing: 16) {
                Label {
                    Text("\(nudge.savedAmount)원 절약")
                } icon: {
                    Image(systemName: "wonsign.circle")
                }
                
                Label {
                    Text("\(nudge.dDayShortenIfActed)일 단축")
                } icon: {
                    Image(systemName: "calendar")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)
            
            // MARK: - 생성 날짜
            
            Text(nudge.createdAt)
                .font(.caption2)
                .foregroundStyle(.tertiary)
            
            Divider()
            
            // MARK: - 액션 버튼
            
            HStack {
                
                // 안 읽은 넛지에서만 표시
                if !nudge.isRead {
                    Button {
                        onRead()
                    } label: {
                        Label(
                            "읽음 처리",
                            systemImage: "checkmark.circle"
                        )
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
                
                Button {
                    showDeleteAlert = true
                } label: {
                    Label(
                        "삭제",
                        systemImage: "trash"
                    )
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.red)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.98, green: 0.98, blue: 0.92))
        }

        .overlay {
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    Color(.systemGray5),
                    lineWidth: 1
                )
        }
        .alert(
            "알림 삭제",
            isPresented: $showDeleteAlert
        ) {
            Button("취소", role: .cancel) { }
            
            Button("삭제", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("이 알림을 삭제하시겠습니까?")
        }
    }
}



