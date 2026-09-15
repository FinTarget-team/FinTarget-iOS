//
//  SplashView.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.
//
//
//  SplashView.swift
//  FinTarget
//

import SwiftUI

struct SplashView: View {

    // @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            VStack(spacing: 16) {

                // MARK: - Logo
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
            .offset(y: -100)
        }
        /*
        .task {
            sessionManager.bootstrap()
        }
         */
    }
}

#Preview{
    SplashView()
}
