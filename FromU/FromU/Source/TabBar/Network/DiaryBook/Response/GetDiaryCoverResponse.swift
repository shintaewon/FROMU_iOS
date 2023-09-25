//
//  GetDiaryCoverResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/13.
//

import Foundation

// MARK: - Welcome
struct GetDiaryCoverResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: GetDiaryCoverResult
}

// MARK: - Result
struct GetDiaryCoverResult: Codable {
    let diarybookID: Int
    let imageURL, name: String
    let writeFlag: Bool

    enum CodingKeys: String, CodingKey {
        case diarybookID = "diarybookId"
        case imageURL = "imageUrl"
        case name, writeFlag
    }
}
