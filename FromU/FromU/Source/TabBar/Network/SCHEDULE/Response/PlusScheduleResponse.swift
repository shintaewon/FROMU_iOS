//
//  PlusScheduleResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/09/18.
//

import Foundation

// MARK: - Welcome
struct PlusScheduleResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Int
}
