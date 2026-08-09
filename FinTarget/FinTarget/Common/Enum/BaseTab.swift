//
//  BaseTab.swift
//  FinTarget
//
//  Created by 박병선 on 5/4/26.
//
enum BaseTab: CaseIterable {
    case home, simulation, policy, my
    
    var title: String {
        switch self {
        case .home: return "홈"
        case .simulation: return "시뮬레이션"
        case .policy: return "정책"
        case .my: return "마이"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .simulation: return "target"
        case .policy: return "doc.text"
        case .my: return "person"
        }
    }
}
