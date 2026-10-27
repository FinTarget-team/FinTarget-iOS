
//  OnboaringButtonSection.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingButtonSection: View {
    
    let action: () -> Void
    
    var body: some View {
        
        HStack {
            Spacer()
            
            Button {
                action()
            } label: {
                Circle()
                    .fill(Color.cyan.opacity(0.15))
                    .frame(width: 56, height: 56)
                    .overlay {
                        Image(systemName: "paperplane")
                            .foregroundStyle(.cyan)
                    }
            }
        }
        .padding(.horizontal, 24)
    }
}

