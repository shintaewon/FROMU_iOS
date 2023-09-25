//
//  OnboardingWrittingLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/04/17.
//

import UIKit

protocol OnboardingWrittingLetterViewControllerDelegate: AnyObject {
    func goToSelectStampView()
}

class OnboardingWrittingLetterViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    weak var delegate: OnboardingWrittingLetterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        backgroundView.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.navigationController?.popViewController(animated: false)
            self.delegate?.goToSelectStampView()
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

}
