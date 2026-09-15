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

    // MARK: - 기존 API 응답 처리
    /// 기존 isSuccess / code / message / result 형식의 API 응답 처리
    func requestResult<T: Decodable>(
        _ target: Target,
        type: T.Type
    ) -> AnyPublisher<T, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> T in

                let decoded: APIResponse<T>

                do {
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

                if decoded.isSuccess {
                    if let result = decoded.result {
                        return result
                    } else {
                        print("⚠️ isSuccess=true but result is nil")
                        throw APIError.decodingError
                    }
                } else {
                    throw APIError.serverError(
                        code: decoded.code,
                        message: decoded.message
                    )
                }
            }
            .mapError { error in
                if let moya = error as? MoyaError {
                    return .moyaError(moya)
                } else if let api = error as? APIError {
                    return api
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }


    // MARK: - FinTarget API 응답 처리
    /// status / message / data 형식의 서버 응답을 DTO 자체로 디코딩
    func requestResponse<T: Decodable>(
        _ target: Target,
        type: T.Type
    ) -> AnyPublisher<T, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> T in

                do {
                    let decoded = try JSONDecoder().decode(
                        T.self,
                        from: moyaResponse.data
                    )

                    return decoded

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
                if let moya = error as? MoyaError {
                    return .moyaError(moya)
                } else if let api = error as? APIError {
                    return api
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }


    // MARK: - 상태 응답 처리
    func requestStatus(
        _ target: Target
    ) -> AnyPublisher<StatusResponseOnly, APIError> {

        return self.requestPublisher(target)
            .tryMap { moyaResponse -> StatusResponseOnly in

                let decoded: StatusResponseOnly

                do {
                    decoded = try JSONDecoder().decode(
                        StatusResponseOnly.self,
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

                if decoded.isSuccess {
                    return decoded
                } else {
                    throw APIError.serverError(
                        code: decoded.code,
                        message: decoded.message
                    )
                }
            }
            .mapError { error in
                if let moya = error as? MoyaError {
                    return .moyaError(moya)
                } else if let api = error as? APIError {
                    return api
                } else {
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
