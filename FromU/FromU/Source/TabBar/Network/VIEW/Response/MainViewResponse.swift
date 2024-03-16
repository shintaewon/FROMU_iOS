//
//  MainViewResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/06.
//

import Foundation

// MARK: - Welcome
struct MainViewResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: MainViewResult?
}

// MARK: - Result
struct MainViewResult: Codable {
    let dday: Int
    let diarybook: Diarybook?
    let diarybookStatus: Int
//    * 일기장이 생성되지 않았으면 0
//    * 일기장이 나에게 있으면 1
//    * 일기장이 오는 중이면 2
//    * 일기장이 가는 중이면 3
//    * 일기장이 상대한테 있으면 4
    let nickname, partnerNickname: String
}

// MARK: - Diarybook
struct Diarybook: Codable {
    let coverNum: Int
    let diarybookID: Int?
    let imageURL: String?
    let name: String
    let writeFlag: Bool

    enum CodingKeys: String, CodingKey {
        case coverNum, writeFlag
        case diarybookID = "diarybookId"
        case imageURL = "imageUrl"
        case name
    }
}
