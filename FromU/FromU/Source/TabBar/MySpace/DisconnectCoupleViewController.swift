//
//  DisconnectCoupleViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/18.
//

import UIKit

import SwiftKeychainWrapper

class DisconnectCoupleViewController: UIViewController {

    @IBOutlet weak var disconnectBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    
    @IBAction func didTapDisconnectBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlertDisconnectCoupleViewController") as? AlertDisconnectCoupleViewController else {return}
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func configuration(){
        disconnectBtn.layer.cornerRadius = 8
        disconnectBtn.layer.borderColor = UIColor.primary01.cgColor
        disconnectBtn.layer.borderWidth = 1
        
        continueBtn.layer.cornerRadius = 8
    }
    
    @objc func goToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "커플연결 끊기"
        
        configuration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToRoot), name: .popToRootView, object: nil)
        
        // Customize the navigation bar title font
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir , size: 14),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        
    }

}
