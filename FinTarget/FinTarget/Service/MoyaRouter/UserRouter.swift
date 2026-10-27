//
//  UserRouter.swift
//  FinTarget
//
//  Created by 박병선 on 9/28/26.

import Foundation
import Moya

enum UserRouter {
    /// 내 프로필 조회
    case getMyProfile
    
    /// 프로필 수정
    case updateMyProfile(request: UpdateUserProfileRequestDTO)
    
    /// 회원 탈퇴
    case withdraw
}

extension UserRouter: TargetType {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }
    
    var path: String {
        switch self {
        case .getMyProfile:
            return "/users/me"
        case .updateMyProfile:
            return "/users/me/profile"
        case .withdraw:
            return "/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMyProfile:
            return .get
        case .updateMyProfile:
            return .put
        case .withdraw:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getMyProfile:
            return .requestPlain
            
        case .updateMyProfile(let request):
            return .requestJSONEncodable(request)
            
        case .withdraw:
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
}
