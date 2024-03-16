//
//  SendLetterResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/05/02.
//

import Foundation

// MARK: - Welcome
struct SendLetterResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let result: SendLetterResult?
    let timestamp, error, message, path: String?
    let status: Int?
}

// MARK: - Result
struct SendLetterResult: Codable {
    let letterID: Int
    let sendMailboxName, receiveMailboxName: String

    enum CodingKeys: String, CodingKey {
        case letterID = "letterId"
        case sendMailboxName, receiveMailboxName
    }
}
