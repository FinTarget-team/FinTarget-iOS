//
//  EditGoalView.swift
//  FinTarget
//
//  Created by 박병선 on 6/15/26.
//
import SwiftUI

struct EditGoalView: View {
    
    @ObservedObject var viewModel: MyPageViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedGoal = ""
    @State private var targetAmount = ""
    @State private var currentAmount = ""
    @State private var deadline = Date()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                // MARK: - Header
                
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Text("← 뒤로")
                            .foregroundColor(.cyan)
                    }
                    
                    Spacer()
                    
                    Text("목표 수정")
                        .font(.PretendardBold(size: 28))
                    
                    Spacer()
                    
                    Button {
                        updateGoal()
                    } label: {
                        Text("저장")
                            .foregroundColor(.cyan)
                    }
                }
                
                // MARK: - 목표 유형
                
                Text("목표 유형")
                    .font(.PretendardBold(size: 18))
                
                VStack(spacing: 12) {
                    GoalTypeButton(
                        title: "전세/내집 마련",
                        selected: selectedGoal == "전세/내집 마련"
                    ) {
                        selectedGoal = "전세/내집 마련"
                    }
                    
                    GoalTypeButton(
                        title: "비상금 마련",
                        selected: selectedGoal == "비상금 마련"
                    ) {
                        selectedGoal = "비상금 마련"
                    }
                    
                    GoalTypeButton(
                        title: "여행/목돈 마련",
                        selected: selectedGoal == "여행/목돈 마련"
                    ) {
                        selectedGoal = "여행/목돈 마련"
                    }
                }
                
                // MARK: - 목표 금액
                
                Text("목표 금액")
                    .font(.PretendardBold(size: 18))
                
                HStack {
                    TextField(
                        "목표 금액을 입력해주세요",
                        text: $targetAmount
                    )
                    .keyboardType(.numberPad)
                    .font(.PretendardBold(size: 28))
                    
                    Text("원")
                        .font(.PretendardSemiBold(size: 20))
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan)
                }
                
                // MARK: - 현재 금액
                
                Text("현재 모은 금액")
                    .font(.PretendardBold(size: 18))
                
                HStack {
                    TextField(
                        "현재 금액을 입력해주세요",
                        text: $currentAmount
                    )
                    .keyboardType(.numberPad)
                    .font(.PretendardBold(size: 28))
                    
                    Text("원")
                        .font(.PretendardSemiBold(size: 20))
                }
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.cyan)
                }
                
                // MARK: - 목표 기간
                
                Text("목표 기간")
                    .font(.PretendardBold(size: 18))
                
                DatePicker(
                    "목표 달성일",
                    selection: $deadline,
                    in: Date()...,
                    displayedComponents: .date
                )
                .font(.PretendardSemiBold(size: 18))
                
                // MARK: - 목표 업데이트
                
                Button {
                    updateGoal()
                } label: {
                    Text("목표 업데이트")
                        .font(.PretendardBold(size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.cyan)
                        .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            setCurrentGoal()
        }
    }
    
    // MARK: - 기존 목표 설정
    
    private func setCurrentGoal() {
        guard let goal = viewModel.goal else {
            return
        }
        
        selectedGoal = goal.title
        targetAmount = String(goal.targetAmount)
        currentAmount = String(goal.currentAmount)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        if let date = formatter.date(from: goal.deadline) {
            deadline = date
        }
    }
    
    // MARK: - 목표 수정
    
    private func updateGoal() {
        guard let targetAmount = Int(targetAmount),
              let currentAmount = Int(currentAmount),
              !selectedGoal.isEmpty else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        viewModel.updateGoal(
            title: selectedGoal,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: formatter.string(from: deadline)
        )
    }
}

private struct GoalTypeButton: View {
    
    let title: String
    let selected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Circle()
                    .fill(selected ? Color.cyan : Color.clear)
                    .frame(width: 18, height: 18)
                    .overlay {
                        Circle()
                            .stroke(Color.cyan)
                    }
                
                Text(title)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .background(
                selected
                ? Color.cyan.opacity(0.15)
                : Color.clear
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        selected
                        ? Color.cyan
                        : Color.clear
                    )
            }
        }
    }
}
