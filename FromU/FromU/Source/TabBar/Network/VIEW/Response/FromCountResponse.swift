//
//  FromCountResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/16.
//

import Foundation

// MARK: - Welcome
struct FromCountResponse: Codable {
    let code: Int
    let isSuccess: Bool
    let message: String
    let result: Int
}
