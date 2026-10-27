//
//  GoalCard.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct GoalCardView: View {
    
    var body: some View {
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
