//
//  RegisterTokenResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/10/04.
//

import Foundation

// MARK: - RegisterTokenResponse
struct RegisterTokenResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: RegisterTokenResult?
}

// MARK: - Result
struct RegisterTokenResult: Codable {
    let userID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
