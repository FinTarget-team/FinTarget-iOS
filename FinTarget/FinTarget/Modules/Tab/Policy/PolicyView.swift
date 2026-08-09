//
//  PolicyView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
import SwiftUI

struct PolicyView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: Header
            VStack(alignment: .leading, spacing: 8) {
                
                HStack {
                    Text("정책 추천")
                        .font(.PretendardBold(size: 28))
                    
                    Spacer()
                    
                    Text("만 27세 · 서울 · 연 3,200만")
                        .font(.PretendardMedium(size: 14))
                        .foregroundColor(.gray)
                }
                
                Text("내 조건에 맞는 정책 4개를 찾았어요")
                    .font(.PretendardMedium(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            ScrollView(showsIndicators: false) {
                
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: Info Banner
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                        
                        Text("나이·소득·거주지 기반으로 자동 필터링된 결과입니다")
                            .font(.PretendardMedium(size: 14))
                    }
                    .foregroundColor(Color.blue)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(12)
                    
                    
                    // MARK: Category Tabs
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            
                            categoryChip(
                                title: "전체",
                                selected: true
                            )
                            
                            categoryChip(
                                title: "청년도약계좌"
                            )
                            
                            categoryChip(
                                title: "전세대출"
                            )
                            
                            categoryChip(
                                title: "청년저축계좌"
                            )
                            
                            categoryChip(
                                title: "주거지원"
                            )
                        }
                    }
                    
                    
                    // MARK: Count + Sort
                    HStack {
                        Text("4개 정책")
                            .font(.PretendardBold(size: 18))
                        
                        Spacer()
                        
                        Text("목표 기여도순 ▼")
                            .font(.PretendardMedium(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    
                    Text("추천 우선순위")
                        .font(.PretendardBold(size: 20))
                    
                    
                    // MARK: Card 1
                    PolicyCard1()
                    
                    
                    // MARK: Card 2
                    PolicyCard2()
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
        }
    }
}

// MARK: Category Chip

private func categoryChip(
    title: String,
    selected: Bool = false
) -> some View {
    
    Text(title)
        .font(.PretendardMedium(size: 14))
        .foregroundColor(selected ? .white : .black)
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            selected
            ? Color.black
            : Color(.systemGray6)
        )
        .clipShape(Capsule())
}

// MARK: Policy Card 1

struct PolicyCard1: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                HStack(spacing: 8) {
                    Text("청년도약계좌")
                        .font(.PretendardMedium(size: 13))
                    
                    Text("유지 안전")
                        .font(.PretendardMedium(size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Image(systemName: "heart")
            }
            
            Text("청년도약계좌")
                .font(.PretendardBold(size: 24))
            
            Text("""
월 40~70만원 납입 시 정부 기여금 + 비과세 혜택,
5년 만기 시 최대 5,000만원 형성 가능.
""")
            .font(.PretendardMedium(size: 14))
            .foregroundColor(.gray)
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("예상 혜택 금액")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("+856만원")
                        .font(.PretendardBold(size: 24))
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("목표 단축")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("-187일")
                        .font(.PretendardBold(size: 24))
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("월 납입")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("50만원")
                        .font(.PretendardBold(size: 24))
                }
            }
            
            HStack {
                
                Text("D-Day 187일 단축")
                    .font(.PretendardMedium(size: 13))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.green.opacity(0.15))
                    .foregroundColor(.green)
                    .cornerRadius(8)
                
                Spacer()
                
                Button("상세보기") {}
                
                Button("신청하기") {}
            }
            .font(.PretendardMedium(size: 14))
        }
        .padding(20)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.green, lineWidth: 2)
        )
    }
}

// MARK: Policy Card 2

struct PolicyCard2: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                HStack(spacing: 8) {
                    Text("전세대출")
                        .font(.PretendardMedium(size: 13))
                    
                    Text("주의 필요")
                        .font(.PretendardMedium(size: 12))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.15))
                        .foregroundColor(.orange)
                        .cornerRadius(8)
                }
                
                Spacer()
                
                Image(systemName: "heart")
            }
            
            Text("청년 버팀목 전세자금 대출")
                .font(.PretendardBold(size: 22))
            
            Text("""
연 1.8~2.7% 저금리 전세 대출.
현재 소비 습관 유지 시 상환 부담 가능성 있음.
""")
            .font(.PretendardMedium(size: 14))
            .foregroundColor(.gray)
            
            HStack {
                
                VStack(alignment: .leading) {
                    Text("최대 대출금")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("7,000만원")
                        .font(.PretendardBold(size: 24))
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("금리 절감")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("+320만원")
                        .font(.PretendardBold(size: 24))
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("월 부담")
                        .font(.PretendardMedium(size: 12))
                        .foregroundColor(.gray)
                    
                    Text("추정 63만")
                        .font(.PretendardBold(size: 24))
                }
            }
            
            HStack {
                
                Text("현소비 기준 중도해지 위험")
                    .font(.PretendardMedium(size: 13))
                    .foregroundColor(.orange)
                
                Spacer()
                
                Button("상세보기") {}
                
                Button("신청하기") {}
            }
            .font(.PretendardMedium(size: 14))
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
    }
}

#Preview{
    PolicyView()
}
