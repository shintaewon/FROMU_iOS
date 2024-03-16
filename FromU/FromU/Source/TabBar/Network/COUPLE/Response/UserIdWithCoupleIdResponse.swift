//
//  UserIdWithCoupleIdResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/09/25.
//

import Foundation

// MARK: - Welcome
struct UserIdWithCoupleIdResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: UserIdWithCoupleIdResult?
}

// MARK: - Result
struct UserIdWithCoupleIdResult: Codable {
    let coupleID, userId1, userId2: Int
    let mailboxName, firstMetDay, pushMessage: String
    let deleteFlag: Bool

    enum CodingKeys: String, CodingKey {
        case coupleID = "coupleId"
        case userId1, userId2, mailboxName, firstMetDay, pushMessage, deleteFlag
    }
}
