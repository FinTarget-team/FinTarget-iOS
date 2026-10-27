//
//  ExpenseRouter.swift
//  FinTarget
//
//  Created by 박병선 on 9/14/26.
//
//
//  ExpenseRouter.swift
//  FinTarget
//

import Foundation
import Moya

enum ExpenseRouter {
    case syncExpenses(request: [ExpenseSyncRequestDTO]) /// 지출 내역 동기화
    case getExpenses /// 전체 지출 내역 조회
    case getExpensesByPeriod(start: String, end: String) /// 기간별 지출 내역 조회
    case getExpenseStats(start: String, end: String) /// 기간별 카테고리 통계 조회
}

extension ExpenseRouter: TargetType {
    
    var baseURL: URL {
        switch self {
        default:
            return URL(string: "\(Config.baseUrl)")!
        }
    }
    
    var path: String {
        switch self {
        case .syncExpenses:
            return "/api/expenses/sync"
        case .getExpenses:
            return "/api/expenses"
        case .getExpensesByPeriod:
            return "/api/expenses/period"
        case .getExpenseStats:
            return "/api/expenses/stats"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .syncExpenses:
            return .post
        case .getExpenses, .getExpensesByPeriod, .getExpenseStats:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .syncExpenses(let request):
            return .requestJSONEncodable(request)
            
        case .getExpenses:
            return .requestPlain
            
        case .getExpensesByPeriod(let start, let end):
            return .requestParameters(
                parameters: [
                    "start": start,
                    "end": end
                ],
                encoding: URLEncoding.queryString
            )
            
        case .getExpenseStats(let start, let end):
            return .requestParameters(
                parameters: [
                    "start": start,
                    "end": end
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }
}
