//
//  Config.swift
//  FinTarget
//
//  Created by 박병선 on 5/2/26.
//

import Foundation

enum Config {
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist 없음")
        }
        return dict
    }()
    
    static let baseUrl: String = {
        guard let baseUrl = Config.infoDictionary["BASE_URL"] as? String else {
            fatalError()
        }
        return baseUrl
    }()
    
    static let kakaoKey: String = {
        guard let kakaoKey = Config.infoDictionary["KAKAO_KEY"] as? String else {
            fatalError()
        }
        return kakaoKey
    }()
}
