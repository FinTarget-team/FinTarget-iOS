//
//  MyPageView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
import SwiftUI

struct MyPageView: View {
    
    var body: some View {
        NavigationStack{
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 28) {
                    
                    // MARK: Header
                    
                    HStack {
                        
                        Text("마이페이지")
                            .font(.PretendardBold(size: 32))
                        
                        Spacer()
                        
                        
                    }
                    
                    // MARK: Profile
                    
                    HStack(spacing: 16) {
                        
                        Circle()
                            .fill(Color.cyan)
                            .frame(width: 70, height: 70)
                            .overlay {
                                
                                Text("문")
                                    .font(.PretendardBold(size: 32))
                                    .foregroundColor(.white)
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            
                            Text("문선영")
                                .font(.PretendardBold(size: 24))
                            
                            Text("만 23세 · 서울 · 연 2,800만원")
                                .font(.PretendardMedium(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        NavigationLink{
                            EditProfileView()
                        } label: {
                            
                            Text("편집")
                                .font(.PretendardMedium(size: 15))
                                .foregroundColor(.cyan)
                                .frame(width: 60, height: 40)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cyan)
                                }
                        }
                    }
                    
                    // MARK: 내 정보
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("내 정보")
                            .font(.PretendardBold(size: 20))
                        
                        infoRow("나이", "만 23세")
                        infoRow("거주지", "서울")
                        infoRow("월 소득", "233만원")
                        infoRow("직업 유형", "직장인")
                    }
                    
                    // MARK: 현재 목표
                    
                    VStack(alignment: .leading, spacing: 16) {
                        
                        HStack {
                            
                            Text("현재 목표")
                                .font(.PretendardBold(size: 20))
                            
                            Spacer()

                            NavigationLink{
                                EditGoalView()
                            } label: {
                                Text("수정")
                                    .font(.PretendardRegular(size: 18))
                                    .foregroundColor(.cyan)
                                
                            }
                        }
                        
                        Text("전세 자금 1억")
                            .font(.PretendardBold(size: 18))
                        
                        ProgressView(value: 0.42)
                            .tint(.cyan)
                        
                        HStack {
                            
                            Text("현재 4,200만원 (42%)")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("D-287일")
                                .foregroundColor(.gray)
                        }
                        .font(.PretendardMedium(size: 14))
                    }
                    
                    // MARK: 최근 지출
                    
                    VStack(alignment: .leading, spacing: 20) {
                        
                        Text("최근 지출")
                            .font(.PretendardBold(size: 20))
                        
                        expenseRow(
                            title: "카페",
                            date: "05.04",
                            amount: "-4,500원"
                        )
                        
                        expenseRow(
                            title: "외식",
                            date: "05.03",
                            amount: "-18,000원"
                        )
                        
                        NavigationLink{
                            EditExpenseView()
                        } label: {
                            
                            HStack {
                                
                                Image(systemName: "plus.circle")
                                
                                Text("지출 내역 추가")
                            }
                            .foregroundColor(.cyan)
                        }
                    }
                }
                .padding(20)
            }
            .background(Color(.systemBackground))
        }
    }
    
}

private func infoRow(
    _ title: String,
    _ value: String
) -> some View {

    HStack {

        Text(title)
            .font(.PretendardMedium(size: 16))

        Spacer()

        HStack(spacing: 4) {

            Text(value)
                .font(.PretendardSemiBold(size: 16))

            Image(systemName: "chevron.right")
                .font(.system(size: 10))
                .foregroundColor(.cyan)
        }
    }
}

private func expenseRow(
    title: String,
    date: String,
    amount: String
) -> some View {

    HStack(alignment: .top) {

        Circle()
            .fill(Color.cyan)
            .frame(width: 10, height: 10)
            .padding(.top, 6)

        VStack(alignment: .leading) {

            Text(title)
                .font(.PretendardSemiBold(size: 16))

            Text(date)
                .font(.PretendardMedium(size: 13))
                .foregroundColor(.gray)
        }

        Spacer()

        VStack(alignment: .trailing) {

            Text(amount)
                .font(.PretendardBold(size: 18))

            Text("수정")
                .font(.PretendardMedium(size: 13))
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    MyPageView()
}
