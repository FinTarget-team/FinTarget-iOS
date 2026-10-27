//
//  OnboardingAnswer.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import Foundation


/// 완료된 온보딩 질문과 답변
struct OnboardingAnswer: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}

/// 후에 View에서
/*
 ForEach(viewModel.answeredQuestions) { item in
 이전 질문
Text(item.question)

// 내가 선택한 답변
AnswerBubble(text: item.answer)
}
 
 이런 식으로 사용함
*/
