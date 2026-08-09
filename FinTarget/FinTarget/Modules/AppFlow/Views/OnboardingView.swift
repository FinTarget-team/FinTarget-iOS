//
//  OnboardingView.swift
//  FinTarget
//
//  Created by 박병선 on 5/8/26.
//
import SwiftUI

//////////////////////////////////////////////////////////
// MARK: - Main View
//////////////////////////////////////////////////////////

struct OnboardingView: View {
    
    @State private var currentStep: OnboardingStep = .age
    
    @State private var selectedAge: String? = nil
    @State private var selectedJob: String? = nil
    @State private var selectedIncome: String? = nil
    @State private var selectedRegion: String? = nil
    @State private var selectedAsset: String? = nil
    
    let ages = ["19 ~ 24세", "25 ~ 29세", "30 ~ 34세", "35세 이상"]
    let jobs = ["정규직", "계약직", "프리랜서", "학생", "무직"]
    
    let incomes = [
        "200만원 미만",
        "200 ~ 300만원",
        "300 ~ 400만원",
        "400만원 이상"
    ]
    
    let regions = ["서울", "경기/인천", "광역시", "기타 지방"]
    
    let assets = [
        "1,000만원",
        "3,000만원",
        "5,000만원",
        "1억 이상"
    ]
    
