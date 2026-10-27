//
//  CreateGoalView.swift
//  FinTarget
//
//  Created by 박병선 on 9/30/26.
//
import SwiftUI

struct CreateGoalView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var goalName: String = ""
    @State private var targetAmount: String = ""
    @State private var currentAmount: String = ""
    @State private var targetDate: Date = Date()
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - 목표 이름
                inputSection(
                    title: "목표 이름",
                    placeholder: "예) 전세 자금 마련",
                    text: $goalName
                )
                
                // MARK: - 목표 금액
                inputSection(
                    title: "목표 금액",
                    placeholder: "예) 100000000",
                    text: $targetAmount,
                    keyboardType: .numberPad
                )
                
                // MARK: - 현재 자산
                inputSection(
                    title: "현재 자산",
                    placeholder: "예) 62000000",
                    text: $currentAmount,
                    keyboardType: .numberPad
                )
                
                // MARK: - 목표 날짜
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("목표 날짜")
                        .font(.PretendardSemiBold(size: 16))
                    
                    DatePicker(
                        "목표 날짜",
                        selection: $targetDate,
                        in: Date()...,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.compact)
                    .labelsHidden()
                }
                
                Spacer(minLength: 20)
                
                // MARK: - 목표 생성 버튼
                
                Button {
                    createGoal()
                } label: {
                    Text("목표 생성하기")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            isFormValid
                            ? Color.blue
                            : Color.gray.opacity(0.4)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 14)
                        )
                }
                .disabled(!isFormValid)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("목표 만들기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - UI
extension CreateGoalView {
    
    private func inputSection(
        title: String,
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.PretendardSemiBold(size: 16))
            
            TextField(placeholder, text: text)
                .keyboardType(keyboardType)
                .padding(16)
                .background(Color.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 12)
                )
        }
    }
}

// MARK: - Validation
extension CreateGoalView {
    
    /// 모든 필수 입력값이 입력되었는지 확인
    private var isFormValid: Bool {
        !goalName.isEmpty &&
        !targetAmount.isEmpty &&
        !currentAmount.isEmpty
    }
}

// MARK: - Action
extension CreateGoalView {
    
    /// 목표 생성
    private func createGoal() {
        print("🎯 목표 생성")
        print("목표 이름: \(goalName)")
        print("목표 금액: \(targetAmount)")
        print("현재 자산: \(currentAmount)")
        print("목표 날짜: \(targetDate)")
        
        // TODO: 목표 생성 API 연결
    }
}

#Preview {
    NavigationStack {
        CreateGoalView()
    }
}
