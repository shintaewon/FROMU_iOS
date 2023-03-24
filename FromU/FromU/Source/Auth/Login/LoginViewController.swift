//
//  ViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/21.
//

import UIKit

import AuthenticationServices
import Moya
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKTemplate
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var kakoBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    @IBAction func didTapKakaoBtn(_ sender: Any) {
    
        
//        let storyboard = UIStoryboard(name: "Diary", bundle: nil)
//
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {return}
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        
//        let storyboard = UIStoryboard(name: "MatchingComplete", bundle: nil)
//
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "MatchingCompleteViewController") as? MatchingCompleteViewController else {return}
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
//        let storyboard = UIStoryboard(name: "SetMailBoxName", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "SetMailBoxNameViewController") as? SetMailBoxNameViewController else {return}
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        loginWithKakao()
        
    }
    
    @IBAction func didTapAppleBtn(_ sender: Any) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //버튼 radius
        kakoBtn.layer.cornerRadius = 8
        appleBtn.layer.cornerRadius = 8
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - Apple 로그인 관련 통신 함수
extension LoginViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate{
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            let idToken = appleIDCredential.identityToken!
            let tokeStr = String(data: idToken, encoding: .utf8)
            
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
            print("token : \(String(describing: tokeStr))")
            
            //애플에서는 처음 한번밖에 이메일을 안주기때문에 그거 구분하기 위해서 저장해놓음
            if email?.isEmpty == false{
                KeychainWrapper.standard.set(email ?? "", forKey: "appleEmail")
            }
            
            KeychainWrapper.standard.set(tokeStr ?? " ", forKey: "appleAccessToken")
            
            sendAppleAccessToken()
         
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}

extension LoginViewController{
    
    func loginWithKakao(){
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken
                    
                    let xToken = oauthToken?.accessToken ?? ""
                    
                    KeychainWrapper.standard.set(xToken, forKey: "kakaoAccessToken")
                    
                    self.sendKakaoAccessToken()
                    
                    
                    UserApi.shared.me { [self] user, error in
                        if let error = error {
                            print(error)
                        } else {
                            
                            UserDefaults.standard.set(user?.kakaoAccount?.email, forKey: "email")
                        }
                    }
                }
            }
        }
        else{
            // 카톡 없으면 -> 계정으로 로그인
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")
                    
                    //do something
                    _ = oauthToken
                    
                    let xToken = oauthToken?.accessToken ?? ""
                    
                    KeychainWrapper.standard.set(xToken, forKey: "kakaoAccessToken")
                    
                    self.sendKakaoAccessToken()
                    
                    
                    UserApi.shared.me { [self] user, error in
                        if let error = error {
                            print(error)
                        } else {
                            
                            UserDefaults.standard.set(user?.kakaoAccount?.email, forKey: "email")
                        }
                    }
                }
            }
        }
    }
}

extension LoginViewController{
    
    func sendKakaoAccessToken(){
 
        UserDefaults.standard.set(true, forKey: "isFromKakao")
        print("카카오톡 토큰 보냄")
        UserAPI.providerUser.request( .kakaoLogin){
            result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(LoginResponse.self)
                    
                    print(response)
                    
                    //일단 JWT 토큰 잘 전달했을 때
                    if response.isSuccess == true {
                        
                        //아직 멤버가 아닐때 -> 회원가입 시켜야됨
                        if response.result?.member == false{
                            
                            let storyboard = UIStoryboard(name: "SettingInfo", bundle: nil)
                            
                            guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingNickNameViewController") as? SettingNickNameViewController else {return}
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{//멤버 일 때! -> 어디까지 정보를 입력했나 확인 필요
                            
                            KeychainWrapper.standard.set(response.result?.userInfo?.jwt ?? " ", forKey: "X-ACCESS-TOKEN")
                            
                            //매칭은 아직 안했을때! -> 매칭 코드 입력 부분으로 이동하자
                            if response.result?.userInfo?.match == false{
                                
                                let storyboard = UIStoryboard(name: "Invitation", bundle: nil)
                                guard let vc = storyboard.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController else {return}
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{//매칭까지 된 상태일 때! ->
                                
                                //우편함 이름 설정했는지 확인
                                
                                //아직 우편함 이름 설정안했다면! -> 매칭 완료됐다는 로티 뷰로..! (이때 api 호출 해줘야됨. 상대방 이름 알아야되니까)
                                if response.result?.userInfo?.setMailboxName == false{
                                    let storyboard = UIStoryboard(name: "MatchingComplete", bundle: nil)
                                    guard let vc = storyboard.instantiateViewController(withIdentifier: "MatchingCompleteViewController") as? MatchingCompleteViewController else {return}
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else{//우편함 이름까지 설정해준 상태! -> 메인 화면으로
                                    
                                  
                                    let storyboard = UIStoryboard(name: "Diary", bundle: nil)
                            
                                    guard let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {return}
                            
                                    self.navigationController?.pushViewController(vc, animated: true)
                                            
                                }
                                
                            }
                            
                        }
                    }
                        
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> sendKakaoAccessToken Error : \(error.localizedDescription)")
            }
        }
    }
    
    func sendAppleAccessToken(){
        UserDefaults.standard.set(false, forKey: "isFromKakao")
        print("애플토큰 보냄")
        UserAPI.providerUser.request( .appleLogin){
            result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(LoginResponse.self)
                    
                    print(response)
                    
                    //일단 JWT 토큰 잘 전달했을 때
                    if response.isSuccess == true {
                        
                        //아직 멤버가 아닐때 -> 회원가입 시켜야됨
                        if response.result?.member == false{
                            
                            let storyboard = UIStoryboard(name: "SettingInfo", bundle: nil)
                            
                            guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingNickNameViewController") as? SettingNickNameViewController else {return}
                            
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                        else{//멤버 일 때! -> 어디까지 정보를 입력했나 확인 필요
                            
                            KeychainWrapper.standard.set(response.result?.userInfo?.jwt ?? " ", forKey: "X-ACCESS-TOKEN")
                            
                            
                            //매칭은 아직 안했을때! -> 매칭 코드 입력 부분으로 이동하자
                            if response.result?.userInfo?.match == false{
                                
                                let storyboard = UIStoryboard(name: "Invitation", bundle: nil)
                                guard let vc = storyboard.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController else {return}
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{//매칭까지 된 상태일 때! ->
                                
                                //우편함 이름 설정했는지 확인
                                
                                //아직 우편함 이름 설정안했다면! -> 매칭 완료됐다는 로티 뷰로..! (이때 api 호출 해줘야됨. 상대방 이름 알아야되니까)
                                if response.result?.userInfo?.setMailboxName == false{
                                    let storyboard = UIStoryboard(name: "MatchingComplete", bundle: nil)
                                    guard let vc = storyboard.instantiateViewController(withIdentifier: "MatchingCompleteViewController") as? MatchingCompleteViewController else {return}
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else{//우편함 이름까지 설정해준 상태! -> 메인 화면으로
                                    
                                    
                                    let storyboard = UIStoryboard(name: "Diary", bundle: nil)
                            
                                    guard let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {return}
                            
                                    self.navigationController?.pushViewController(vc, animated: true)
                                            
                                }
                                
                            }
                            
                        }
                    }
                        
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> sendKakaoAccessToken Error : \(error.localizedDescription)")
            }
        }
    }
    
}
