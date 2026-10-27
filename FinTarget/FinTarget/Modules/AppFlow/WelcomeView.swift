//
//  WelcomeView.swift
//  FinTarget
//
//  Created by 박병선 on 5/9/26.
//
import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject private var sessionManager: SessionManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                Spacer()
                
                Circle()
                    .fill(Color.cyan.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .overlay {
                        Image(systemName: "pause.fill")
                            .font(.title)
                            .foregroundStyle(.cyan)
                    }
                
                VStack(spacing: 8) {
                    
                    Text("안녕하세요!")
                        .font(.title2.bold())
                    
                    Text("""
핀타겟에 오신 것을 환영합니다.
몇 가지 질문으로 맞춤형
자산 목표를 도와드릴게요.
""")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.gray)
                }
                
                //////////////////////////////////////////////////////////
                // 시작하기 버튼
                //////////////////////////////////////////////////////////
                
                Button {
                    sessionManager.completeWelcome()
                } label: {
                    Text("시작하기")
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.cyan)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                Text("약 1분 소요됩니다")
                    .foregroundStyle(.gray)
                    .font(.footnote)
                
                Text("""
로그인 이후 관리, 시작 버튼 터치 시
채팅 온보딩 화면으로 전환
""")
                .multilineTextAlignment(.center)
                .font(.caption)
                .foregroundStyle(.gray.opacity(0.7))
                .padding(.bottom, 40)
            }
        }
    }
}

