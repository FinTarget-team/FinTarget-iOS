//
//  HomeView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
import SwiftUI

struct HomeView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    
                    headerSection
                    
                    goalCard
                    
                    spendingPatternCard
                    
                    alertCard
                    
                    policyCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 100)
            }
            
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Header
extension HomeView {
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("안녕하세요, 민지원님")
                    .font(.PretendardSemiBold(size: 18))
                
                Text("홈")
                    .font(.PretendardBold(size: 25))
            }
            
            Spacer()
            
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 52, height: 52)
                .overlay {
                    Text("MJ") // 닉네임
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.blue)
                }
        }
    }
}

// MARK: - 목표 카드
extension HomeView {
    
    private var goalCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            HStack {
                Text("목표 달성률")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.blue)
                
                Spacer()
                
                Text("D-247")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("전세 자금 1억")
                    .font(.system(size: 28, weight: .bold))
                
                HStack(alignment: .bottom, spacing: 4) {
                    Text("6,200만")
                        .font(.system(size: 42, weight: .heavy))
                    
                    Text("/ 1억원")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.gray)
                }
                
                Text("정책 + 예시 시 D-31 단축 가능")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            VStack(spacing: 8) {
                HStack {
                    Text("62% 달성")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    Text("3,800만 남음")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 16)
                        
                        Capsule()
                            .fill(
                                LinearGradient(
                                    colors: [.blue, .blue.opacity(0.8)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(width: geo.size.width * 0.62, height: 16)
                            .overlay {
                                Text("62%")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            }
                    }
                }
                .frame(height: 16)
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

// MARK: - 소비 패턴 카드
extension HomeView {
    
    private var spendingPatternCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("이번 달 소비 패턴")
                .font(.system(size: 20, weight: .bold))
            
            HStack(spacing: 12) {
                
                infoMiniCard(
                    title: "총 지출",
                    value: "182,400원",
                    icon: "wallet.pass.fill",
                    iconColor: .blue
                )
                
                infoMiniCard(
                    title: "시뮬 대비",
                    value: "+12,400원",
                    icon: "chart.line.uptrend.xyaxis",
                    iconColor: .green
                )
            }
            
            chartView
            
            HStack(spacing: 20) {
                legend(color: .blue, text: "식비 72,000원")
                legend(color: .green, text: "교통비 38,000원")
                legend(color: .orange, text: "외식 54,000원")
            }
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
    
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
                    .foregroundColor(iconColor == .green ? .green : .black)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 18))
    }
    
    private var chartView: some View {
        VStack(spacing: 16) {
            
            chartLine(color: .blue, offset: 0)
            chartLine(color: .green, offset: 10)
            chartLine(color: .orange, offset: 20)
            
            HStack {
                Text("1주")
                Spacer()
                Text("2주")
                Spacer()
                Text("3주")
                Spacer()
                Text("4주")
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
        }
        .padding(.top, 4)
    }
    
    private func chartLine(color: Color, offset: CGFloat) -> some View {
        GeometryReader { geo in
            Path { path in
                let width = geo.size.width
                
                path.move(to: CGPoint(x: 0, y: 40 - offset))
                path.addLine(to: CGPoint(x: width * 0.2, y: 48 - offset))
                path.addLine(to: CGPoint(x: width * 0.4, y: 24 - offset))
                path.addLine(to: CGPoint(x: width * 0.6, y: 36 - offset))
                path.addLine(to: CGPoint(x: width * 0.8, y: 28 - offset))
                path.addLine(to: CGPoint(x: width, y: 18 - offset))
            }
            .stroke(color, lineWidth: 3)
        }
        .frame(height: 50)
    }
    
    private func legend(color: Color, text: String) -> some View {
        HStack(spacing: 6) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}

// MARK: - 경고 카드
extension HomeView {
    
    private var alertCard: some View {
        HStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(spacing: 6) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.orange)
                    
                    Text("낭지 알림")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.orange)
                }
                
                Text("이번 달 외식비 초과")
                    .font(.system(size: 22, weight: .bold))
                
                Text("시뮬레이션 범위를 12,400원 초과했어요.\n외식비를 15% 줄이면 목표일이 9일 앞당겨져요.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Button {
                    
                } label: {
                    Text("조정 가이드 보기")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.orange)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.orange, lineWidth: 1)
                        }
                }
            }
            
            Spacer()
            
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .foregroundColor(.orange.opacity(0.8))
        }
        .padding(20)
        .background(Color.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

// MARK: - 정책 카드
extension HomeView {
    
    private var policyCard: some View {
        HStack(spacing: 16) {
            
            VStack(alignment: .leading, spacing: 10) {
                
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.green)
                    
                    Text("청년도약계좌 신청 기간")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.green)
                }
                
                Text("5월 중 신청 가능합니다.\n가입 시 목표 달성일이 31일 단축돼요.")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                
                Button {
                    
                } label: {
                    Text("정책 상세 보기")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.green)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green, lineWidth: 1)
                        }
                }
            }
            
            Spacer()
            
            Image(systemName: "doc.text.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .foregroundColor(.green.opacity(0.7))
        }
        .padding(20)
        .background(Color.green.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}

#Preview {
    HomeView()
}
