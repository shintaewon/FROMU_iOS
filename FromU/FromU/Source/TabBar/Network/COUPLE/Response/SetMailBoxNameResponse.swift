//
//  SetMailBoxNameResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/05.
//

import Foundation

// MARK: - Welcome
struct SetMailBoxNameResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: SetMailBoxNameResult?
}

// MARK: - Result
struct SetMailBoxNameResult: Codable {
    let coupleID, userID: Int

    enum CodingKeys: String, CodingKey {
        case coupleID = "coupleId"
        case userID = "userId"
    }
}
