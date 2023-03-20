//
//  RegisterDiaryCoverResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/13.
//

import Foundation

// MARK: - Welcome
struct RegisterDiaryCoverResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: RegisterDiaryCoverResult
}

// MARK: - Result
struct RegisterDiaryCoverResult: Codable {
    let diarybookID, userID: Int

    enum CodingKeys: String, CodingKey {
        case diarybookID = "diarybookId"
        case userID = "userId"
    }
}
