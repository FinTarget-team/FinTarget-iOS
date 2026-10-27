//
//  OnboardingAnswerBubble.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//

import SwiftUI

struct OnboardingAnswerBubble: View {
    
    let text: String
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Text(text)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 22)
                .padding(.vertical, 14)
                .background(Color.cyan.opacity(0.5))
                .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .padding(.horizontal, 24)
    }
}

