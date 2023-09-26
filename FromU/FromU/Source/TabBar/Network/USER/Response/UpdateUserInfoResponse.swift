//
//  UpdateUserInfoResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/09/26.
//

import Foundation

// MARK: - Welcome
struct UpdateUserInfoResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UpdateUserInfoResult
}

// MARK: - Result
struct UpdateUserInfoResult: Codable {
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
