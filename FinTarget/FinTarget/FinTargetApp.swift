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

/*
@main
struct FinTargetApp: App {

    @StateObject private var sessionManager = SessionManager(
        keychain: KeychainService.shared,
        authService: AuthService()
    )

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(sessionManager)
        }
    }
}
*/
@main
struct FinTargetApp: App {

    @StateObject private var sessionManager: SessionManager

    init() {

        guard let appKey = Bundle.main.object(
            forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY"
        ) as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY를 찾을 수 없습니다.")
        }

        KakaoSDK.initSDK(appKey: appKey)

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
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
        }
    }
}

/*
 WindowGroup {
     RootView()
         .environmentObject(sessionManager)
         .task {
             sessionManager.bootstrap()
         }
         .onOpenURL { url in
             if AuthApi.isKakaoTalkLoginUrl(url) {
                 _ = AuthController.handleOpenUrl(url: url)
             }
         }
 }
 */
