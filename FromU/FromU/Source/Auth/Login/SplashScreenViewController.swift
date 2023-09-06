//
//  SplashScreenViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/19.
//

import UIKit

import Lottie
import SwiftKeychainWrapper

class SplashScreenViewController: UIViewController {
    
    
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBOutlet weak var splashLottieView: LottieAnimationView!
    
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.isHidden = true
        
        //배경색 지정
        bgView.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
    }
    
    func isLoggedIn() -> Bool {
        
        if UserDefaults.standard.bool(forKey: "isAutoLoginValidation") == true {
            return true
        } else{
            return false
        }
        
    }
    
    func showLogin() {
        // Present the login/signup page
    }
    
    func showHomeVC() {
        
        // Load the storyboards for each tab
        let storyboard = UIStoryboard(name: "Diary", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func showOnBoardingVC(){
        let storyboard = UIStoryboard(name: "OnboardingPage", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController else { return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("스플래시 스크린:", KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN"))
        
        print("스플래시 스크린:", KeychainWrapper.standard.string(forKey: "RefreshToken"))
        
        inputAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            
            //자동로그인되어있으면 바로 홈으로
            if self?.isLoggedIn() == true {
                
                //                let storyboard = UIStoryboard(name: "SelectStamp", bundle: nil)
                //                guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectStampViewController") as? SelectStampViewController else { return }
                //                self?.navigationController?.pushViewController(vc, animated: true)
                
                self?.showHomeVC()
            }
            //안되어있으면 온보딩 혹은 로그인
            else{
                if UserDefaults.standard.bool(forKey: "onBoardingCheck") == false {
                    self?.showOnBoardingVC()
                }
                
            }
            
        }
        
    }
    
    func inputAnimation() {
        let explainString = "당신으로부터,"
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { timer in
            if index < explainString.count {
                let char = explainString[explainString.index(explainString.startIndex, offsetBy: index)]
                self.explainLabel.text! += "\(char)"
                index += 1
            } else {
                timer.invalidate()
            }
        }
        
        let animation = LottieAnimationView(name: "splash")
        splashLottieView.addSubview(animation)
        animation.frame = splashLottieView.bounds
        animation.contentMode = .scaleToFill
        animation.loopMode = .loop
        animation.play()
    }
}
