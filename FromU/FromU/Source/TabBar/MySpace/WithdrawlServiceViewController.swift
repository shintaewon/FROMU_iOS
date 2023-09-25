//
//  WithdrawlServiceViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/18.
//

import UIKit

class WithdrawlServiceViewController: UIViewController {

    @IBOutlet weak var withdrawlBtn: UIButton!
    
    @IBOutlet weak var continueBtn: UIButton!
    
    
    @IBAction func didTapWithdrawlBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AlertWithdrawlViewController") as? AlertWithdrawlViewController else {return}
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func didTapContinueBtn(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func configuration(){
        withdrawlBtn.layer.cornerRadius = 8
        withdrawlBtn.layer.borderColor = UIColor.primary01.cgColor
        withdrawlBtn.layer.borderWidth = 1
        
        continueBtn.layer.cornerRadius = 8
    }
    
    @objc func goToRoot(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "탈퇴하기"
        
        configuration()
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToRoot), name: .popToRootView, object: nil)
        
        // Customize the navigation bar title font
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir , size: 14),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        
    }


}
