//
//  GetCalendarSchedulesResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/09/03.
//

import Foundation

// MARK: - GetCalendarSchedulesResponse
struct GetCalendarSchedulesResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [GetCalendarSchedulesResult?]
}

// MARK: - GetCalendarSchedulesResult
struct GetCalendarSchedulesResult: Codable {
    let scheduleID: Int
    let content, date: String
    let userID: Int
    let nickname: String
    let editable: Bool

    enum CodingKeys: String, CodingKey {
        case scheduleID = "scheduleId"
        case content, date
        case userID = "userId"
        case nickname, editable
    }
}
