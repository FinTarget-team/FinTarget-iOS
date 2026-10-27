//
//  LoginView.swift
//  FinTarget
//
//  Created by 박병선 on 5/2/26.
//
import SwiftUI
import KakaoSDKUser
import NidThirdPartyLogin
import AuthenticationServices

/// 소셜 로그인 화면
/// - 카카오/네이버/애플 로그인 버튼을 보여주고, 각 SDK 로그인 완료 후 ViewModel에 결과를 전달
struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var isTesting401 = true /// 실제로는 지워야 해

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
        // MARK: -Social Login Retry
        .onChange(of: viewModel.shouldRetryKakaoLogin) { _, shouldRetry in
            guard shouldRetry else { return }

            viewModel.shouldRetryKakaoLogin = false
            startKakaoLogin()
        }
        .onChange(of: viewModel.shouldRetryNaverLogin) { _, shouldRetry in
            guard shouldRetry else { return }

            viewModel.shouldRetryNaverLogin = false
            startNaverLogin()
        }
    }
}

// MARK: - Social Login

private extension LoginView {
    
    /// 카카오 로그인 시작
    /// - 카카오톡 설치 여부에 따라 카카오톡 로그인 또는 카카오계정 로그인을 실행
    /// - 로그인 성공 후 Kakao SDK가 발급한 Access Token을 Fin-Target 서버로 전달
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
    
    // 401 테스트 전용
    func startNaverLogin() {
        print("!!!!startNaverLogin 진입!!!!")

        NidOAuth.shared.requestLogin { result in
            switch result {
            case .success(let loginResult):
                print("네이버 SDK 로그인 성공")

                let realAccessToken = loginResult.accessToken.tokenString

                let accessToken: String

                if isTesting401 {
                    accessToken = "invalid_naver_access_token"
                    isTesting401 = false /// 첫 요청에서만 invalid token 사용
                } else {
                    accessToken = realAccessToken /// 재로그인부터 실제 SDK token 사용
                }

                let request = NaverLoginRequestDTO(
                    accessToken: accessToken
                )

                print("!!!!네이버 서버 로그인 API 호출!!!!")
                viewModel.naverLogin(request: request)

            case .failure(let error):
                print("네이버 SDK 로그인 실패: \(error)")
            }
        }
    }

    /*
    /// 네이버 로그인 시작
    /// - Naver SDK를 통해 로그인을 실행
    /// - 로그인 성공 후 Naver SDK가 발급한 Access Token을 Fin-Target 서버로 전달
    func startNaverLogin() {
        print("!!!!startNaverLogin 진입!!!!")

        NidOAuth.shared.requestLogin { result in
            switch result {

            case .success(let loginResult):
                print("네이버 SDK 로그인 성공")

                let naverAccessToken = loginResult.accessToken.tokenString

                print("네이버 Access Token: \(naverAccessToken)")

                // 서버에 전달할 Request DTO 생성
                let request = NaverLoginRequestDTO(
                    accessToken: naverAccessToken
                )

                print("!!!!네이버 서버 로그인 API 호출!!!!")

                // 서버 로그인 API 호출
                viewModel.naverLogin(request: request)

            case .failure(let error):
                print("네이버 SDK 로그인 실패: \(error)")
            }
        }
    }
     */

}
