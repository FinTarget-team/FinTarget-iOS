//
//  PolicyView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//  매칭되는 정책 조합
import SwiftUI

struct PolicyView: View {
    
    @StateObject private var viewModel = PolicyViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {

                    headerView /// 헤더
                    monthlyPolicySection /// 이달의 정책
                    matchingPolicySection /// 추천 전책
                    scrappedPolicySection /// 관심 정책
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
    }
    
    
    // MARK: - Header
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("정책")
                .font(.PretendardBold(size: 28))
            
            Text("나에게 필요한 정책을 확인해보세요")
                .font(.PretendardMedium(size: 15))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    // MARK: - 이달의 정책
    private var monthlyPolicySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("이달의 정책")
                        .font(.PretendardBold(size: 22))
                    
                    Text("이번 달 주목할 만한 정책이에요")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "sparkles")
                    .font(.system(size: 20))
                    .foregroundColor(.orange)
            }
            
            MonthlyPolicyCard()
        }
    }
    
    
    // MARK: - 맞춤 정책
    private var matchingPolicySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("나에게 맞는 정책")
                .font(.PretendardBold(size: 22))
            
            NavigationLink {
                MatchingPolicyView(viewModel: viewModel)
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 52, height: 52)
                        
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .font(.system(size: 23))
                            .foregroundColor(.blue)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("내 조건에 맞는 정책 찾기")
                            .font(.PretendardBold(size: 17))
                            .foregroundColor(.black)
                        
                        Text("나이 · 소득 · 거주지를 기준으로 찾아드려요")
                            .font(.PretendardMedium(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(18)
                .background(Color(.systemGray6))
                .cornerRadius(16)
            }
        }
    }
    
    
    // MARK: - 스크랩 정책
    private var scrappedPolicySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("관심 정책")
                .font(.PretendardBold(size: 22))
            
            NavigationLink {
                ScrappedPolicyView(viewModel: viewModel)
            } label: {
                HStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.orange.opacity(0.1))
                            .frame(width: 52, height: 52)
                        
                        Image(systemName: "bookmark.fill")
                            .font(.system(size: 21))
                            .foregroundColor(.orange)
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("스크랩한 정책")
                            .font(.PretendardBold(size: 17))
                            .foregroundColor(.black)
                        
                        Text("저장해둔 정책을 한 번에 확인해보세요")
                            .font(.PretendardMedium(size: 13))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.gray)
                }
                .padding(18)
                .background(Color(.systemGray6))
                .cornerRadius(16)
            }
        }
    }
}


// MARK: - 이달의 정책 카드
struct MonthlyPolicyCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("이번 달 추천")
                    .font(.PretendardMedium(size: 12))
                    .foregroundColor(.orange)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(8)
                
                Spacer()
            
                Image(systemName: "bookmark")
                    .resizable()
                    .frame(width: 18, height: 20)
            }
            
            Text("청년도약계좌")
                .font(.PretendardBold(size: 22))
            
            Text("청년의 중장기 자산 형성을 지원하는 정책입니다.")
                .font(.PretendardMedium(size: 14))
                .foregroundColor(.gray)
            
            Divider()
            
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("지원 혜택")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("최대 2,400,000원")
                        .font(.PretendardBold(size: 17))
                }
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("자세히 보기")
                        .font(.PretendardBold(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 11)
                        .background(Color.black)
                        .cornerRadius(10)
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}


#Preview {
    PolicyView()
}
