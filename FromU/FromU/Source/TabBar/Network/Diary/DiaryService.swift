//
//  DiaryService.swift
//  FromU
//
//  Created by 신태원 on 2023/03/14.
//

import Moya
import SwiftKeychainWrapper

enum DiaryService{
    
    case getDiaryList
    
    case getDiaryInfo(diaryID: Int)
}

extension DiaryService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)/diaries")!
    }
    
    var path: String {
        
        switch self {
        case .getDiaryList:
            
            print("diaryId:", UserDefaults.standard.integer(forKey: "diaryBookID"))
            return "/all/\(UserDefaults.standard.integer(forKey: "diaryBookID") )"
            
        case .getDiaryInfo:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getDiaryList:
            return .get
        
        case .getDiaryInfo:
            return .get
        }
        
    }
    
    var task: Moya.Task {
        switch self {
            
        case .getDiaryList:
            return Task.requestPlain
        
        case .getDiaryInfo(let diaryID):
            return .requestParameters(parameters: ["diaryId": diaryID], encoding: URLEncoding.queryString)
        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .getDiaryList:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .getDiaryInfo:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]

        }
    }
}
