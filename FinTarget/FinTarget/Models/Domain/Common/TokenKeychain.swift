//
//  TokenKeychain.swift
//  FinTarget
//
//  Created by 박병선 on 8/23/26.
//
import Foundation

protocol TokenProviding {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}

struct TokenInfo: Codable {
    var accessToken: String
    var refreshToken: String
}
