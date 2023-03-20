//
//  AlertWithdrawlViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/18.
//

import UIKit

import SwiftKeychainWrapper

class AlertWithdrawlViewController: UIViewController {

    @IBOutlet weak var alertBGview: UIView!
    
    @IBOutlet weak var withdrawlBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true){
            
            NotificationCenter.default.post(name: .popToRootView, object: nil)
            
        }
  
    }
    
    
    @IBAction func didTapWithdrawlBtn(_ sender: Any) {
        
        withdrawlService()

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
        
        withdrawlBtn.layer.cornerRadius = 12
        withdrawlBtn.layer.borderColor = UIColor.primary01.cgColor
        withdrawlBtn.layer.borderWidth = 1
        
        continueBtn.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

}

extension AlertWithdrawlViewController{
    
    func withdrawlService(){
        UserAPI.providerUser.request( .withdrawal){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(WithdrawlResponse.self)
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
