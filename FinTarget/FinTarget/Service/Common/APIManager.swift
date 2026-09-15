//
//  Untitled.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import Foundation
import Moya
import Alamofire

/// 앱 전체의 네트워크 요청(MoyaProvider)을 생성/관리하는 싱글턴 매니저
/// - 인증이 필요한 요청 / 필요없는 요청 / 테스트용 요청을 각각 다른 Provider로 분리해서 제공
class APIManager: @unchecked Sendable {
    
    // 앱 전체에서 하나의 인스턴스만 사용 (싱글턴)
    static let shared = APIManager()
    
    /// 토큰(Access/Refresh) 조회 및 갱신을 담당하는 객체
    private let tokenProvider: TokenProviding
    
    /// Access Token 만료(401) 시, 자동으로 토큰을 갱신하고 실패했던 요청을 재시도해주는
    /// Alamofire RequestInterceptor 구현체
    private let accessTokenRefresher: AccessTokenRefresher
    
    /// 인증이 필요한 API 요청에 사용할 Alamofire Session
    /// accessTokenRefresher를 interceptor로 등록해서, 모든 요청에 토큰이 자동으로 붙고
    /// 만료 시 자동 갱신되도록 함
    private let session: Session
    
    /// 요청/응답 내용을 콘솔에 로그로 출력해주는 Moya 플러그인 (디버깅용)
    private let loggerPlugin: PluginType
    
    
    private init() {
        // 1. 토큰 저장/조회 담당 객체 생성 (내부적으로 Keychain 사용)
        tokenProvider = TokenProvider()
        
        // 2. 토큰 갱신 인터셉터 생성
        //    tokenProvider를 프로토콜(TokenProviding) 타입 그대로 전달 (강제 캐스팅 없음)
        accessTokenRefresher = AccessTokenRefresher(tokenProviding: tokenProvider)
        
        // 3. accessTokenRefresher를 interceptor로 등록한 Session 생성
        //    → 이 session으로 요청하면 토큰 자동 첨부 + 만료 시 자동 갱신 후 재시도됨
        session = Session(interceptor: accessTokenRefresher)
        
        // 4. 네트워크 로그 플러그인 설정 (.verbose: 요청/응답 상세 로그 출력)
        //     배포 빌드에서는 토큰 등 민감정보가 콘솔에 그대로 찍힐 수 있으니
        //       #if DEBUG로 감싸는 것을 고려할 것
        loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    }
    
    /*
    /// 임시 이니셜라이저 (테스트/디버깅용으로 남겨둔 코드, 현재 미사용)
    /// - interceptor 없는 일반 Session을 써서, 토큰 자동 첨부/갱신 없이 순수 API 응답만 확인하고 싶을 때 사용
    private init() {
        tokenProvider = TokenProvider()
        accessTokenRefresher = AccessTokenRefresher(tokenProviding: tokenProvider)
        
        // 테스트를 위해 인터셉터를 잠시 빼고 일반 Session()으로 설정해 보세요.
        session = Session()
        loggerPlugin = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    }
    */
    
    /// 실제 API 요청용 MoyaProvider 생성
    /// - 인증(토큰)이 필요한 대부분의 API 호출에 사용
    /// - 제네릭 T: TargetType을 받아서, 어떤 API enum(PolicyAPI, GoalAPI 등)이든 이 메서드 하나로 Provider 생성 가능
    public func createProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            session: session,           // 토큰 자동 첨부/갱신되는 session 사용
            plugins: [loggerPlugin]
        )
    }
    
    /// 테스트용 MoyaProvider 생성
    /// - 실제 서버 통신 없이, TargetType에 정의된 sampleData를 즉시 반환 (stubClosure: immediatelyStub)
    /// - UI 개발이나 유닛 테스트 시 서버 없이도 동작 확인 가능
    public func testProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        return MoyaProvider<T>(
            stubClosure: MoyaProvider.immediatelyStub,
            plugins: [loggerPlugin]
        )
    }
}

extension APIManager {
    /// 인증(토큰)이 필요 없는 API 요청용 Provider
    /// - 예: presigned URL을 이용한 파일 업로드처럼, 토큰 대신 다른 방식(임시 URL 자체)으로 인증되는 요청
    /// - interceptor가 없는 순수 Session을 사용하므로 Authorization 헤더가 자동으로 붙지 않음
    ///
    ///  참고: 호출할 때마다 새 Session()을 생성함 → 자주 호출되는 경우 프로퍼티로 미리
    ///          생성해두고 재사용하는 방식으로 개선 가능
    public func createNoAuthProvider<T: TargetType>(for targetType: T.Type) -> MoyaProvider<T> {
        let noInterceptSession = Session()
        return MoyaProvider<T>(
            session: noInterceptSession,
            plugins: [loggerPlugin]
        )
    }
}
