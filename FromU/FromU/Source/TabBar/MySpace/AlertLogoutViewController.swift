//
//  AlertLogoutViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/18.
//

import UIKit

import SwiftKeychainWrapper

class AlertLogoutViewController: UIViewController {

    @IBOutlet weak var alertBGview: UIView!
    
    @IBOutlet weak var goBackBtn: UIButton!
    
    @IBOutlet weak var logoutBtn: UIButton!
    
    @IBAction func didTapgoBackBtn(_ sender: Any) {
        self.dismiss(animated: false)
  
    }
    
    
    @IBAction func didTapLogoutBtn(_ sender: Any) {
        logout()
        
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
        
        goBackBtn.layer.cornerRadius = 12
        goBackBtn.layer.borderColor = UIColor.primary01.cgColor
        goBackBtn.layer.borderWidth = 1
        
        logoutBtn.layer.cornerRadius = 12
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

}

extension AlertLogoutViewController{
    
    func logout(){
        UserAPI.providerUser.request( .logout){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(LogoutResponse.self)
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
                print("DEBUG>> logout Error : \(error.localizedDescription)")
            }
        }
    }
}
