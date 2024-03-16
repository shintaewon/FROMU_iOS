//
//  StampListResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/08/30.
//

import Foundation

// MARK: - StampListResponse
struct StampListResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: [Int]
}
