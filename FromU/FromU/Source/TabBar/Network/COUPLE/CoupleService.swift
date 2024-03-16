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
    
    case setFirstMetDay(firstMetDay: String)
    
    case disConnect
    
    case buyStamp(stampNum: String)
    
    case getUserInfo(coupleId: String)
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
            
        case .setFirstMetDay:
            return "/firstMetDay"
            
        case .disConnect:
            return "/d"
            
        case .buyStamp(let stampNum):
            return "/stamp/\(stampNum)"
            
        case .getUserInfo(let coupleId):
            return "/\(coupleId)"
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
            
        case .setFirstMetDay:
            return .patch
            
        case .disConnect:
            return .patch
            
        case .buyStamp:
            return .get
            
        case .getUserInfo:
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
            
        case .setFirstMetDay(let firstMetDay):
            return .requestParameters(parameters: ["firstMetDay": firstMetDay], encoding: JSONEncoding.default)
            
        case .disConnect:
            return Task.requestPlain
            
        case .buyStamp:
            return Task.requestPlain
            
        case .getUserInfo:
            return Task.requestPlain
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
            
        case .setFirstMetDay:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .disConnect:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .buyStamp:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .getUserInfo:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        }
    }
}
