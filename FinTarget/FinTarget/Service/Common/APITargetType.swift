//
//  APITargetType.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {


    var headers: [String: String]? {
        switch task {
        case .requestJSONEncodable, .requestParameters:
            return ["Content-Type": "application/json"]
        case .uploadMultipart:
            return ["Content-Type": "multipart/form-data"]
        default:
            return nil
        }
    }
    
    var validationType: ValidationType { .none }
         
}
