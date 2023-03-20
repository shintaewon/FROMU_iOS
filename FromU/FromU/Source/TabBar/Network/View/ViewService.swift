//
//  ViewService.swift
//  FromU
//
//  Created by 신태원 on 2023/03/06.
//

import Moya
import SwiftKeychainWrapper

enum ViewService{
    
    case getMainViewInfo
    
    case getFromCount
    
    case getMailBoxViewInfo
}

extension ViewService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)")!
    }
    
    var path: String {
        
        switch self {
        case .getMainViewInfo:
            return "/view/main"
            
        case .getFromCount:
            return "/view/fromCount"
            
        case .getMailBoxViewInfo:
            return "/view/mailbox"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getMainViewInfo:
            return .get
            
        case .getFromCount:
            return .get
            
        case .getMailBoxViewInfo:
            return .get
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .getMainViewInfo:
            return Task.requestPlain
            
        case .getFromCount:
            return Task.requestPlain
        
        case .getMailBoxViewInfo:
            return Task.requestPlain
        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .getMainViewInfo:
        
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .getFromCount:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .getMailBoxViewInfo:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        }
    }
}
