//
//  LoginViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.
//
import Foundation
import Combine
import AuthenticationServices

/// 로그인 화면(LoginView)의 ViewModel
/// - 카카오/네이버/애플 소셜 로그인 요청을 각각 처리하고
/// - 성공 시 SessionManager에 결과를 전달해 앱 전체 로그인 상태(flow)를 갱신함
@MainActor
final class LoginViewModel: NSObject, ObservableObject {

    // MARK: - 상태
    @Published var isLoading: Bool = false /// 로그인 요청 진행 중 여부 (로딩 인디케이터 표시용)
    @Published var errorMessage: String? /// 로그인 실패 시 사용자에게 보여줄 에러 메시지
    
    ///재로그인 요청 상태
    @Published var shouldRetryKakaoLogin = false
    @Published var shouldRetryNaverLogin = false

    private var kakaoRetryCount = 0
    private var naverRetryCount = 0

    // MARK: - Dependencies
    
    private let authService: AuthServiceProtocol /// 소셜 로그인 API 호출을 담당하는 서비스 (Combine Publisher 반환)
    
    private let sessionManager: SessionManager /// 로그인 성공 결과를 앱 전체 세션 상태에 반영하는 매니저

    // MARK: - Combine
    private var cancellables = Set<AnyCancellable>() /// Combine 구독을 유지하기 위한 저장소 (미저장 시 즉시 구독 해제됨)

    init(authService: AuthServiceProtocol, sessionManager: SessionManager) { ///initializer
        self.authService = authService
        self.sessionManager = sessionManager
    }
    
    // MARK: - 애플 로그인 시작

    /// 애플 로그인을 시작하고 사용자 이름과 이메일 정보를 요청
    func startAppleLogin() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        /// 최초 로그인 시 사용자 이름과 이메일 요청
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    

