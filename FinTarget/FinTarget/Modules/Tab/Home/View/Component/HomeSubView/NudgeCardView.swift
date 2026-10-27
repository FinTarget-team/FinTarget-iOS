//
//  NudgeCardView.swift
//  FinTarget
//
//  Created by 박병선 on 9/30/26.
//
import SwiftUI

struct NudgeCardView: View {
    
    let unreadCount: Int
    let nudgeDetail: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Image(systemName: "bell.fill")
                        .foregroundColor(.orange)
                    
                    Text("넛지 알림")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.orange)
                }
                
                Text("새로운 넛지 알림이 \(unreadCount)개 있어요")
                    .font(.system(size: 22, weight: .bold))
                
                Text("소비 습관을 확인하고 목표 달성을 위한\n맞춤 가이드를 확인해보세요.")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                Button{
                    nudgeDetail()
                } label: {
                    Text("자세히 보기")
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
            
            Image(systemName: "bell.circle.fill")
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


#Preview {
NudgeCardView(
        unreadCount: 1,
        nudgeDetail:{}
    )
}
