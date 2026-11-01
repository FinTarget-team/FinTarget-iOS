//
//  AddExpenseView.swift
//  FinTarget
//
//  Created by 박병선 on 10/28/26.
//
import SwiftUI

struct AddExpenseView: View {

    @Environment(\.dismiss) private var dismiss

    @ObservedObject var viewModel: HomeViewModel

    let onSuccess: () -> Void

    @State private var amount: String = ""
    @State private var category: String = "식비"
    @State private var description: String = ""
    @State private var spentAt: Date = Date()

    @State private var isSubmitting = false
    @State private var showError = false

    private let categories = [
        "식비",
        "교통",
        "쇼핑",
        "문화/여가",
        "생활",
        "기타"
    ]

    var body: some View {

        NavigationStack {

            Form {

                // MARK: - 지출 금액

                Section("지출 금액") {

                    HStack {
                        TextField("금액 입력", text: $amount)
                            .keyboardType(.numberPad)

                        Text("원")
                    }
                }

                // MARK: - 카테고리

                Section("카테고리") {

                    Picker("카테고리", selection: $category) {

                        ForEach(categories, id: \.self) { item in
                            Text(item)
                        }
                    }
                }

                // MARK: - 지출 설명

                Section("지출 설명") {

                    TextField(
                        "어디에 사용했나요?",
                        text: $description
                    )
                }

                // MARK: - 지출 날짜

                Section("지출 날짜") {

                    DatePicker(
                        "날짜",
                        selection: $spentAt,
                        displayedComponents: .date
                    )
                }

                // MARK: - 저장 버튼

                Section {

                    Button {
                        saveExpense()
                    } label: {

                        HStack {

                            Spacer()

                            if isSubmitting {
                                ProgressView()
                            } else {
                                Text("지출 내역 저장")
                                    .font(.system(size: 16, weight: .bold))
                            }

                            Spacer()
                        }
                    }
                    .disabled(
                        isSubmitting ||
                        Int(amount) == nil ||
                        (Int(amount) ?? 0) <= 0 ||
                        description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    )
                }
            }
            .navigationTitle("지출 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Button("취소") {
                        dismiss()
                    }
                }
            }
            .alert("지출 내역 저장 실패", isPresented: $showError) {

                Button("확인", role: .cancel) {}

            } message: {

                Text(viewModel.errorMessage ?? "다시 시도해 주세요.")
            }
        }
    }

    // MARK: - 지출 내역 저장

    private func saveExpense() {

        guard let amountValue = Int(amount),
              amountValue > 0 else {
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let request = ExpenseSyncRequestDTO(
            amount: amountValue,
            category: category,
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            spentAt: formatter.string(from: spentAt)
        )

        isSubmitting = true

        viewModel.syncExpenses(request: [request]) { success in

            isSubmitting = false

            if success {

                onSuccess()
                dismiss()

            } else {

                showError = true
            }
        }
    }
}
