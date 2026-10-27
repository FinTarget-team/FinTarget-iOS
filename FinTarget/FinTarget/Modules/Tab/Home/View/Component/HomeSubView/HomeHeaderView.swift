//
//  HeaderSection.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct HomeHeaderView: View {
    
    let userName: String
    let onMyPageTapped: () -> Void
    
    /// 사용자 이름에서 성을 제외한 이름
    private var displayName: String {
        guard userName.count > 1 else { return userName }
        return String(userName.dropFirst())
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("안녕하세요, \(userName)님")
                    .font(.PretendardSemiBold(size: 18))
                
                Text("홈")
                    .font(.PretendardBold(size: 25))
            }
            
            Spacer()
            
            Button {
                onMyPageTapped()
            } label: {
                Circle()
                    .fill(Color.blue.opacity(0.1))
                    .frame(width: 52, height: 52)
                    .overlay {
                        Text(displayName)
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundColor(.blue)
                    }
            }
            .buttonStyle(.plain)
        }
    }
}
