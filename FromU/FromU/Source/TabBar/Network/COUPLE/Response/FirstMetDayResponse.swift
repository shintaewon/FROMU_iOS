//
//  FirstMetDayResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/17.
//

import Foundation

// MARK: - Welcome
struct FirstMetDayResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: FirstMetDayResult?
}

// MARK: - Result
struct FirstMetDayResult: Codable {
    let coupleID, userID: Int

    enum CodingKeys: String, CodingKey {
        case coupleID = "coupleId"
        case userID = "userId"
    }
}
