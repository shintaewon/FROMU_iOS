//
//  CheckEmailResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/03/05.
//

import Foundation

// MARK: - Welcome
struct CheckMailResponse: Codable {
    let code: Int?
    let isSuccess: Bool?
    let message: String?
    let result: Bool?
}
