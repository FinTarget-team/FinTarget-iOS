//
//  SocialButton.swift
//  FinTarget
//
//  Created by 박병선 on 8/30/26.
//
import SwiftUI

struct SocialButton: View {
    
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button {
            print("\(text)")
            action()
        } label: {
            HStack(spacing: 12) {
                
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
        }
    }
}
