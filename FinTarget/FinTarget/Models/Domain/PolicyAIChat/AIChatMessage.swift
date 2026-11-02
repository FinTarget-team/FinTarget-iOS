//
//  AIChatMessage.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import Foundation

// MARK: - AI 채팅 메시지 모델

/// AI 채팅 화면에서 사용하는 메시지 모델
struct AIChatMessage: Identifiable {
    let id: UUID /// 메시지 고유 ID
    let content: String /// 메시지 내용
    let isUser: Bool /// 사용자 메시지 여부
    let sourceLimited: Bool /// 정책 원문 정보 부족 여부
    let createdAt: Date /// 메시지 생성 시간

    init(
        id: UUID = UUID(),
        content: String,
        isUser: Bool,
        sourceLimited: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.content = content
        self.isUser = isUser
        self.sourceLimited = sourceLimited
        self.createdAt = createdAt

    }

}
