//
//  RootView.swift
//  FinTarget
//
//  Created by 박병선 on 8/30/26.
//
import SwiftUI

struct RootView: View {

    @EnvironmentObject private var sessionManager: SessionManager

    var body: some View {
        switch sessionManager.flow {

        case .launching:
            SplashView()

        case .loggedOut:
            LoginView(viewModel: LoginViewModel(
                authService: AuthService(), sessionManager: sessionManager
            ))

        case .welcome:
            WelcomeView()

        case .onboarding:
            OnboardingView()

        case .home:
            BaseTabView()
        }
    }
}
