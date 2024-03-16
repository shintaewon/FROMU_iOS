//
//  ReadLetterResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/08/11.
//

import Foundation

// MARK: - Welcome
struct ReadLetterResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: ReadLetterResult
}

// MARK: - Result
struct ReadLetterResult: Codable {
    let letterID, stamp: Int
    let content, sendMailboxName, receiveMailboxName, time: String
    let status: Int
    let replyFalg, scoreFlag: Bool

    enum CodingKeys: String, CodingKey {
        case letterID = "letterId"
        case stamp, content, sendMailboxName, receiveMailboxName, time, status, replyFalg, scoreFlag
    }
}
