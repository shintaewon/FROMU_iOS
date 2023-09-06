//
//  LoginResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/04.
//

import Foundation

// MARK: - LoginResponse
struct LoginResponse: Codable {
    let code: Int?
    let isSuccess: Bool?
    let message: String
    let result: LoginResult?
}

// MARK: - LoginResult
struct LoginResult: Codable {
    let member: Bool
    let userInfo: LoginUserInfo?
}

// MARK: - LoginUserInfo
struct LoginUserInfo: Codable {
    let email, jwt: String
    let match: Bool
    let refreshToken: String
    let setMailboxName: Bool
    let userCode: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case email, jwt, match, refreshToken, setMailboxName, userCode
        case userID = "userId"
    }
}
