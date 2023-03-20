//
//  MailboxViewResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/17.
//

import Foundation

// MARK: - Welcome
struct MailboxViewResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: MailboxViewResult
}

// MARK: - Result
struct MailboxViewResult: Codable {
    let coupleID: Int
    let mailboxName: String
    let newLetterID: Int

    enum CodingKeys: String, CodingKey {
        case coupleID = "coupleId"
        case mailboxName
        case newLetterID = "newLetterId"
    }
}


