//
//  RefreshResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/05.
//

import Foundation

// MARK: - Welcome
struct RefreshResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: RefreshResult?
}

// MARK: - Result
struct RefreshResult: Codable {
    let coupleRes: CoupleRes?
    let match: Bool
}

// MARK: - CoupleRes
struct CoupleRes: Codable {
    let coupleID: Int
    let nickname, partnerNickname: String
    let setMailboxName: Bool

    enum CodingKeys: String, CodingKey {
        case coupleID = "coupleId"
        case nickname, partnerNickname, setMailboxName
    }
}
