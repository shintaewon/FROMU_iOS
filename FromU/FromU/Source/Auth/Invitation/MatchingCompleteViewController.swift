//
//  MatchingCompleteViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/28.
//

import UIKit

class MatchingCompleteViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    
    @IBOutlet weak var matchingLabel: UILabel!
    
    func goToSetMailBoxNamePage(){
        let storyboard = UIStoryboard(name: "SetMailBoxName", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SetMailBoxNameViewController") as? SetMailBoxNameViewController else{ return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        matchingLabel.text = "\(UserDefaults.standard.string(forKey: "partnerNickName") ?? "")와(과) 매칭이 되었어!"
        
        backgroundView.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.goToSetMailBoxNamePage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

}

