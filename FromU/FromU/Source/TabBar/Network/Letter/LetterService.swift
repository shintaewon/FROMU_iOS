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
}

extension LetterService: TargetType{
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)/letters")!
    }
    
    var path: String {
        
        switch self {
        case .getMainInfoLetter:
            return "/mailbox"
            
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getMainInfoLetter:
            return .get
 
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .getMainInfoLetter:
            return Task.requestPlain

        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .getMainInfoLetter:
        
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        }
    }
}
