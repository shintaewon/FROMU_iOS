//
//  GetDiaryResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/14.
//

import Foundation

// MARK: - Welcome
struct GetDiaryResponse: Codable {
    let code: Int
    let isSuccess: Bool?
    let message: String
    let result: GetDiaryResult?
}

// MARK: - Result
struct GetDiaryResult: Codable {
    let content, date: String
    let day, diaryID: Int
    let imageURL, weather, writerNickname: String

    enum CodingKeys: String, CodingKey {
        case content, date, day
        case diaryID = "diaryId"
        case imageURL = "imageUrl"
        case weather, writerNickname
    }
}
