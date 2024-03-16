//
//  GetLetterListResposne.swift
//  FromU
//
//  Created by 신태원 on 2023/08/07.
//

import Foundation

// MARK: - Welcome
struct GetLetterListResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [GetLetterListResult]
}

// MARK: - Result
struct GetLetterListResult: Codable {
    let letterID: Int
    let mailboxName, time: String
    let readFlag: Bool
    let status: Int

    enum CodingKeys: String, CodingKey {
        case letterID = "letterId"
        case mailboxName, time, readFlag, status
    }
}
