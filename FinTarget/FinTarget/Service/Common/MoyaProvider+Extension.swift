//
//  MoyaProvider+Extension.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import SwiftUI
import Combine
import Moya
import CombineMoya

extension MoyaProvider {

    // MARK: - 데이터가 있는 API 응답 처리
    /// status / message / data 형식의 공f통 API 응답 처리
    /// data가 존재하는 API에서 사용
    func requestResult<T: Decodable>(
        _ target: Target,
        type: T.Type
    ) -> AnyPublisher<T, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> T in

                let decoded: APIResponse<T>

                do {
                    /// 서버 응답을 APIResponse<T> 형태로 디코딩
                    decoded = try JSONDecoder().decode(
                        APIResponse<T>.self,
                        from: moyaResponse.data
                    )
                } catch {
                    print("❌ decode error:", error)
                    print(
                        "RAW:",
                        String(data: moyaResponse.data, encoding: .utf8) ?? "nil"
                    )

                    throw APIError.decodingError
                }

                /// HTTP 상태 코드가 200번대가 아닌 경우 서버 에러 처리
                guard (200..<300).contains(decoded.status) else {
                    throw APIError.serverError(
                        code: String(decoded.status),
                        message: decoded.message
                    )
                }

                /// 성공했지만 data가 없는 경우
                guard let data = decoded.data else {
                    print("⚠️ API 요청 성공했지만 data가 nil입니다.")
                    throw APIError.decodingError
                }

                return data
            }
            .mapError { error in

                if let moyaError = error as? MoyaError {
                    return .moyaError(moyaError)
                }

                if let apiError = error as? APIError {
                    return apiError
                }

                return .unknown
            }
            .eraseToAnyPublisher()
    }


    // MARK: - 공통 응답 전체가 필요한 API 처리
    /// status / message / data 전체 응답을 반환
    func requestResponse<T: Decodable>(
        _ target: Target,
        type: T.Type
    ) -> AnyPublisher<T, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> T in

                /// HTTP 상태 코드 확인
                guard (200..<300).contains(moyaResponse.statusCode) else {

                    switch moyaResponse.statusCode {

                    case 401:
                        throw APIError.unauthorized

                    case 403:
                        throw APIError.forbidden

                    case 404:
                        throw APIError.notFound

                    default:
                        throw APIError.serverError(
                            code: String(moyaResponse.statusCode),
                            message: "서버 요청에 실패했습니다."
                        )
                    }
                }

                do {
                    /// 서버 응답 전체 디코딩
                    return try JSONDecoder().decode(
                        T.self,
                        from: moyaResponse.data
                    )
                } catch {
                    print("❌ decode error:", error)
                    print(
                        "RAW:",
                        String(data: moyaResponse.data, encoding: .utf8) ?? "nil"
                    )

                    throw APIError.decodingError
                }
            }
            .mapError { error in

                if let moyaError = error as? MoyaError {
                    return .moyaError(moyaError)
                }

                if let apiError = error as? APIError {
                    return apiError
                }

                return .unknown
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - 데이터가 없는 API 응답 처리
    /// data가 null인 API에서 사용
    func requestStatus(
        _ target: Target
    ) -> AnyPublisher<APIResponse<EmptyData>, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> APIResponse<EmptyData> in

                let decoded: APIResponse<EmptyData>

                do {
                    /// data가 null인 공통 응답 디코딩
                    decoded = try JSONDecoder().decode(
                        APIResponse<EmptyData>.self,
                        from: moyaResponse.data
                    )
                } catch {
                    print("❌ decode error:", error)
                    print(
                        "RAW:",
                        String(data: moyaResponse.data, encoding: .utf8) ?? "nil"
                    )

                    throw APIError.decodingError
                }

                /// 서버 응답 상태 코드 확인
                guard (200..<300).contains(decoded.status) else {
                    throw APIError.serverError(
                        code: String(decoded.status),
                        message: decoded.message
                    )
                }

                return decoded
            }
            .mapError { error in

                if let moyaError = error as? MoyaError {
                    return .moyaError(moyaError)
                }

                if let apiError = error as? APIError {
                    return apiError
                }

                return .unknown
            }
            .eraseToAnyPublisher()
    }
}
