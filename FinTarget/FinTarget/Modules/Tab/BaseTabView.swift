//
//  BaseTabView.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
import SwiftUI

struct BaseTabView: View {

    // MARK: - Properties

    @EnvironmentObject private var sessionManager: SessionManager

    @State private var selectedTab: BaseTab = .home

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ZStack {

                // MARK: - 현재 화면

                switch selectedTab {

                case .home:
                    HomeView(selectedTab: $selectedTab)

                case .simulation:
                    SimulationView()

                case .policy:
                    PolicyView()

                case .my:
                    MyPageView(sessionManager: sessionManager)
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
}
