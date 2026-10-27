//
//  Untitled.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//

import SwiftUI

struct OnboardingQuestionTitle: View {
    
    let title: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            
            Circle()
                .fill(Color.cyan)
                .frame(width: 44, height: 44)
                .overlay {
                    Image(systemName: "person.fill")
                        .foregroundStyle(.white)
                }
            
            Text(title)
                .font(.title3.bold())
        }
        .padding(.horizontal, 24)
    }
}
