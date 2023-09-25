//
//  InputPartnerCodeResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/05.
//

import Foundation

// MARK: - Welcome
struct InputPartnerCodeResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: InputPartnerCodeResult?
}

// MARK: - Result
struct InputPartnerCodeResult: Codable {
    let coupleID: Int
    let nickname, partnerNickname: String
    let setMailboxName: Bool

    enum CodingKeys: String, CodingKey {
        case coupleID = "coupleId"
        case nickname, partnerNickname, setMailboxName
    }
}
