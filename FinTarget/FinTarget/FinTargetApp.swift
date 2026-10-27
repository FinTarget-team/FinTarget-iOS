//
//  FinTargetApp.swift
//  FinTarget
//
//  Created by 박병선 on 5/2/26.
//
import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import NidThirdPartyLogin

@main
struct FinTargetApp: App {

    @StateObject private var sessionManager: SessionManager

    init() {

        // MARK: - 카카오 SDK 초기화

        guard let appKey = Bundle.main.object(
            forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY"
        ) as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY를 찾을 수 없습니다.")
        }

        KakaoSDK.initSDK(appKey: appKey)

        // MARK: - 네이버 SDK 초기화

        guard let naverClientId = Bundle.main.object(
            forInfoDictionaryKey: "NAVER_CLIENT_ID"
        ) as? String,
        !naverClientId.isEmpty,
        !naverClientId.hasPrefix("$(") else {
            fatalError("NAVER_CLIENT_ID를 찾을 수 없습니다.")
        }

        guard let naverClientSecret = Bundle.main.object(
            forInfoDictionaryKey: "NAVER_CLIENT_SECRET"
        ) as? String,
        !naverClientSecret.isEmpty,
        !naverClientSecret.hasPrefix("$(") else {
            fatalError("NAVER_CLIENT_SECRET을 찾을 수 없습니다.")
        }

        NidOAuth.shared.initialize(
            appName: "FinTarget",
            clientId: naverClientId,
            clientSecret: naverClientSecret,
            urlScheme: "fintargetnaverlogin"
        )

        // MARK: - SessionManager 초기화

        let keychain = KeychainService.shared
        let authService = AuthService()

        _sessionManager = StateObject(
            wrappedValue: SessionManager(
                keychain: keychain,
                authService: authService
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(sessionManager)
                .task {
                    sessionManager.bootstrap()
                }
                .onOpenURL { url in

                    // 카카오 로그인 URL 처리
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }

                    // 네이버 로그인 URL 처리
                    else if NidOAuth.shared.handleURL(url) {
                        print("네이버 로그인 URL 처리 성공")
                    }
                }
        }
    }
}