    // MARK: - 카카오 로그인API 함수
    /// 카카오 로그인 요청을 서버에 보내고, 성공 시 세션에 결과 반영
    func kakaoLogin(request: KakaoLoginRequestDTO) {
        isLoading = true
        errorMessage = nil

        print(" 카카오 로그인 API 요청")
        print(" Request AccessToken: \(request.accessToken)")

        authService.kakaoLogin(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }

                    self.isLoading = false

                    switch completion {
                    case .finished:
                        print("✅ 카카오 로그인 API 통신 완료")

                    case .failure(let error):
                        print("❌ 카카오 로그인 API 실패")
                        print("에러 내용: \(error)")
                        self.handleKakaoLoginError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }

                    print("🎉 카카오 로그인 성공")
                    // print("Status: \(response.status)")
                    // print("Message: \(response.message)")

                    let data = response.data

                    print("UserId: \(data.userId)")
                    print("Provider: \(data.provider)")
                    // print("ExpiresIn: \(data.expiresIn)")
                    // print("AccessToken: \(data.accessToken)")
                    // print("RefreshToken: \(data.refreshToken)")
                    
                    // 재로그인 횟수 초기화
                    self.kakaoRetryCount = 0

                    // 로그인 성공 → 토큰 저장 및 다음 화면(flow) 결정은 SessionManager가 담당
                    self.sessionManager.applySocialLoginResult(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 카카오 로그인 에러 처리
    private func handleKakaoLoginError(_ error: APIError) {
        switch error {

        case .unauthorized:
            /// 401: 카카오 Access Token 만료 또는 유효하지 않음
            guard kakaoRetryCount < 1 else {
                kakaoRetryCount = 0
                errorMessage = "카카오 로그인 인증에 실패했습니다. 다시 로그인해 주세요."
                return
            }

            kakaoRetryCount += 1
            print("⚠️ 카카오 Access Token 유효하지 않음 → SDK 재로그인")
            shouldRetryKakaoLogin = true

        case .serverError(let code, _):
            switch code {

            case "400":
                /// Access Token 빈 문자열 또는 필드 누락
                errorMessage = "로그인 정보가 올바르지 않습니다. 다시 시도해 주세요."

            case "500":
                /// 서버 또는 외부 서비스 오류
                errorMessage = "일시적인 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."

            default:
                errorMessage = "로그인에 실패했습니다. 다시 시도해 주세요."
            }

        default:
            errorMessage = error.localizedDescription
        }
    }
    // MARK: - 네이버 로그인API 함수

    /// 네이버 로그인 요청을 서버에 보내고, 성공 시 세션에 결과 반영
    func naverLogin(request: NaverLoginRequestDTO) {
        isLoading = true
        errorMessage = nil
        
        print("🚀 네이버 로그인 API 요청")
        
        authService.naverLogin(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    switch completion {
                    case .finished:
                        print("✅ 네이버 로그인 API 통신 완료")
                        
                    case .failure(let error):
                        print("❌ 네이버 로그인 API 실패")
                        print("에러 내용: \(error)")
                        
                        self.handleNaverLoginError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    print("🎉 네이버 로그인 성공")
                    print("Status: \(response.status)")
                    print("Message: \(response.message)")
                    
                    let data = response.data
                    
                    print("UserId: \(data.userId)")
                    print("Provider: \(data.provider)")
                    print("ExpiresIn: \(data.expiresIn)")
                    
                    // 재로그인 횟수 초기화
                    self.naverRetryCount = 0
                    
                    /// 서버에서 발급받은 FinTarget 토큰 저장 및 앱 화면 분기
                    self.sessionManager.applySocialLoginResult(response)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - 네이버 로그인 에러 처리
    private func handleNaverLoginError(_ error: APIError) {
        switch error {

        case .unauthorized:
            /// 401: 네이버 Access Token 만료 또는 유효하지 않음
            guard naverRetryCount < 1 else {
                naverRetryCount = 0
                errorMessage = "네이버 로그인 인증에 실패했습니다. 다시 로그인해 주세요."
                return
            }

            naverRetryCount += 1
            print("⚠️ 네이버 Access Token 유효하지 않음 → SDK 재로그인")
            shouldRetryNaverLogin = true

        case .serverError(let code, _):
            switch code {

            case "400":
                /// Access Token 빈 문자열 또는 필드 누락
                errorMessage = "로그인 정보가 올바르지 않습니다. 다시 시도해 주세요."

            case "500":
                /// 서버 또는 외부 서비스 오류
                errorMessage = "일시적인 오류가 발생했습니다. 잠시 후 다시 시도해 주세요."

            default:
                errorMessage = "로그인에 실패했습니다. 다시 시도해 주세요."
            }

        default:
            errorMessage = error.localizedDescription
        }
    }
   
    // MARK: - 애플 로그인
    /// 애플 로그인 요청을 서버에 보내고, 성공 시 세션에 결과 반영
    func appleLogin(request: AppleLoginRequestDTO) {
        isLoading = true
        errorMessage = nil
        
        print("🚀 애플 로그인 API 요청")
        
        authService.appleLogin(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    
                    self.isLoading = false
                    
                    switch completion {
                    case .finished:
                        print("✅ 애플 로그인 API 통신 완료")
                        
                    case .failure(let error):
                        print("❌ 애플 로그인 API 실패")
                        print("에러 내용: \(error)")
                        
                        self.handleLoginError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    
                    print("🎉 애플 로그인 성공")
                    print("Status: \(response.status)")
                    print("Message: \(response.message)")
                    
                    let data = response.data
                    
                    print("UserId: \(data.userId)")
                    print("Provider: \(data.provider)")
                    print("ExpiresIn: \(data.expiresIn)")
                    
                    /// 서버에서 발급받은 FinTarget 토큰 저장 및 앱 화면 분기
                    self.sessionManager.applySocialLoginResult(response)
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - 로그인 오류 처리

    /// 로그인 실패 시 공통으로 호출되어 에러 메시지를 화면에 반영
    private func handleLoginError(_ error: APIError) {
        errorMessage = error.localizedDescription
    }

}

// MARK: - Apple Login Delegate
extension LoginViewModel: ASAuthorizationControllerDelegate {
    
    /// 애플 로그인 성공
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Apple Credential을 가져올 수 없습니다.")
            return
        }
        
        /// Identity Token 추출
        guard let identityTokenData = credential.identityToken,
              let identityToken = String(data: identityTokenData, encoding: .utf8) else {
            print("❌ Apple Identity Token이 없습니다.")
            return
        }
        
        /// Authorization Code 추출
        guard let authorizationCodeData = credential.authorizationCode,
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) else {
            print("❌ Apple Authorization Code가 없습니다.")
            return
        }
        
        /// 사용자 이름 추출
        let fullName = credential.fullName.map {
            PersonNameComponentsFormatter().string(from: $0)
        }
        
        /// 사용자 이메일 추출
        let email = credential.email
        
        print("🍎 Apple 인증 성공")
        print("FullName: \(fullName ?? "nil")")
        print("Email: \(email ?? "nil")")
        
        /// Fin-Target 서버에 전달할 Request DTO 생성
        let request = AppleLoginRequestDTO(
            identityToken: identityToken,
            authorizationCode: authorizationCode,
            fullName: fullName,
            email: email
        )
        
        /// Fin-Target 서버 로그인 API 호출
        appleLogin(request: request)
    }
    
    /// 애플 로그인 실패
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {
        print("❌ Apple 로그인 실패: \(error.localizedDescription)")
        errorMessage = error.localizedDescription
    }
}

// MARK: - Apple Login Presentation Context
extension LoginViewModel: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            return ASPresentationAnchor()
        }
        
        return window
    }
}
