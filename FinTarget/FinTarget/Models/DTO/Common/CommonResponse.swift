//
//  CommonResponse.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import Foundation

/// 공통 API 응답 모델
public struct APIResponse<T: Decodable>: Decodable {
    
    /// 응답 상태 코드
    public let status: Int
    
    /// 응답 메시지
    public let message: String
    
    /// 실제 응답 데이터
    public let data: T?
}


/// 응답 데이터가 없는 API에서 사용하는 빈 데이터 모델
public struct EmptyData: Decodable { }

