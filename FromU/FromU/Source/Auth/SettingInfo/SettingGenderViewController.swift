//
//  SettingGenderViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/25.
//

import UIKit

class SettingGenderViewController: UIViewController {

    @IBOutlet weak var femaleView: UIView!
    @IBOutlet weak var maleView: UIView!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    //다음 버튼 활성화시켜주는 함수
    func changeNextBtnActive() {
        nextBtn.backgroundColor = UIColor.primary01
        nextBtn.isEnabled = true
    }

    
    var isFemale = false
    var isMale = false
    
    @objc func femaleViewTapped() {
        changeNextBtnActive()
        if isFemale == false {
            isFemale = true
            isMale = false
            femaleView.backgroundColor = .primaryLight
            maleView.backgroundColor = .white
        }
        
    }
    
    @objc func maleViewTapped() {
        changeNextBtnActive()
        if isMale == false {
            isMale = true
            isFemale = false
            femaleView.backgroundColor = .white
            maleView.backgroundColor = .primaryLight
        }
    
    }
    
    @IBAction func didTapNextBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Invitation", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.tintColor = .icon
        
        nextBtn.isEnabled = false
        nextBtn.layer.cornerRadius = 8
        
        femaleView.layer.cornerRadius = 12
        femaleView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
        femaleView.layer.shadowOffset = CGSize(width: 0, height: 4)
        femaleView.layer.shadowRadius = 12
        femaleView.layer.shadowOpacity = 1
        
        
        maleView.layer.cornerRadius = 12
        maleView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04).cgColor
        maleView.layer.shadowOffset = CGSize(width: 0, height: 4)
        maleView.layer.shadowRadius = 12
        maleView.layer.shadowOpacity = 1
        
        let femaleTapGesture = UITapGestureRecognizer(target: self, action: #selector(femaleViewTapped))
        femaleView.addGestureRecognizer(femaleTapGesture)
        
        let maleTapGesture = UITapGestureRecognizer(target: self, action: #selector(maleViewTapped))
        maleView.addGestureRecognizer(maleTapGesture)
    }
    

}
