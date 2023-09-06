//
//  LetterService.swift
//  FromU
//
//  Created by 신태원 on 2023/04/17.
//

import Moya
import SwiftKeychainWrapper

enum LetterService{
    
    case getMainInfoLetter
    
    case sendLetter(content: String, stampNum: Int)
    
    case getLetterList(type: String)
    
    case readLetter(letterId: String)
    
    case reportLetter(letterId: String, content: String)
    
    case sendReview(letterId: String, score: Int)
}

extension LetterService: TargetType{
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)/letters")!
    }
    
    var path: String {
        
        switch self {
        case .getMainInfoLetter:
            return "/mailbox"
            
        case .sendLetter:
            return ""
            
        case .getLetterList:
            return "/mailbox"
            
        case .readLetter(let letterId):
            return "/\(letterId)/read"
            
        case .reportLetter(let letterId, _):
            return "/\(letterId)/report"
            
        case .sendReview(let letterId, _):
            return "/\(letterId)/score"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getMainInfoLetter:
            return .get
 
        case .sendLetter:
            return .post
            
        case .getLetterList:
            return .get
            
        case .readLetter:
            return .patch
            
        case .reportLetter:
            return .post
            
        case .sendReview:
            return .patch
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .getMainInfoLetter:
            return Task.requestPlain

        case .sendLetter(let content, let stampNum):
            return .requestParameters(parameters: ["content": content, "stampNum": stampNum], encoding: JSONEncoding.default)
            
        case .getLetterList(let type):
            return .requestParameters(parameters: ["type": type], encoding: URLEncoding.queryString)
            
        case .readLetter:
            return Task.requestPlain
            
        case .reportLetter(_, let content):
            return .requestParameters(parameters: ["content": content], encoding: JSONEncoding.default)
            
        case .sendReview(_, let score):
            return .requestParameters(parameters: ["score": score], encoding: JSONEncoding.default)
        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .getMainInfoLetter:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .sendLetter:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
    
        case .getLetterList:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .readLetter:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .reportLetter:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .sendReview:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        }
    }
}
