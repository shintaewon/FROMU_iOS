//
//  AlertDisconnectCoupleViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/18.
//

import UIKit

import SwiftKeychainWrapper

class AlertDisconnectCoupleViewController: UIViewController {

    @IBOutlet weak var alertBGview: UIView!
    
    @IBOutlet weak var disconnectBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true){
            
            NotificationCenter.default.post(name: .popToRootView, object: nil)
            
        }
  
    }
    
    
    @IBAction func didTapDisconnectBtn(_ sender: Any) {
        
        disconnectCouple()
        
    }
    
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        if !alertBGview.frame.contains(tapLocation) {
            self.dismiss(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertBGview.layer.cornerRadius = 20
        
        disconnectBtn.layer.cornerRadius = 12
        disconnectBtn.layer.borderColor = UIColor.primary01.cgColor
        disconnectBtn.layer.borderWidth = 1
        
        continueBtn.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

}

extension AlertDisconnectCoupleViewController{
    
    func disconnectCouple(){
        CoupleAPI.providerCouple.request( .disConnect){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(FirstMetDayResponse.self)
                    print(response)
                    if response.isSuccess == true{
                        if response.code == 1000{
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            if let viewControllerA = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
                                let navigationController = UINavigationController(rootViewController: viewControllerA)

                                // Dismiss all presented view controllers and set the new root view controller
                                self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                                    UIApplication.shared.keyWindow?.rootViewController = navigationController
                                })
                            }
                            
                            //키체인에 UserPassword 삭제
                            KeychainWrapper.standard.removeObject(forKey: "X-ACCESS-TOKEN")

                            //키체인에 RefreshToken 삭제
                            KeychainWrapper.standard.removeObject(forKey: "RefreshToken")
                            
                            //오토로그인 false로 설정
                            UserDefaults.standard.setValue(false, forKey: "isAutoLoginValidation")
                        }
                    }
                } catch {
                    print(error)
                }
        
            case .failure(let error):
                print("DEBUG>> isMemberWithApple Error : \(error.localizedDescription)")
            }
        }
    }
}

