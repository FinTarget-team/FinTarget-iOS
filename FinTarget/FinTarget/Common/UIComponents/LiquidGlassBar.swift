//
//  LiquidGlassBar.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
import SwiftUI

struct LiquidGlassTabBar: View {
    
    @Binding var selectedTab: BaseTab
    
    var body: some View {
        HStack {
            ForEach(BaseTab.allCases, id: \.self) { tab in
                tabItem(tab)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            .ultraThinMaterial
        )
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
    
    private func tabItem(_ tab: BaseTab) -> some View {
        Button {
            withAnimation(.spring()) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                
                Image(systemName: selectedTab == tab ? "\(tab.icon).fill" : tab.icon)
                    .font(.system(size: 25))
                
                Text(tab.title)
                    .font(.PretendardSemiBold(size: 15))
            }
            .foregroundColor(selectedTab == tab ? .black : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}
