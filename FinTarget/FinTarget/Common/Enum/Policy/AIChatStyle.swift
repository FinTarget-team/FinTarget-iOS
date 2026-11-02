//
//  AIChatStyle.swift
//  FinTarget
//
//  Created by 박병선 on 11/2/26.
//
import SwiftUI

// MARK: - AI Chat Style

/// 정책 AI 채팅 화면에서 사용하는 공통 색상
enum AIChatStyle {

    /// 메인 파란색
    static let primaryBlue = Color(
        red: 0.20,
        green: 0.39,
        blue: 0.91
    )

    /// 채팅 화면 배경색
    static let backgroundColor = Color(
        red: 0.965,
        green: 0.973,
        blue: 0.988
    )

    /// 보조 텍스트 색상
    static let secondaryTextColor = Color(
        red: 0.35,
        green: 0.41,
        blue: 0.51
    )

    /// AI 아이콘 색상
    static let aiColor = Color(
        red: 0.02,
        green: 0.65,
        blue: 0.65
    )

    /// 카드 테두리 색상
    static let borderColor = Color.gray.opacity(0.15)
}
