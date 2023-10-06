//
//  SubscriptionViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/04.
//

import UIKit

import SwiftKeychainWrapper

class SubscriptionViewController: UIViewController {

    
    @IBOutlet weak var checkBtn1: UIButton!
    @IBOutlet weak var checkBtn2: UIButton!
    
    
    @IBOutlet weak var subsBtn1: UIButton!
    @IBOutlet weak var subsBtn2: UIButton!
    
    
    @IBOutlet weak var startBtn: UIButton!
    
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    var agreeSubs1 = false
    var agreeSubs2 = false
    
    @IBAction func didTapSubsBtn1(_ sender: Any) {
        let appURL = URL(string: "www.notion.so/760bcb4d71c9423d9b751a49882984a4?pvs=4")!
        let webURL = URL(string: "https://www.notion.so/760bcb4d71c9423d9b751a49882984a4?pvs=4")!

        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func didTapSubsBtn2(_ sender: Any) {
        let appURL = URL(string: "www.notion.so/bbcd9f741538474893adba60c3c8ee75?pvs=4")!
        let webURL = URL(string: "https://www.notion.so/bbcd9f741538474893adba60c3c8ee75?pvs=4")!

        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    //시작하기 버튼 활성화시켜주는 함수
    func changeStartBtnActive() {
        startBtn.backgroundColor = UIColor.primary01
        startBtn.isEnabled = true
    }
    
    //시작하기 버튼 비활성화시켜주는 함수
    func changeStartBtnNonActive() {
        startBtn.backgroundColor = UIColor.disabled
        startBtn.isEnabled = false
    }
    
    //첫번째 체크 버튼 눌렀을때 액션 함수
    @IBAction func didTapsubscheckBtn1(_ sender: Any) {
        
        if agreeSubs1 == false {
            agreeSubs1 = true
            checkBtn1.setImage(UIImage(named: "icn_checkBox_true"), for: .normal)
            
            if agreeSubs2 == true {
                changeStartBtnActive()
            }
        }
        else{
            changeStartBtnNonActive()
            agreeSubs1 = false
            checkBtn1.setImage(UIImage(named: "icn_checkBox_false"), for: .normal)
        }
    }
    
    //두번째 체크 버튼 눌렀을때 액션 함수
    @IBAction func didTapsubscheckBtn2(_ sender: Any) {
        
        if agreeSubs2 == false {
            agreeSubs2 = true
            checkBtn2.setImage(UIImage(named: "icn_checkBox_true"), for: .normal)
            
            if agreeSubs1 == true {
                changeStartBtnActive()
            }
        }
        else{
            changeStartBtnNonActive()
            agreeSubs2 = false
            checkBtn2.setImage(UIImage(named: "icn_checkBox_false"), for: .normal)
        }
    }
    
    @IBAction func didTapStartBtn(_ sender: Any) {
        signUpFromU()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        nickNameLabel.text = ""
        helloLabel.text = ""
        
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
        
        let attributedString1 = NSMutableAttributedString(string: subsBtn1.currentTitle!, attributes: underlineAttribute)
        
        subsBtn1.setAttributedTitle(attributedString1, for: .normal)
        
        let attributedString2 = NSMutableAttributedString(string: subsBtn2.currentTitle!, attributes: underlineAttribute)
        
        subsBtn2.setAttributedTitle(attributedString2, for: .normal)
        
        startBtn.isEnabled = false
        startBtn.layer.cornerRadius = 8
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        inputAnimation()
    }
    
    func inputAnimation(){

        let nickName = UserDefaults.standard.string(forKey: "nickName") ?? ""

        let str = nickName + ","

        let greeting = "안녕"

        for i in str {
            nickNameLabel.text! += "\(i)"

            RunLoop.current.run(until: Date() + 0.3)
        }

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            for i in greeting {
                self.helloLabel.text! += "\(i)"

                RunLoop.current.run(until: Date() + 0.3)
            }
        }
    }
}


extension SubscriptionViewController{
    
    func signUpFromU(){
        var email = ""
        
        let birthday = UserDefaults.standard.string(forKey: "birthDay") ?? ""
        
        if UserDefaults.standard.bool(forKey: "isFromKakao") == true{
            print("카카오로 로그인 진행중")
 
            email = UserDefaults.standard.string(forKey: "email") ?? ""
        }
        else{
            print("애플로 로그인 진행중")
            email = KeychainWrapper.standard.string(forKey: "appleEmail") ?? ""
        }
        
        
        let gender = UserDefaults.standard.string(forKey: "gender") ?? ""
        
        let nickname = UserDefaults.standard.string(forKey: "nickName") ?? ""
        
        print("birthday:", birthday)
        print("email:", email)
        print("gender:", gender)
        print("nickname:", nickname)
        
        UserAPI.providerUser.request( .signUpFromU(birthday: birthday, email: email, gender: gender, nickname: nickname)){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(SignupResponse.self)
                    print(response)
                    if response.isSuccess == true{
                        if response.code == 1000 {
                            
                            UserDefaults.standard.set(response.result.userCode, forKey: "userCode")
                            KeychainWrapper.standard.set(response.result.jwt, forKey: "X-ACCESS-TOKEN")
                            self.registerFCMToken()
                        }
                    }
                    
                } catch {
                    print(error)
                }

            case .failure(let error):
                print("DEBUG>> signUpFromU Error : \(error.localizedDescription)")
            }
        }
    }
    
    func registerFCMToken(){
        UserAPI.providerUser.request( .registerFCMToken(deviceToken: KeychainWrapper.standard.string(forKey: "FCMToken") ?? "")){ [weak self] result in
            guard let self = self else { return }
                
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(RegisterTokenResponse.self)
                    print(response)
                    if response.code == 1000{
                        let storyboard = UIStoryboard(name: "Invitation", bundle: nil)
                
                        guard let vc = storyboard.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController else {return}
                
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } catch {
                    print(error)
                }

            case .failure(let error):
                print("DEBUG>> getUserInfoWithUserID Error : \(error.localizedDescription)")
            }
        }
    }
}
