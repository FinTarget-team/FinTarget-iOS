//
//  AppFlow.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.
//
/// 앱의 전체 화면 흐름(로그인/온보딩/탭뷰)을 나타내는 상태
enum AppFlow: Equatable {
    case launching      // SplashView
    case loggedOut      // LoginView
    case welcome        // WelcomeView
    case onboarding     // OnboardingView
    case main           // BaseTabView
}
