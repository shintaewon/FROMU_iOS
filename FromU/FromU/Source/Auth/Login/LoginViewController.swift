//
//  ViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/21.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser
import KakaoSDKTemplate

class LoginViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var kakoBtn: UIButton!
    @IBOutlet weak var appleBtn: UIButton!
    
    
    @IBAction func didTapKakaoBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "SettingInfo", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingNickNameViewController") as? SettingNickNameViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        //loginWithKakao()
        
    }
    
    @IBAction func didTapAppleBtn(_ sender: Any) {
        let myNavigationController = storyboard?.instantiateViewController(withIdentifier: "MyNavigationController") as! UINavigationController
        let rootViewController = myNavigationController.viewControllers.first
        navigationController?.pushViewController(rootViewController!, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let myNavigationController = storyboard?.instantiateViewController(withIdentifier: "MyNavigationController") as! UINavigationController
//        
//        let rootViewController = myNavigationController.viewControllers.first
//        navigationController?.pushViewController(rootViewController!, animated: true)
        
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
                    
                    let xToken = oauthToken?.accessToken ?? " "
                    
                    print(xToken)
                }
            }
        }
    }
    
}
