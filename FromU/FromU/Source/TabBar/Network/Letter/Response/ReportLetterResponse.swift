//
//  ReportLetterResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/08/22.
//

import Foundation

// MARK: - Welcome
struct ReportLetterResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: Int?
}
