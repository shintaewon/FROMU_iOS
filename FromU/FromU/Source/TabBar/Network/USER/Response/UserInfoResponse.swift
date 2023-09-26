//
//  UserInfoResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/09/25.
//

import Foundation

// MARK: - UserInfoResponse
struct UserInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UserInfoResult?
}

// MARK: - UserInfoResult
struct UserInfoResult: Codable {
    let userID: Int
    let email, nickname, birthday, gender: String
    let userCode: String
    let deleteFlag: Bool
    let refreshToken: String
    let deviceToken: String?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case email, nickname, birthday, gender, userCode, deleteFlag, refreshToken, deviceToken
    }
}
