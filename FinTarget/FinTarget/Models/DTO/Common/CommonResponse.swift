//
//  CommonResponse.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//

import Foundation

// 최상위 응답 모델
public struct APIResponse<T: Decodable>: Decodable, Sendable where T: Sendable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}


// result가 없는 응답 모델
public struct StatusResponseOnly: Codable {
    public let isSuccess: Bool
    public let code: String
    public let message: String
}

