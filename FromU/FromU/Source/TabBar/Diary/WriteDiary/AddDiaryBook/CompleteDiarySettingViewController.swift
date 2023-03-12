//
//  CompleteDiarySettingViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/03.
//

import UIKit

class CompleteDiarySettingViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    func goToMainPage(){
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        backgroundView.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.goToMainPage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
