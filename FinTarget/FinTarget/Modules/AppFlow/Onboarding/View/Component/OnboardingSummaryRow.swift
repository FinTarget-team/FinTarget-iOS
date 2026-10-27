//
//  OnboardingSummaryView.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingSummaryRow: View {
    
    let title: String
    let value: String
    
    var body: some View {
        
        HStack {
            
            Text(title)
                .foregroundStyle(.gray)
            
            Spacer()
            
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

