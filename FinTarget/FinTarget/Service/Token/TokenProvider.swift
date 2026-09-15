//
//  TokenProvider.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import Foundation
import Moya

/// 토큰(Access/Refresh Token)을 저장/조회/갱신하는 역할을 담당하는 클래스
/// - Keychain에 실제 토큰 값을 저장하고
/// - 필요할 때 서버에 refresh 요청을 보내 토큰을 갱신함
/// - AccessTokenRefresher(Alamofire Interceptor)가 이 클래스를 통해 토큰을 다룸
class TokenProvider: TokenProviding {
    
    /// Keychain에 토큰을 저장할 때 사용하는 식별 키(계정명 역할)
    /// ⚠️ "appNameUser"는 임시값으로 보임 — 실제 앱 이름/식별자로 교체 필요
    private let userSession = "appNameUser"
    
    /// Keychain 접근을 담당하는 싱글턴 서비스 (토큰의 실제 저장소)
    private let keyChain = KeychainService.shared
    
    /// 토큰 갱신 API(/auth/token/refresh)를 호출하기 위한 Moya Provider
    /// AuthRouter는 인증 관련 엔드포인트(로그인, 토큰 갱신 등)를 정의한 TargetType
    private let provider = MoyaProvider<AuthRouter>()
    
    // MARK: - Access Token
    
    /// Access Token 조회/저장
    /// - get: Keychain에서 저장된 유저 정보를 읽어와 accessToken만 반환
    /// - set: Keychain에 저장된 유저 정보를 불러온 뒤, accessToken만 갱신해서 다시 저장
    var accessToken: String? {
        get {
            // Keychain에 저장된 토큰 정보(userInfo)가 없으면 nil 반환
            guard let userInfo = keyChain.loadToken() else { return nil }
            return userInfo.accessToken
        }
        set {
            // 저장된 토큰 정보가 없으면 애초에 갱신할 대상이 없으므로 종료
            guard var userInfo = keyChain.loadToken() else { return }
            // newValue가 nil이면 "토큰 정보 없음" 문자열로 대체 저장
            // ⚠️ nil을 그냥 저장하지 않고 문자열로 바꾸는 방식이라, 추후 "토큰 정보 없음" 문자열을
            //     실제 유효 토큰으로 착각해서 API 요청에 실어 보내지 않도록 주의 필요
            userInfo.accessToken = newValue ?? "토큰 정보 없음"
            keyChain.saveToken(userInfo)
        }
    }
    
    // MARK: - Refresh Token
    
    /// Refresh Token 조회/저장 (구조는 accessToken과 동일)
    var refreshToken: String? {
        get {
            guard let userInfo = keyChain.loadToken() else { return nil }
            return userInfo.refreshToken
        }
        set {
            guard var userInfo = keyChain.loadToken() else { return }
            userInfo.refreshToken = newValue ?? "토큰 정보 없음"
            keyChain.saveToken(userInfo)
        }
    }
    
    // MARK: - 토큰 갱신 요청
    
    /// 저장된 Refresh Token으로 서버에 새 Access/Refresh Token 발급을 요청
    /// - AccessTokenRefresher가 401 응답을 받았을 때 이 메서드를 호출해서 토큰을 갱신함
    /// - completion: 성공 시 (새 accessToken, nil), 실패 시 (nil, error)
    func refreshToken(completion: @escaping (String?, (any Error)?) -> Void) {
        
        // 1. Keychain에 저장된 토큰 정보가 아예 없으면 갱신 자체가 불가능 → 에러 반환
        guard let userInfo = keyChain.loadToken() else {
            let error = NSError(
                domain: "example.com",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "UserSession or refreshToken not found"]
            )
            completion(nil, error)
            return
        }
        
        let refreshToken = userInfo.refreshToken
        
        // 2. 서버에 보낼 요청 DTO 생성 (refreshToken을 body에 담아 보냄)
        let requestDTO = RefreshTokenRequestDTO(refreshToken: refreshToken)
        
        // 3. /auth/token/refresh API 호출
        provider.request(.refreshToken(request: requestDTO)) { result in
            switch result {
            case .success(let response):
                
                // 디버깅용: 응답 원본 JSON을 콘솔에 출력
                //  배포 빌드에서는 토큰이 그대로 로그에 찍히므로 보안상 제거하거나
                //   #if DEBUG로 감싸는 게 안전함
                if let jsonString = String(data: response.data, encoding: .utf8) {
                    print("응답 JSON: \(jsonString)")
                } else {
                    print("JSON 데이터를 문자열로 변환할 수 없습니다.")
                }

                do {
                    // 4. 응답 JSON을 TokenInfo(accessToken, refreshToken 등)로 디코딩
                    let tokenData = try JSONDecoder().decode(TokenInfo.self, from: response.data)

                    // 5. 새로 받은 토큰을 Keychain에 저장
                    //    (위에서 정의한 accessToken/refreshToken의 set 로직이 실행됨)
                    self.accessToken = tokenData.accessToken
                    self.refreshToken = tokenData.refreshToken

                    // 6. 갱신 성공 → 새 accessToken을 completion으로 전달
                    completion(self.accessToken, nil)
                } catch {
                    // 디코딩 실패 (응답 형식이 예상과 다름 등)
                    print("디코딩 에러: \(error)")
                    completion(nil, error)
                }

            case .failure(let error):
                // 네트워크 요청 자체 실패 (서버 다운, refreshToken 만료로 인한 401 등)
                // → 이 경우 보통 상위 로직(SessionManager 등)에서 로그아웃 처리로 이어짐
                print("네트워크 에러 : \(error)")
                completion(nil, error)
            }
        }
    }
}
