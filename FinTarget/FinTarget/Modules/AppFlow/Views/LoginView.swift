//
//  LoginView.swift
//  FinTarget
//
//  Created by 박병선 on 5/2/26.
//

import SwiftUI
import KakaoSDKUser

/// 소셜 로그인 화면
/// - 카카오/네이버/애플 로그인 버튼을 보여주고, 각 SDK 로그인 완료 후 ViewModel에 결과를 전달
struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel

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
                    //  카카오 로그인은 아직 SDK 연동 전 — 클릭 시 콘솔 출력만 됨
                    SocialButton(
                        icon: "kakao_icon",
                        text: "카카오로 시작하기"
                    ) {
                        print("카카오 로그인 버튼 클릭 !!!! ")
                       startKakaoLogin()
                    }

                    SocialButton(
                        icon: "naver_icon",
                        text: "네이버로 시작하기"
                    ) {
                        startNaverLogin()
                    }

                    SocialButton(
                        icon: "apple_icon",
                        text: "애플로 시작하기"
                    ) {
                        startAppleLogin()
                    }
                }
                .padding(.horizontal, 24)
                // MARK: - Loading

                // 로그인 요청 진행 중일 때 로딩 인디케이터 표시
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 20)
                }

                // MARK: - Error Message

                // 로그인 실패 시 에러 메시지 표시
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                }

                Spacer()
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

// MARK: - Social Login
/// 카카오 로그인 시작
/// - 카카오톡 설치 여부에 따라 카카오톡 로그인 또는 카카오계정 로그인을 실행
/// - 로그인 성공 후 Kakao SDK가 발급한 Access Token을 Fin-Target 서버로 전달
private extension LoginView {
    func startKakaoLogin(){
        print("!!!!startKakaoLogin진입!!!!")
        // 카카오톡 앱이 설치되어 있는 경우
        if UserApi.isKakaoTalkLoginAvailable() {

            UserApi.shared.loginWithKakaoTalk { oauthToken, error in

                // SDK 로그인 실패
                if let error = error {
                    print("카카오톡 로그인 실패: \(error)")
                    return
                }

                // Access Token 확인
                guard let kakaoAccessToken = oauthToken?.accessToken else {
                    print("카카오 Access Token이 없습니다.")
                    return
                }

                // Fin-Target 서버에 전달할 Request DTO 생성
                let request = KakaoLoginRequestDTO(
                    accessToken: kakaoAccessToken
                )

                // 서버 로그인 API 호출
                viewModel.kakaoLogin(request: request)
            }

        } else {

            // 카카오톡이 설치되어 있지 않은 경우 카카오계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { oauthToken, error in

                // SDK 로그인 실패
                if let error = error {
                    print("카카오계정 로그인 실패: \(error)")
                    return
                }

                // Access Token 확인
                guard let kakaoAccessToken = oauthToken?.accessToken else {
                    print("카카오 Access Token이 없습니다.")
                    return
                }

                // Fin-Target 서버에 전달할 Request DTO 생성
                let request = KakaoLoginRequestDTO(
                    accessToken: kakaoAccessToken
                )

                // 서버 로그인 API 호출
                viewModel.kakaoLogin(request: request)
            }
        }
    }

    /// 네이버 로그인 시작
    /// - iOS(클라이언트) -> 네이버 서버와 소통 위한 함수
    /// - 네이버 SDK 로그인 완료 후 authorizationCode, state를 받아 서버 API 호출로 이어짐
    /// - 현재는 SDK 연동 전이라 로직이 주석 처리된 상태
    func startNaverLogin() {
        // TODO: 네이버 SDK 로그인 후
        // authorizationCode, state를 받아서 아래 API 호출

        /*
        let request = NaverLoginRequestDTO(
            authorizationCode: authorizationCode,
            state: state
        )

        viewModel.naverLogin(request: request)
        */
    }

    /// 애플 로그인 시작
    /// - Apple Sign In 완료 후 identityToken, authorizationCode 등을 받아 서버 API 호출로 이어짐
    /// - 현재는 SDK 연동 전이라 로직이 주석 처리된 상태
    func startAppleLogin() {
        // TODO: Apple Sign In 완료 후
        // identityToken, authorizationCode 등의 값을 받아서 아래 API 호출

        /*
        let request = AppleLoginRequestDTO(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: fullName,
            email: email
        )

        viewModel.appleLogin(request: request)
        */
    }
}
