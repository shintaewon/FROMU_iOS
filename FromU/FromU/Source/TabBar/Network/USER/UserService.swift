//
//  UserService.swift
//  FromU
//
//  Created by 신태원 on 2023/03/04.
//

import Moya
import SwiftKeychainWrapper

enum UserService{
    
    case kakaoLogin
    
    case signUpFromU(birthday: String,
                email: String,
                gender: String,
                nickname: String)
    
    case logout
    
    case withdrawal
    
    case appleLogin
    
    case refreshToken
    
}

extension UserService: TargetType{
    
    var baseURL: URL {
        return URL(string: "\(Constant.BASE_URL)/users")!
    }
    
    var path: String {
        
        switch self {
        case .kakaoLogin:
            return "/kakao"
            
        case .signUpFromU:
            return ""

        case .logout:
            return "/logout"
            
        case .withdrawal:
            return "/d"
            
        case .appleLogin:
            return "/apple"
            
        case .refreshToken:
            return "/refreshToken"

        }
        
    }
    
    var method: Moya.Method {
        switch self {
        case .kakaoLogin:
            return .post
            
        case .signUpFromU:
            return .post
            
        case .logout:
            return .patch
            
        case .withdrawal:
            return .patch
            
        case .appleLogin:
            return .post
            
        case .refreshToken:
            return .post
        }
        
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin:
            return Task.requestPlain
            
        case .signUpFromU(let birthday, let email, let gender, let nickname):
            return .requestParameters(parameters: ["birthday": birthday, "email": email, "gender": gender, "nickname": nickname], encoding: JSONEncoding.default)
        case .logout:
            return Task.requestPlain
            
        case .withdrawal:
            return Task.requestPlain
            
        case .appleLogin:
            return Task.requestPlain
            
        case .refreshToken:
            return Task.requestPlain

        }
        
    }
    
    var headers: [String : String]? {
        switch self{
        case .kakaoLogin:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "kakaoAccessToken") ?? "" ]
            
        case .signUpFromU:
            return nil

        case .logout:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
            
        case .withdrawal:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]
        
        case .appleLogin:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "appleAccessToken") ?? "" ]
            
        case .refreshToken:
            return [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "RefreshToken") ?? "" ]
        }
    }
}


//UserAPI.provider.request( .APIName){ result in
//    switch result {
//    case .success(let data):
//        do{
//            let response = try data.map(DATARESPONSE.self)
//              ...
//        } catch {
//            print(error)
//        }
//
//    case .failure(let error):
//        print("DEBUG>> isMemberWithApple Error : \(error.localizedDescription)")
//    }
//}
