//
//  ViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/21.
//

import UIKit

import Moya
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKTemplate
import SwiftKeychainWrapper

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var kakoBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    var isAutoLogin = false
    
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
        
//        let storyboard = UIStoryboard(name: "SettingInfo", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingNickNameViewController") as? SettingNickNameViewController else {return}
//
//        self.navigationController?.pushViewController(vc, animated: true)
        
        loginWithKakao()
        
    }
    
    @IBAction func didTapAppleBtn(_ sender: Any) {
        let myNavigationController = storyboard?.instantiateViewController(withIdentifier: "MyNavigationController") as! UINavigationController
        let rootViewController = myNavigationController.viewControllers.first
        navigationController?.pushViewController(rootViewController!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //배경색 지정
        backgroundView.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
        //로그인 확인
        if isLoggedIn() {
            showHomeVC()
        }
        
        //버튼 radius
        kakoBtn.layer.cornerRadius = 8
        appleBtn.layer.cornerRadius = 8
    }

    override func viewWillDisappear(_ animated: Bool) {

        if isAutoLogin == true{
            self.navigationController?.isNavigationBarHidden = true
        }
        else{
            self.navigationController?.isNavigationBarHidden = false
        }
        
    }
    
    func isLoggedIn() -> Bool {
        // Check if the user is already logged in
        // Return true if they are, false otherwise
        return false
    }
    
    func showHomeVC() {
        
        // Load the storyboards for each tab
        let storyboard = UIStoryboard(name: "Diary", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DiaryViewController") as? DiaryViewController else { return }
        
        self.present(vc, animated: true)
        
    }
    
    func showLogin() {
        // Present the login/signup page
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
    }
}

extension LoginViewController{
    
    func sendKakaoAccessToken(){
 
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
                                    
                                    self.isAutoLogin = true
                                    
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
