//
//  ScheduleService.swift
//  FromU
//
//  Created by 신태원 on 2023/09/03.
//

import Moya
import SwiftKeychainWrapper

enum ScheduleService{
    
    case getSpecificCalendarSchedules(month: String, date: String)
}

extension ScheduleService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)/schedules")!
    }
    
    var path: String {
        
        switch self {
            
        case .getSpecificCalendarSchedules:
            return ""
        }
        
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getSpecificCalendarSchedules:
            return .get

        }
        
    }
    
    var task: Moya.Task {
        switch self {
            
        case .getSpecificCalendarSchedules(let month, let date):
            return .requestParameters(parameters: ["month": month, "date": date], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self{
            
        case .getSpecificCalendarSchedules:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        }
    }
}
