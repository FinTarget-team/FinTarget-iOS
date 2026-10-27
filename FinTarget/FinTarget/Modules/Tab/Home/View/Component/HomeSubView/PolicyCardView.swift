//
//  PolicyCardView.swift
//  FinTarget
//
//  Created by 박병선 on 9/30/26.
//
import SwiftUI

struct PolicyCardView: View {
    
    var body: some View {
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
