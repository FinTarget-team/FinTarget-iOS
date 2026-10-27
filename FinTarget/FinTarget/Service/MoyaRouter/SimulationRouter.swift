//
//  SimulationRouter.swift
//  FinTarget
//
//  Created by 박병선 on 9/14/26.
import Foundation
import Moya

enum SimulationRouter {
    case getSimulations /// 내 시뮬레이션 이력 전체 조회
    case runSimulation(request: RunSimulationRequestDTO) /// 목표 달성 시뮬레이션 실행
    case getSimulationsByGoal(goalId: String) /// 특정 목표의 시뮬레이션 이력 조회
}

extension SimulationRouter: TargetType {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }
    
    var path: String {
        switch self {
        case .getSimulations: /// 내 시뮬레이션 이력 전체 조회
            return "/api/simulations"
        case .runSimulation: /// 목표 달성 시뮬레이션 실행
            return "/api/simulations"
        case .getSimulationsByGoal(let goalId): /// 특정 목표의 시뮬레이션 이력 조회
            return "/api/simulations/goal/\(goalId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSimulations: /// 내 시뮬레이션 이력 전체 조회
            return .get
        case .runSimulation: /// 목표 달성 시뮬레이션 실행
            return .post
        case .getSimulationsByGoal: /// 특정 목표의 시뮬레이션 이력 조회
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getSimulations: /// 내 시뮬레이션 이력 전체 조회
            return .requestPlain
            
        case .runSimulation(let request): /// 목표 달성 시뮬레이션 실행
            return .requestJSONEncodable(request)
            
        case .getSimulationsByGoal: /// 특정 목표의 시뮬레이션 이력 조회
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