    var body: some View {
        
        ScrollView {
            
            VStack(alignment: .leading, spacing: 40) {
                
                //////////////////////////////////////////////////////////
                // Header
                //////////////////////////////////////////////////////////
                
                VStack(spacing: 20) {
                    
                    HStack {
                        
                        Button("← 뒤로") {
                            
                        }
                        
                        Spacer()
                        
                        Text("프로필 설정")
                            .font(.headline)
                        
                        Spacer()
                    }
                    
                    ProgressView(value: progressValue)
                        .tint(.cyan)
                }
                .padding(.horizontal, 24)
                .padding(.top)
                
                //////////////////////////////////////////////////////////
                // Age
                //////////////////////////////////////////////////////////
                
                QuestionSection(
                    title: "먼저 나이를 알려주세요!",
                    items: ages,
                    selectedItem: $selectedAge
                )
                
                if let selectedAge {
                    
                    AnswerBubble(text: selectedAge)
                    
                    ButtonSection {
                        currentStep = .job
                    }
                    
                    //////////////////////////////////////////////////////////
                    // Job
                    //////////////////////////////////////////////////////////
                    
                    if currentStep == .job ||
                        selectedJob != nil {
                        
                        QuestionSection(
                            title: "현재 고용 형태가 어떻게 되세요?",
                            items: jobs,
                            selectedItem: $selectedJob
                        )
                    }
                }
                
                //////////////////////////////////////////////////////////
                // Job Answer
                //////////////////////////////////////////////////////////
                
                if let selectedJob {
                    
                    AnswerBubble(text: selectedJob)
                    
                    ButtonSection {
                        currentStep = .income
                    }
                    
                    //////////////////////////////////////////////////////////
                    // Income
                    //////////////////////////////////////////////////////////
                    
                    if currentStep == .income ||
                        selectedIncome != nil {
                        
                        QuestionSection(
                            title: "월 소득이 어느 정도인가요?",
                            items: incomes,
                            selectedItem: $selectedIncome
                        )
                    }
                }
                
                //////////////////////////////////////////////////////////
                // Income Answer
                //////////////////////////////////////////////////////////
                
                if let selectedIncome {
                    
                    AnswerBubble(text: selectedIncome)
                    
                    //////////////////////////////////////////////////////////
                    // Region
                    //////////////////////////////////////////////////////////
                    
                    QuestionSection(
                        title: "거주 지역을 선택해 주세요.",
                        items: regions,
                        selectedItem: $selectedRegion
                    )
                }
                
                //////////////////////////////////////////////////////////
                // Region Answer
                //////////////////////////////////////////////////////////
                
                if let selectedRegion {
                    
                    AnswerBubble(text: selectedRegion)
                    
                    ButtonSection {
                        currentStep = .asset
                    }
                    
                    //////////////////////////////////////////////////////////
                    // Asset
                    //////////////////////////////////////////////////////////
                    
                    if currentStep == .asset ||
                        selectedAsset != nil {
                        
                        QuestionSection(
                            title: "마지막이에요! 목표 금액을 알려주세요.",
                            items: assets,
                            selectedItem: $selectedAsset
                        )
                    }
                }
                
                //////////////////////////////////////////////////////////
                // Asset Answer
                //////////////////////////////////////////////////////////
                
                if let selectedAsset {
                    
                    AnswerBubble(text: selectedAsset)
                    
                    ButtonSection {
                        currentStep = .complete
                    }
                }
                
                //////////////////////////////////////////////////////////
                // Complete
                //////////////////////////////////////////////////////////
                
                if currentStep == .complete {
                    
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
                            
                            summaryRow(
                                title: "나이",
                                value: selectedAge ?? ""
                            )
                            
                            summaryRow(
                                title: "고용형태",
                                value: selectedJob ?? ""
                            )
                            
                            summaryRow(
                                title: "월 소득",
                                value: selectedIncome ?? ""
                            )
                            
                            summaryRow(
                                title: "거주지",
                                value: selectedRegion ?? ""
                            )
                            
                            summaryRow(
                                title: "목표 금액",
                                value: selectedAsset ?? ""
                            )
                        }
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        Button {
                            //MARK: TODO PLAN VIEW 로 이동 
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
    }
    
    //////////////////////////////////////////////////////////
    // Progress
    //////////////////////////////////////////////////////////
    
    var progressValue: Double {
        
        switch currentStep {
        case .age:
            return 0.2
        case .job:
            return 0.4
        case .income:
            return 0.6
        case .region:
            return 0.8
        case .asset:
            return 0.9
        case .complete:
            return 1.0
        }
    }
    
    //////////////////////////////////////////////////////////
    // Summary Row
    //////////////////////////////////////////////////////////
    
    func summaryRow(title: String, value: String) -> some View {
        
        HStack {
            
            Text(title)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

//////////////////////////////////////////////////////////
// MARK: - Question Section
//////////////////////////////////////////////////////////

struct QuestionSection: View {
    
    let title: String
    let items: [String]
    
    @Binding var selectedItem: String?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            
            Circle()
                .fill(Color.cyan)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                }
            
            Text(title)
                .font(.title3.bold())
            
            WrapButtonView(
                items: items,
                selectedItem: $selectedItem
            )
        }
        .padding(.horizontal, 24)
    }
}

//////////////////////////////////////////////////////////
// MARK: - Answer Bubble
//////////////////////////////////////////////////////////

struct AnswerBubble: View {
    
    let text: String
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Text(text)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 14)
                .background(Color.cyan.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.horizontal, 24)
    }
}

//////////////////////////////////////////////////////////
// MARK: - Bottom Button
//////////////////////////////////////////////////////////

struct ButtonSection: View {
    
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            
            Text("객관식 버튼으로 선택하세요")
                .font(.subheadline)
            
            Spacer()
            
            Button {
                action()
            } label: {
                Circle()
                    .fill(Color.cyan.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.cyan)
                    }
            }
        }
        .padding(.horizontal, 24)
    }
}

//////////////////////////////////////////////////////////
// MARK: - Wrap Button
//////////////////////////////////////////////////////////

struct WrapButtonView: View {
    
    let items: [String]
    
    @Binding var selectedItem: String?
    
    var body: some View {
        
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 110))
            ],
            alignment: .leading,
            spacing: 12
        ) {
            
            ForEach(items, id: \.self) { item in
                
                Button {
                    selectedItem = item
                } label: {
                    
                    Text(item)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            selectedItem == item
                            ? .white
                            : .cyan
                        )
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedItem == item
                            ? Color.cyan
                            : Color.clear
                        )
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(Color.cyan, lineWidth: 1.5)
                        }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
