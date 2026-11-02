//
//  PolicyRoter.swift
//  FinTarget
//
//  Created by 박병선 on 9/14/26.
import Foundation
import Moya

enum PolicyRouter {
    case getMyPolicies /// 내가 스크랩한 정책 목록 조회
    case createUserPolicy(request: CreateUserPolicyRequestDTO) /// 정책 스크랩 등록
    case getMatchingPolicies(policyType: String?) /// 나에게 맞는 정책 목록 조회
    case deleteUserPolicy(userPolicyId: String) /// 정책 스크랩 삭제

    // MARK: - 정책 AI 채팅

    case askPolicyAI(
        policyId: String,
        request: PolicyAIChatRequestDTO
    ) /// 정책 AI 질문

    case deletePolicyAIChat(
        conversationId: String
    ) /// 정책 AI 대화 삭제
}


// MARK: - TargetType

extension PolicyRouter: TargetType {

    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }

    var path: String {
        switch self {

        case .getMyPolicies:
            return "/api/policies/my"

        case .createUserPolicy:
            return "/api/policies/my"

        case .getMatchingPolicies:
            return "/api/policies"

        case .deleteUserPolicy(let userPolicyId):
            return "/api/policies/my/\(userPolicyId)"

        // MARK: - 정책 AI 채팅

        case .askPolicyAI(let policyId, _):
            return "/api/policies/\(policyId)/ai-chat"

        case .deletePolicyAIChat(let conversationId):
            return "/api/ai-chat/\(conversationId)"
        }
    }

    var method: Moya.Method {
        switch self {

        case .getMyPolicies:
            return .get

        case .createUserPolicy:
            return .post

        case .getMatchingPolicies:
            return .get

        case .deleteUserPolicy:
            return .delete

        // MARK: - 정책 AI 채팅

        case .askPolicyAI:
            return .post

        case .deletePolicyAIChat:
            return .delete
        }
    }

    var task: Task {
        switch self {

        case .getMyPolicies:
            return .requestPlain

        case .createUserPolicy(let request):
            return .requestJSONEncodable(request)

        case .getMatchingPolicies(let policyType):
            if let policyType {
                return .requestParameters(
                    parameters: ["policyType": policyType],
                    encoding: URLEncoding.queryString
                )
            } else {
                return .requestPlain
            }

        case .deleteUserPolicy:
            return .requestPlain

        // MARK: - 정책 AI 채팅

        case .askPolicyAI(_, let request):
            return .requestJSONEncodable(request)

        case .deletePolicyAIChat:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
