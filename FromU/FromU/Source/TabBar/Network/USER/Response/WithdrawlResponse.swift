//
//  WithdrawlResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/18.
//

import Foundation

// MARK: - Welcome
struct WithdrawlResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: WithdrawlResult
}

// MARK: - Result
struct WithdrawlResult: Codable {
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
