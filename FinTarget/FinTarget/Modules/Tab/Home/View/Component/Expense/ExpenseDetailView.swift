//
//  ExpenseDetailView.swift
//  FinTarget
//
//  Created by 박병선 on 10/10/26.
//
import SwiftUI

struct ExpenseDetailView: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    @State private var selectedPeriod: ExpensePeriod = .thisMonth
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - 기간 선택
                
                periodSection
                
                // MARK: - 총 지출
                
                totalExpenseCard
                
                // MARK: - 카테고리별 지출
                
                categorySection
                
                // MARK: - 지출 내역
                
                expenseListSection
            }
            .padding(20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("지출 내역")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            fetchThisMonth()
        }
    }
    
    // MARK: - 기간 선택
    
    private var periodSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            Text("조회 기간")
                .font(.system(size: 18, weight: .bold))
            
            HStack(spacing: 8) {
                periodButton(.thisMonth)
                periodButton(.lastMonth)
                periodButton(.custom)
            }
            
            if selectedPeriod == .custom {
                customDateSection
            }
        }
    }
    
    // MARK: - 기간 버튼
    
    private func periodButton(_ period: ExpensePeriod) -> some View {
        Button {
            selectedPeriod = period
            
            switch period {
            case .thisMonth:
                fetchThisMonth()
                
            case .lastMonth:
                fetchLastMonth()
                
            case .custom:
                break
            }
            
        } label: {
            Text(period.title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(
                    selectedPeriod == period ? .white : .primary
                )
                .frame(maxWidth: .infinity)
                .padding(.vertical, 11)
                .background(
                    selectedPeriod == period
                    ? Color.blue
                    : Color.white
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    // MARK: - 직접 기간 선택
    
    private var customDateSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("시작일")
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
                
                DatePicker(
                    "",
                    selection: $startDate,
                    displayedComponents: .date
                )
                .labelsHidden()
            }
            
            HStack {
                Text("종료일")
                    .font(.system(size: 14, weight: .medium))
                
                Spacer()
                
                DatePicker(
                    "",
                    selection: $endDate,
                    in: startDate...,
                    displayedComponents: .date
                )
                .labelsHidden()
            }
            
            Button {
                fetchCustomPeriod()
            } label: {
                Text("조회하기")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    // MARK: - 총 지출
    
    private var totalExpenseCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(periodTitle)
                .font(.system(size: 14))
                .foregroundColor(.gray)
            
            Text("총 지출")
                .font(.system(size: 16, weight: .semibold))
            
            Text(formatAmount(viewModel.expenseStats?.totalAmount ?? 0))
                .font(.system(size: 28, weight: .bold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // MARK: - 카테고리별 지출
    
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("카테고리별 지출")
                .font(.system(size: 18, weight: .bold))
            
            if let categories = viewModel.expenseStats?.byCategory,
               !categories.isEmpty {
                
                VStack(spacing: 16) {
                    ForEach(categories) { category in
                        categoryRow(category)
                    }
                }
                .padding(18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
            } else {
                emptyCard(
                    icon: "chart.pie",
                    message: "해당 기간의 지출 통계가 없습니다."
                )
            }
        }
    }
    
    // MARK: - 카테고리 Row
    
    private func categoryRow(_ category: ExpenseCategoryDTO) -> some View {
        HStack(spacing: 12) {
            
            Text(category.category)
                .font(.system(size: 15))
            
            Spacer()
            
            Text(formatAmount(category.amount))
                .font(.system(size: 15, weight: .semibold))
        }
    }
    
    // MARK: - 지출 내역
    
    private var expenseListSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("지출 내역")
                .font(.system(size: 18, weight: .bold))
            
            if viewModel.expenses.isEmpty {
                emptyCard(
                    icon: "list.bullet.rectangle",
                    message: "해당 기간의 지출 내역이 없습니다."
                )
            } else {
                VStack(spacing: 0) {
                    ForEach(viewModel.expenses) { expense in
                        expenseRow(expense)
                        
                        if expense.id != viewModel.expenses.last?.id {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 18)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    // MARK: - 지출 Row
    
    private func expenseRow(_ expense: ExpenseDTO) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                
                Text(expense.description)
                    .font(.system(size: 15, weight: .semibold))
                
                HStack(spacing: 6) {
                    Text(expense.category)
                    
                    Text("·")
                    
                    Text(expense.spentAt)
                }
                .font(.system(size: 12))
                .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("-\(formatAmount(expense.amount))")
                .font(.system(size: 15, weight: .semibold))
        }
        .padding(.vertical, 14)
    }
    
    // MARK: - Empty Card
    
    private func emptyCard(icon: String, message: String) -> some View {
        VStack(spacing: 12) {
            
            Image(systemName: icon)
                .font(.system(size: 28))
                .foregroundColor(.gray)
            
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    // MARK: - 이번 달 지출 조회
    
    private func fetchThisMonth() {
        let range = monthRange(from: Date())
        
        fetchExpenses(
            start: range.start,
            end: range.end
        )
    }
    
    // MARK: - 지난 달 지출 조회
    
    private func fetchLastMonth() {
        let calendar = Calendar.current
        
        guard let lastMonth = calendar.date(
            byAdding: .month,
            value: -1,
            to: Date()
        ) else {
            return
        }
        
        let range = monthRange(from: lastMonth)
        
        fetchExpenses(
            start: range.start,
            end: range.end
        )
    }
    
    // MARK: - 직접 선택한 기간 지출 조회
    
    private func fetchCustomPeriod() {
        let start = formatDate(startDate)
        let end = formatDate(endDate)
        
        fetchExpenses(
            start: start,
            end: end
        )
    }
    
    // MARK: - 기간별 지출 조회
    
    private func fetchExpenses(start: String, end: String) {
        viewModel.fetchExpensesByPeriod(
            start: start,
            end: end
        )
        
        viewModel.fetchExpenseStats(
            start: start,
            end: end
        )
    }
    
    // MARK: - 월 시작일 / 종료일
    
    private func monthRange(from date: Date) -> (start: String, end: String) {
        let calendar = Calendar.current
        
        guard let interval = calendar.dateInterval(
            of: .month,
            for: date
        ) else {
            return ("", "")
        }
        
        let startDate = interval.start
        
        let endDate = calendar.date(
            byAdding: .day,
            value: -1,
            to: interval.end
        ) ?? interval.end
        
        return (
            formatDate(startDate),
            formatDate(endDate)
        )
    }
    
    // MARK: - 날짜 포맷
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return formatter.string(from: date)
    }
    
    // MARK: - 기간 표시
    
    private var periodTitle: String {
        switch selectedPeriod {
        case .thisMonth:
            return "이번 달"
            
        case .lastMonth:
            return "지난 달"
            
        case .custom:
            return "\(formatDate(startDate)) ~ \(formatDate(endDate))"
        }
    }
    
    // MARK: - 금액 포맷
    
    private func formatAmount(_ amount: Int) -> String {
        amount.formatted() + "원"
    }
    
    // MARK: - Expense Period
    
    enum ExpensePeriod {
        case thisMonth
        case lastMonth
        case custom
        
        var title: String {
            switch self {
            case .thisMonth:
                return "이번 달"
                
            case .lastMonth:
                return "지난 달"
                
            case .custom:
                return "기간 선택"
            }
        }
    }
}
