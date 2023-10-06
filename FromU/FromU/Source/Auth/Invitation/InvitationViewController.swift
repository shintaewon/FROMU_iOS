//
//  InvitationViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/25.
//

import UIKit

class InvitationViewController: UIViewController {

  
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var invitationBtn: UIButton!//"초대장 보내기" 버튼
    @IBOutlet weak var inputCodeBtn: UIButton!//"연인의 코드 입력하기" 버튼
    
    @IBOutlet weak var invitationCodeLabel: UILabel!
    
    @IBAction func didTapInvitationBtn(_ sender: Any) {
        var objectsToShare = [String]()
        if invitationCodeLabel.text != nil {
            let textToShare : String = """
                당신의 연인 ‘\(UserDefaults.standard.string(forKey: "nickName") ?? "")'로부터
                초대장이 도착했어.
                커플코드를 입력하고 우리와 함께 할래?
                
                커플코드:
                \(invitationCodeLabel.text ?? "")
                """
            objectsToShare.append(textToShare)
            print("[INFO] textField's Text : ", textToShare)
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapInputCodeBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "InputCode", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "InputCodeViewController") as? InputCodeViewController else{ return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func didTapRefreshItem() {
        
        refreshInfo()
        
    }
    
    
    @IBAction func didTapCloseBtn(_ sender: Any) {
        descriptionView.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        invitationCodeLabel.text = "\(UserDefaults.standard.string(forKey: "userCode") ?? "")"
        
        self.navigationController?.isNavigationBarHidden = true
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.tintColor = .icon
       
        // Create a UIImage for your UIBarButtonItem
        let refreshImage = UIImage(named: "refresh_white")

        // Create a UIBarButtonItem with your UIImage
        let barButtonItem = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(didTapRefreshItem))

        // Set the UIBarButtonItem as the rightBarButtonItem of the UINavigationItem of your UIViewController
        navigationItem.rightBarButtonItem = barButtonItem
    
        invitationBtn.layer.cornerRadius = 8
        inputCodeBtn.layer.cornerRadius = 8
        
    }
}

extension InvitationViewController{
    
    func refreshInfo(){
        CoupleAPI.providerCouple.request( .refreshForMatching){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(RefreshResponse.self)
                    
                    print(response)
                    //일단 엔드포인트 호출 성공
                    if response.isSuccess == true{
                        if response.result?.match == false {
                            self.showToast(message: "연인과의 연결이 완료되지 않았어!", font: UIFont.Pretendard(.regular, size: 14))
                        }
                        else{
                            UserDefaults.standard.set(response.result?.coupleRes?.partnerNickname, forKey: "partnerNickName")
                            
                            UserDefaults.standard.set(response.result?.coupleRes?.nickname, forKey: "nickName")
                            
                            //새로고침했는데 상대방이 연결도 했고 메일박스 이름 설정도 해놓음..! => 바로 홈화면으로 고고
                            if response.result?.coupleRes?.setMailboxName == true {
                                
                                UserDefaults.standard.set(response.result?.coupleRes?.setMailboxName, forKey: "mailBoxName")
                                
                                let storyboard = UIStoryboard(name: "Diary", bundle: nil)
                        
                                guard let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {return}
                        
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else{//새로고침했는데 상대방이 연결은 했는데 메일박스 이름 설정은 안해놓음 -> 이름 설정하러 고고
                                
                                let storyboard  = UIStoryboard(name: "SetMailBoxName", bundle: nil)
                                
                                guard let vc = storyboard.instantiateViewController(withIdentifier: "SetMailBoxNameViewController") as? SetMailBoxNameViewController else {return}
                        
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
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
}


extension InvitationViewController{
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: explainLabel.layer.frame.origin.x, y: explainLabel.layer.frame.origin.y - 94, width: self.view.frame.width - explainLabel.layer.frame.origin.x * 2 , height: 52))
        toastLabel.backgroundColor = UIColor(red: 0.167, green: 0.167, blue: 0.167, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut,animations: {
            toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
}
