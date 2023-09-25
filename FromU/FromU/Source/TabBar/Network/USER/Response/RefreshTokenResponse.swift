//
//  RefreshTokenResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/08/29.
//

import Foundation

// MARK: - Welcome
struct RefreshTokenResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: RefreshTokenResult?
}

// MARK: - Result
struct RefreshTokenResult: Codable {
    let userID: Int
    let jwt, refreshToken: String
    let email: String?
    let userCode: String
    let match, setMailboxName: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case jwt, refreshToken, email, userCode, match, setMailboxName
    }
}
