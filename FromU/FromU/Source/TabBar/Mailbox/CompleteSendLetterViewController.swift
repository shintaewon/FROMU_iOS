//
//  CompleteSendLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/05/02.
//

import UIKit

import Lottie

class CompleteSendLetterViewController: UIViewController {


    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var lottieView: LottieAnimationView!
    
    @IBOutlet weak var explainLabel: UILabel!
    
    var mailboxName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bgView.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
        explainLabel.text = "\(mailboxName)으로 편지를 보냈어!"

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        // Disable interactive gesture recognizer
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
                
        
        // 애니메이션을 미리 로드합니다.
        let animation = LottieAnimationView(name: "sendingletter")
        lottieView.addSubview(animation)
        animation.frame = lottieView.bounds
        animation.contentMode = .scaleToFill
        animation.loopMode = .loop
        animation.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

}
