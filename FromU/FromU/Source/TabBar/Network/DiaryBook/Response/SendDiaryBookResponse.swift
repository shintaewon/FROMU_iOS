//
//  SendDiaryBookResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/15.
//

import Foundation

// MARK: - Welcome
struct SendDiaryBookResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: SendDiaryBookResult?
}

// MARK: - Result
struct SendDiaryBookResult: Codable {
    let diarybookID, userID: Int

    enum CodingKeys: String, CodingKey {
        case diarybookID = "diarybookId"
        case userID = "userId"
    }
}
