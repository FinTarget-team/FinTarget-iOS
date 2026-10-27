//
//  OnboardingQuestionSection.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingQuestionSection: View {
    
    let title: String
    let items: [OnboardingOptionDTO]
    
    @Binding var selectedItem: OnboardingOptionDTO?
    
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
            
            OnboardingWrapButtonView(
                items: items,
                selectedItem: $selectedItem
            )
        }
        .padding(.horizontal, 24)
    }
}
