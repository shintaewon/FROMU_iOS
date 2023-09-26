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
    
    case plusSchedule(content: String, date: String)
    
    case deleteSchedule(scheduleId: String)
    
    case editSchedule(scheduleId: String, content: String, date: String)
}

extension ScheduleService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)/schedules")!
    }
    
    var path: String {
        
        switch self {
            
        case .getSpecificCalendarSchedules:
            return ""
            
        case .plusSchedule:
            return ""
            
        case .deleteSchedule(let scheduleId):
            return "\(scheduleId)"
            
        case .editSchedule(let scheduleId, let content, let date):
            return "\(scheduleId)"
        }
        
    }
    
    var method: Moya.Method {
        switch self {
            
        case .getSpecificCalendarSchedules:
            return .get

        case .plusSchedule:
            return .post
            
        case .deleteSchedule:
            return .delete
            
        case .editSchedule:
            return .patch
        }
        
    }
    
    var task: Moya.Task {
        switch self {
            
        case .getSpecificCalendarSchedules(let month, let date):
            return .requestParameters(parameters: ["month": month, "date": date], encoding: URLEncoding.queryString)
            
        case .plusSchedule(let content, let date):
            return .requestParameters(parameters: ["content": content, "date": date], encoding: JSONEncoding.default)
            
        case .deleteSchedule:
            return Task.requestPlain
            
        case .editSchedule(let scheduleId, let content, let date):
            return .requestParameters(parameters: ["content": content, "date": date], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self{
            
        case .getSpecificCalendarSchedules:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .plusSchedule:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .deleteSchedule:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .editSchedule:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        }
    }
}
