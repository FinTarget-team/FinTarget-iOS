//
//  LoginView.swift
//  FinTarget
//
//  Created by 박병선 on 5/2/26.
//
import SwiftUI

struct LoginView: View {
    
    var body: some View {
        ZStack {
            
            // 배경
            Color(.white)
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                // MARK: - Logo
                VStack(spacing: 16) {
                    
                    Image("FinTarget_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                    
                    Text("Fin-Target")
                        .font(.PretendardBold(size: 36))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.blue,
                                    Color.green
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text("목표까지 가장 빠르게, 똑똑하게")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Spacer().frame(height: 40)
                
                // MARK: - Buttons
                VStack(spacing: 16) {
                    
                    SocialButton(
                        icon: "kakao_icon",
                        text: "카카오로 시작하기"
                    )
                    
                    SocialButton(
                        icon: "naver_icon",
                        text: "네이버로 시작하기"
                    )
                    
                    SocialButton(
                        icon: "google_icon",
                        text: "구글로 시작하기"
                    )
                }
                .padding(.horizontal, 24)
                
                Spacer()
                
                // MARK: - Footer
                Text("안심 이용약관 & 데이터 처리 동의")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
            }
        }
    }
}

struct SocialButton: View {
    
    let icon: String
    let text: String
    
    var body: some View {
        Button {
            print("\(text)")
        } label: {
            HStack(spacing: 12) {
                
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
}

#Preview {
    LoginView()
}
