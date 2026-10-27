//
//  GoalRouter.swift
//  FinTarget
//
//  Created by 박병선 on 9/29/26.
//
import Foundation
import Moya

enum GoalRouter {
    case getGoal /// 내 목표 조회
    case createGoal(request: CreateGoalRequestDTO) /// 목표 생성
    case updateGoal(request: UpdateGoalRequestDTO) /// 목표 수정
    case deleteGoal /// 목표 삭제
}

extension GoalRouter: TargetType {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }
    
    var path: String {
        switch self {
        case .getGoal:
            return "/api/goals"
        case .createGoal:
            return "/api/goals"
        case .updateGoal:
            return "/api/goals"
        case .deleteGoal:
            return "/api/goals"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getGoal:
            return .get
        case .createGoal:
            return .post
        case .updateGoal:
            return .put
        case .deleteGoal:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getGoal, .deleteGoal:
            return .requestPlain
            
        case .createGoal(let request):
            return .requestJSONEncodable(request)
            
        case .updateGoal(let request):
            return .requestJSONEncodable(request)
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
