//
//  Untitled.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import SwiftUI

struct OnboardingWrapButtonView: View {
    
    let items: [OnboardingOptionDTO]
    
    @Binding var selectedItem: OnboardingOptionDTO?
    
    var body: some View {
        
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 110))
            ],
            alignment: .leading,
            spacing: 12
        ) {
            
            ForEach(items, id: \.value) { item in
                
                Button {
                    selectedItem = item
                } label: {
                    
                    Text(item.label)
                        .fontWeight(.semibold)
                        .foregroundStyle(
                            selectedItem?.value == item.value
                            ? .white
                            : .cyan
                        )
                        .padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedItem?.value == item.value
                            ? Color.cyan
                            : Color.clear
                        )
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(Color.cyan, lineWidth: 1.5)
                        }
                }
            }
        }
    }
}
