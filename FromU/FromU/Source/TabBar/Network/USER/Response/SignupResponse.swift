//
//  SignupResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/05.
//

import Foundation

// MARK: - Welcome
struct SignupResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: SignupResult
}

// MARK: - Result
struct SignupResult: Codable {
    let jwt, refreshToken, userCode: String
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case jwt, refreshToken, userCode
        case userID = "userId"
    }
}
