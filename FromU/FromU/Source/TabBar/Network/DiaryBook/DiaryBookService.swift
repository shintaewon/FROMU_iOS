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
    case getDiaryCover
    
    case sendDiaryBook
}

extension DiaryBookService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)")!
    }
    
    var path: String {
        
        switch self {
        case .registerDiaryBook:
            return "/diarybooks"
            
        case .getDiaryCover:
            return "/diarybooks/firstPage"
            
        case .sendDiaryBook:
            return "/diarybooks/pass"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .registerDiaryBook:
            return .post
            
        case .getDiaryCover:
            return .get
        
        case .sendDiaryBook:
            return .patch
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .registerDiaryBook(let coverNum, let name):
            return .requestParameters(parameters: ["coverNum": coverNum, "name": name], encoding: JSONEncoding.default)
        
        case .getDiaryCover:
            return Task.requestPlain
            
        case .sendDiaryBook:
            return Task.requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .registerDiaryBook:

            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]

        case .getDiaryCover:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .sendDiaryBook:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        }
    }
}
