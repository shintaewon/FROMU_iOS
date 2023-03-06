//
//  SubscriptionViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/04.
//

import UIKit

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
//        let storyboard = UIStoryboard(name: "Invitation", bundle: nil)
//
//        guard let vc = storyboard.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController else {return}
//
//        self.navigationController?.pushViewController(vc, animated: true)
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
        
        let birthday = UserDefaults.standard.string(forKey: "birthDay") ?? ""
        
        let email = UserDefaults.standard.string(forKey: "email") ?? ""
        
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
            
                } catch {
                    print(error)
                }

            case .failure(let error):
                print("DEBUG>> signUpFromU Error : \(error.localizedDescription)")
            }
        }
    }
}
