//
//  DiaryBookService.swift
//  FromU
//
//  Created by 신태원 on 2023/03/07.
//

import Moya
import SwiftKeychainWrapper

enum DiaryBookService{
    
    case registerDiaryBook(coverNum: Int,
                           name: String)
    
    case registerDiaryCover
    
}

extension DiaryBookService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)")!
    }
    
    var path: String {
        
        switch self {
        case .registerDiaryBook:
            return "/diarybooks"

        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .registerDiaryBook:
            return .post
        
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .registerDiaryBook(let coverNum, let name):
            return .requestParameters(parameters: ["coverNum": coverNum, "name": name], encoding: JSONEncoding.default)
        
        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .registerDiaryBook:

            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]

        }
    }
}
