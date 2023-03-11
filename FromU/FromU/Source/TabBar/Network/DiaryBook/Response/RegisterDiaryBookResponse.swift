//
//  RegisterDiaryBookResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/07.
//

import Foundation

// MARK: - Welcome
struct RegisterDiaryBookResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: RegisterDiaryBookResult
}

// MARK: - Result
struct RegisterDiaryBookResult: Codable {
    let coverNum, diarybookID: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case coverNum
        case diarybookID = "diarybookId"
        case name
    }
}
