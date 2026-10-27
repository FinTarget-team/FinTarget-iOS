//
//  Untitled.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct SpendingPatternView: View {
    
    let expenseStats: ExpenseStatsDataDTO?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // MARK: - Title
            
            Text("이번 달 소비 패턴")
                .font(.system(size: 20, weight: .bold))
            
            // MARK: - 총 지출
            
            infoMiniCard(
                title: "총 지출",
                value: formatAmount(expenseStats?.totalAmount ?? 0),
                icon: "wallet.pass.fill",
                iconColor: .blue
            )
            
            // MARK: - 카테고리별 지출
            if let categories = expenseStats?.byCategory,
               !categories.isEmpty {
                
                VStack(alignment: .leading, spacing: 14) {
                    
                    Text("카테고리별 지출")
                        .font(.system(size: 16, weight: .semibold))
                    
                    ForEach(categories) { category in
                        categoryRow(category)
                    }
                }
                
            } else {
                
                Text("이번 달 지출 내역이 없습니다.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
    // MARK: - 총 지출 카드
    
    private func infoMiniCard(
        title: String,
        value: String,
        icon: String,
        iconColor: Color
    ) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 12)
                .fill(iconColor.opacity(0.1))
                .frame(width: 42, height: 42)
                .overlay {
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                Text(value)
                    .font(.system(size: 18, weight: .bold))
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    // MARK: - 카테고리별 지출
    private func categoryRow(
        _ category: ExpenseCategoryDTO
    ) -> some View {
        HStack {
            
            HStack(spacing: 8) {
                Circle()
                    .fill(Color.cyan)
                    .frame(width: 8, height: 8)
                
                Text(category.category)
                    .font(.system(size: 14))
            }
            
            Spacer()
            
            Text(formatAmount(category.amount))
                .font(.system(size: 14, weight: .semibold))
        }
    }
    
    // MARK: - 금액 포맷
    private func formatAmount(_ amount: Int) -> String {
        amount.formatted() + "원"
    }
    
}

#Preview {
    SpendingPatternView(
        expenseStats: ExpenseStatsDataDTO(
            totalAmount: 182400,
            byCategory: [
                ExpenseCategoryDTO(
                    category: "식비",
                    amount: 72000
                ),
                ExpenseCategoryDTO(
                    category: "교통",
                    amount: 38000
                ),
                ExpenseCategoryDTO(
                    category: "쇼핑",
                    amount: 54000
                ),
                ExpenseCategoryDTO(
                    category: "음료",
                    amount: 18400
                )
            ]
        )
    )
    .padding()
    .background(Color(.systemGroupedBackground))
}
