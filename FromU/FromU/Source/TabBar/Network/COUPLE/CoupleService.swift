//
//  CoupleService.swift
//  FromU
//
//  Created by 신태원 on 2023/03/05.
//

import Moya
import SwiftKeychainWrapper

enum CoupleService{
    
    case refreshForMatching
    
    case inputPartnerCode(partnerCode: String)
    
    case setMailBoxName(mailboxName: String)
    
    case checkMail(mailboxName: String)
}

extension CoupleService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)/couples")!
    }
    
    var path: String {
        
        switch self {
            
        case .refreshForMatching:
            return "/isMatch"
            
        case .inputPartnerCode:
            return ""
            
        case .setMailBoxName:
            return "/mailbox"

        case .checkMail:
        
            return "/mailbox"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
            
        case .refreshForMatching:
            return .get
            
        case .inputPartnerCode:
            return .post
            
        case .setMailBoxName:
            return .patch
            
        case .checkMail:
            return .get
        }
        
    }
    
    var task: Moya.Task {
        switch self {
            
        case .refreshForMatching:
            return Task.requestPlain
            
        case .inputPartnerCode(let partnerCode):
            return .requestParameters(parameters: ["partnerCode": partnerCode], encoding: JSONEncoding.default)
            
        case .setMailBoxName(let mailboxName):
            return .requestParameters(parameters: ["mailboxName": mailboxName], encoding: JSONEncoding.default)
            
        case .checkMail(let mailboxName):
            return .requestParameters(parameters: ["mailboxName": mailboxName], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self{
            
        case .refreshForMatching:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .inputPartnerCode:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .setMailBoxName:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .checkMail:
            return nil
            
        }
    }
}
