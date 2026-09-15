//
//  LoginViewModel.swift
//  FinTarget
//
//  Created by 박병선 on 8/25/26.
//
import Foundation
import Combine

/// 로그인 화면(LoginView)의 ViewModel
/// - 카카오/네이버/애플 소셜 로그인 요청을 각각 처리하고
/// - 성공 시 SessionManager에 결과를 전달해 앱 전체 로그인 상태(flow)를 갱신함
@MainActor
final class LoginViewModel: ObservableObject {

    // MARK: - 상태
    
    /// 로그인 요청 진행 중 여부 (로딩 인디케이터 표시용)
    @Published var isLoading: Bool = false
    /// 로그인 실패 시 사용자에게 보여줄 에러 메시지
    @Published var errorMessage: String?

    // MARK: - Dependencies

    /// 소셜 로그인 API 호출을 담당하는 서비스 (Combine Publisher 반환)
    private let authService: AuthServiceProtocol
    /// 로그인 성공 결과를 앱 전체 세션 상태에 반영하는 매니저
    private let sessionManager: SessionManager

    // MARK: - Combine

    /// Combine 구독을 유지하기 위한 저장소 (미저장 시 즉시 구독 해제됨)
    private var cancellables = Set<AnyCancellable>()

    init(authService: AuthServiceProtocol, sessionManager: SessionManager) {
        self.authService = authService
        self.sessionManager = sessionManager
    }

    // MARK: - 카카오 로그인

    /// 카카오 로그인 요청을 서버에 보내고, 성공 시 세션에 결과 반영
    func kakaoLogin(request: KakaoLoginRequestDTO) {
        isLoading = true
        errorMessage = nil

        print("🚀 카카오 로그인 API 요청")
        print("📤 Request AccessToken: \(request.accessToken)")

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
                        self.handleLoginError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }

                    print("🎉 카카오 로그인 성공")
                    print("Status: \(response.status)")
                    print("Message: \(response.message)")

                    let data = response.data

                    print("UserId: \(data.userId)")
                    print("Provider: \(data.provider)")
                    print("ExpiresIn: \(data.expiresIn)")
                    print("AccessToken: \(data.accessToken)")
                    print("RefreshToken: \(data.refreshToken)")

                    // 로그인 성공 → 토큰 저장 및 다음 화면(flow) 결정은 SessionManager가 담당
                    self.sessionManager.applySocialLoginResult(response)
                }
            )
            .store(in: &cancellables)
    }
    // MARK: - 네이버 로그인

    /// 네이버 로그인 요청을 서버에 보내고, 성공 시 세션에 결과 반영
    func naverLogin(request: NaverLoginRequestDTO) {
        isLoading = true
        errorMessage = nil
        authService.naverLogin(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        self.handleLoginError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
                    self.sessionManager.applySocialLoginResult(response)
                }
            )
            .store(in: &cancellables)
    }

    // MARK: - 애플 로그인

    /// 애플 로그인 요청을 서버에 보내고, 성공 시 세션에 결과 반영
    func appleLogin(request: AppleLoginRequestDTO) {
        isLoading = true
        errorMessage = nil
        authService.appleLogin(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }
                    self.isLoading = false
                    if case .failure(let error) = completion {
                        self.handleLoginError(error)
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }
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
