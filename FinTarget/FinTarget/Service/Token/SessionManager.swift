//
//  SessionManager.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import Foundation
import Combine

/// 앱 전체의 로그인 세션과 화면 흐름을 관리하는 클래스
/// - 토큰 저장/갱신
/// - 로그인 결과 반영
/// - 신규/기존 회원 화면 분기
/// - 로그아웃 및 세션 초기화를 담당
@MainActor
final class SessionManager: ObservableObject {

    // MARK: - 화면 흐름 상태

    /// 현재 앱에서 보여줘야 하는 최상위 화면
    @Published var flow: AppFlow = .launching

    // MARK: - 사용자 정보

    /// 현재 로그인한 사용자의 ID
    @Published var userId: String?

    // MARK: - 토큰

    /// 현재 Access Token
    private(set) var accessToken: String?

    /// 현재 Refresh Token
    private(set) var refreshToken: String?

    // MARK: - Dependencies

    /// Access Token / Refresh Token을 저장하는 Keychain 서비스
    private let keychain: KeychainService

    /// 로그인, 토큰 재발급 API를 호출하는 서비스
    private let authService: AuthService

    /// userId, 온보딩 완료 여부를 저장하는 로컬 저장소
    private let defaults = UserDefaults.standard

    // MARK: - Combine

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initializer

    init(
        keychain: KeychainService,
        authService: AuthService
    ) {
        self.keychain = keychain
        self.authService = authService
    }

    /*
    // MARK: - 앱 시작 시 진입점
    /// 앱 실행 시 저장된 토큰으로 자동 로그인 가능 여부 확인
    func bootstrap() {
        guard let token = keychain.loadToken() else {
            flow = .loggedOut
            return
        }
        refreshAccessToken(token: token)
    }
    */
    
    /*
    //임시(나머지 API테스트할 때 임시사용)
    func bootstrap() {
        print("🚀 bootstrap 실행")

        guard let token = keychain.loadToken() else {
            print("❌ 저장된 토큰 없음 → 로그인")
            flow = .loggedOut
            return
        }

        print("🔑 저장된 토큰 있음 → 자동 로그인")
        refreshAccessToken(token: token)
    }
     

    */
    
    // 온보딩 API 테스트용 임시 bootstrap 코드
    func bootstrap(){
        logout()
    }
    
    
    
    // MARK: - Access Token 재발급
    /// 저장되어 있는 Refresh Token으로 새로운 Access Token을 발급
    private func refreshAccessToken(token: TokenInfo) {

        let request = RefreshTokenRequestDTO(
            refreshToken: token.refreshToken
        )

        authService.refreshToken(request: request)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self else { return }

                    if case .failure = completion {
                        // Refresh Token까지 사용할 수 없는 경우 로그아웃 처리
                        self.logout()
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self else { return }

                    // 이전 로그인 시 저장했던 userId 복구
                    guard let savedUserId = self.defaults.string(
                        forKey: "userId"
                    ) else {
                        self.logout()
                        return
                    }

                    // 새로운 Access Token을 메모리에 반영
                    self.accessToken = response.data.accessToken

                    // 기존 Refresh Token 유지
                    self.refreshToken = token.refreshToken

                    // 사용자 정보 복구
                    self.userId = savedUserId

                    // 새로운 Access Token과 기존 Refresh Token을 다시 저장
                    self.keychain.saveToken(
                        .init(
                            accessToken: response.data.accessToken,
                            refreshToken: token.refreshToken
                        )
                    )
                    
                    
                    // 이미 로그인한 사용자는 온보딩 완료 여부에 따라 화면 결정
                    let onboardingCompleted = self.defaults.bool(
                        forKey: "onboardingCompleted"
                    )

                    self.flow = onboardingCompleted
                        ? .main
                        : .welcome
                     
                    
                    
                    // 온보딩 API 테스트를 위해 임시로 Welcome 화면으로 이동
                    // self.defaults.set(false, forKey: "onboardingCompleted")
                    // self.flow = .welcome
                     
                }
            )
            .store(in: &cancellables)
    }

    
    // MARK: - 소셜 로그인 성공
    /// 카카오/네이버/애플 로그인 성공 결과를 세션에 반영
    func applySocialLoginResult(_ response: SocialLoginResponseDTO) {
        let data = response.data

        applySession(
            accessToken: data.accessToken,
            refreshToken: data.refreshToken,
            userId: data.userId
        )

        if data.newUser {
            // 신규 회원
            // Welcome → Onboarding을 진행해야 함
            defaults.set(false, forKey: "onboardingCompleted")
            flow = .welcome

        } else {
            // 기존 회원
            // 이미 최초 온보딩 및 목표 설정을 완료한 사용자
            defaults.set(true, forKey: "onboardingCompleted")
            flow = .main
        }
    }
    

    /*
    /// 카카오/네이버/애플 로그인 성공 결과를 세션에 반영(온보딩API 테스트 시 임시 사용하면 됨)
    func applySocialLoginResult(_ response: SocialLoginResponseDTO) {
        let data = response.data

        applySession(
            accessToken: data.accessToken,
            refreshToken: data.refreshToken,
            userId: data.userId
        )

        // 온보딩 테스트를 위해 임시로 Welcome 화면으로 이동
        defaults.set(false, forKey: "onboardingCompleted")
        flow = .welcome
    }
    */

    // MARK: - Welcome 완료
    /// WelcomeView에서 "시작하기" 버튼을 눌렀을 때 호출
    func completeWelcome() {
        flow = .onboarding
    }

    // MARK: - 온보딩 완료
    /// 온보딩에서 금융 목표 설정까지 성공적으로 완료했을 때 호출
    func completeOnboarding() {
        defaults.set(true, forKey: "onboardingCompleted")
        flow = .main
    }

    // MARK: - 로그아웃
    /// 저장된 모든 세션 정보를 초기화하고 로그인 화면으로 이동
    func logout() {
        _ = keychain.deleteToken()

        accessToken = nil
        refreshToken = nil
        userId = nil

        defaults.removeObject(forKey: "userId")
        defaults.removeObject(forKey: "onboardingCompleted")

        flow = .loggedOut
    }

    // MARK: - 세션 정보 저장

    /// 로그인 성공 시 토큰과 사용자 정보를 저장
    private func applySession(
        accessToken: String,
        refreshToken: String,
        userId: String
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.userId = userId

        // Access Token / Refresh Token은 Keychain에 저장
        keychain.saveToken(
            .init(
                accessToken: accessToken,
                refreshToken: refreshToken
            )
        )

        // 사용자 ID는 UserDefaults에 저장
        defaults.set(userId, forKey: "userId")
    }
}
