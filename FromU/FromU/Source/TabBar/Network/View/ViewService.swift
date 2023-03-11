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
    
}

extension ViewService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)")!
    }
    
    var path: String {
        
        switch self {
        case .getMainViewInfo:
            return "/view/main"

        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .getMainViewInfo:
            return .get
        
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .getMainViewInfo:
            return Task.requestPlain
        
        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .getMainViewInfo:
        
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            //return [ "X-ACCESS-TOKEN" : "eyJ0eXBlIjoiand0IiwiYWxnIjoiSFMyNTYifQ.eyJ1c2VySWQiOjE2LCJpYXQiOjE2NzgxMTQ0MjQsImV4cCI6MTY3OTU4NTY1M30.gdYv1fF-wfDMxxr2H3eF_4WkBuNq2rz83k7y1mj-tA8" ]
        }
    }
}
