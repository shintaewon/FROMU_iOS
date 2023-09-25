//
//  GetDiaryListResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/14.
//

import Foundation

// MARK: - Welcome
struct GetDiaryListResponse: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String
    let result: [Int]?
    
}
