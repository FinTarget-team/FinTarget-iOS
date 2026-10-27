//
//  GoalCreateView.swift
//  FinTarget
//
//  Created by 박병선 on 9/30/26.
//
//  금융목표가 없으면 생성하게 함
import SwiftUI

struct GoalCreateCardView: View {
    
    let onCreateTapped: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "target")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            VStack(spacing: 6) {
                Text("아직 설정된 목표가 없어요")
                    .font(.PretendardSemiBold(size: 18))
                
                Text("목표를 설정하고 자산 관리를 시작해보세요.")
                    .font(.PretendardRegular(size: 14))
                    .foregroundColor(.gray)
            }
            
            Button {
                onCreateTapped()
            } label: {
                Text("목표 만들기")
                    .font(.PretendardSemiBold(size: 15))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 2)
    }
}

#Preview {
    GoalCreateCardView {
        print("목표 만들기")
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}
