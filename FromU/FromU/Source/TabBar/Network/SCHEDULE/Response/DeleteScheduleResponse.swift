//
//  DeleteScheduleResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/09/26.
//


import Foundation

// MARK: - Welcome
struct DeleteScheduleResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Int?
}
