//
//  NudgeRouter.swift
//  FinTarget
//
//  Created by 박병선 on 9/14/26.
import Foundation
import Moya

enum NudgeRouter {
    case getNudges /// 넛지 목록 조회
    case readNudge(nudgeId: String) /// 넛지 알림 읽음 처리
    case deleteNudge(nudgeId: String) /// 넛지 삭제
}

// MARK: - TargetType
extension NudgeRouter: TargetType {

    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }

    var path: String {
        switch self {
        case .getNudges:
            return "/nudges"

        case .readNudge(let nudgeId):
            return "/nudges/\(nudgeId)/read"
            
        case .deleteNudge(let nudgeId):
            return "/nudges/\(nudgeId)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getNudges:
            return .get

        case .readNudge:
            return .patch
            
        case .deleteNudge:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case .getNudges, .readNudge, .deleteNudge:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
