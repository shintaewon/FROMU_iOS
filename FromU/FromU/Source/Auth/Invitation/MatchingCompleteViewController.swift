//
//  MatchingCompleteViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/28.
//

import UIKit

import Lottie

class MatchingCompleteViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    
    @IBOutlet weak var firstNickNameLabel: UILabel!
    
    @IBOutlet weak var secondNickNameLabel: UILabel!
    
    @IBOutlet weak var splashLottieView: LottieAnimationView!
    
    func goToSetMailBoxNamePage(){
        let storyboard = UIStoryboard(name: "SetMailBoxName", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SetMailBoxNameViewController") as? SetMailBoxNameViewController else{ return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firstNickNameLabel.text = "\(UserDefaults.standard.string(forKey: "nickName") ?? ""),"
        
        secondNickNameLabel.text = "그리고 \(UserDefaults.standard.string(forKey: "partnerNickName") ?? "")."
        
        backgroundView.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
        let animation = LottieAnimationView(name: "matching")
        splashLottieView.addSubview(animation)
        animation.frame = splashLottieView.bounds
        animation.contentMode = .scaleToFill
        animation.loopMode = .loop
        animation.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.goToSetMailBoxNamePage()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

}

