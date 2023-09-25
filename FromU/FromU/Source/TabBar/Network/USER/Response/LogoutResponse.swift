//
//  LogoutResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/18.
//

import Foundation

// MARK: - Welcome
struct LogoutResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: LogoutResult?
}

// MARK: - Result
struct LogoutResult: Codable {
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
