//
//  BuyStampResponse.swift
//  FromU
//
//  Created by 신태원 on 2023/09/03.
//

import Foundation

// MARK: - BuyStampResponse
struct BuyStampResponse: Codable {
    let isSuccess: Bool
    let code: Int
    let message: String
    let result: BuyStampResult?
}

// MARK: - BuyStampResult
struct BuyStampResult: Codable {
    let userID, coupleID: Int

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case coupleID = "coupleId"
    }
}
