//
//  BaseTabView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
import SwiftUI

struct BaseTabView: View {
    
    @State private var selectedTab: BaseTab = .home
    
    var body: some View {
        ZStack {
            
            // MARK: - 현재 화면
            switch selectedTab {
            case .home:
                HomeView()
            case .simulation:
                SimulationView()
            case .policy:
                PolicyView()
            case .my:
                MyPageView()
            }
            
            // MARK: - Liquid Glass TabBar
            VStack {
                Spacer()
                
                LiquidGlassTabBar(selectedTab: $selectedTab)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    BaseTabView()
}
