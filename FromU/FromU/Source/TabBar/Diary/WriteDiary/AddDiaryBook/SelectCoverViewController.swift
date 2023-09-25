//
//  SelectCoverViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/03.
//

import UIKit

class SelectCoverViewController: UIViewController {

    @IBOutlet weak var colorView1: UIImageView!
    @IBOutlet weak var colorView2: UIImageView!
    @IBOutlet weak var colorView3: UIImageView!
    @IBOutlet weak var colorView4: UIImageView!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var isClickView1 = false
    var isClickView2 = false
    var isClickView3 = false
    var isClickView4 = false
    
    var selectDiaryNum = 0
    
    @objc func colorView1Tapped(){
        isClickView1 = true
        isClickView2 = false
        isClickView3 = false
        isClickView4 = false
        selectDiaryNum = 1
        
        colorView1.layer.borderColor = UIColor.primary02.cgColor
        colorView2.layer.borderColor = UIColor.clear.cgColor
        colorView3.layer.borderColor = UIColor.clear.cgColor
        colorView4.layer.borderColor = UIColor.clear.cgColor
        
        changeNextBtnActive()
        
    }
    
    @objc func colorView2Tapped(){
        isClickView1 = false
        isClickView2 = true
        isClickView3 = false
        isClickView4 = false
        selectDiaryNum = 2
        
        colorView1.layer.borderColor = UIColor.clear.cgColor
        colorView2.layer.borderColor = UIColor.primary02.cgColor
        colorView3.layer.borderColor = UIColor.clear.cgColor
        colorView4.layer.borderColor = UIColor.clear.cgColor
        
        changeNextBtnActive()
    }
    
    @objc func colorView3Tapped(){
        isClickView1 = false
        isClickView2 = false
        isClickView3 = true
        isClickView4 = false
        selectDiaryNum = 3
        
        colorView1.layer.borderColor = UIColor.clear.cgColor
        colorView2.layer.borderColor = UIColor.clear.cgColor
        colorView3.layer.borderColor = UIColor.primary02.cgColor
        colorView4.layer.borderColor = UIColor.clear.cgColor
        
        changeNextBtnActive()
    }
    
    @objc func colorView4Tapped(){
        isClickView1 = false
        isClickView2 = false
        isClickView3 = false
        isClickView4 = true
        selectDiaryNum = 4
        
        colorView1.layer.borderColor = UIColor.clear.cgColor
        colorView2.layer.borderColor = UIColor.clear.cgColor
        colorView3.layer.borderColor = UIColor.clear.cgColor
        colorView4.layer.borderColor = UIColor.primary02.cgColor
        
        changeNextBtnActive()
    }
    
    func changeNextBtnActive() {
        nextBtn.backgroundColor = UIColor.primary01
        nextBtn.isEnabled = true
    }

    //다음 버튼 비활성화시켜주는 함수
    func changeNextBtnNonActive() {
        nextBtn.backgroundColor = UIColor.disabled
        nextBtn.isEnabled = false
    }
    
    
    @IBAction func didTapNextBtn(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingDiaryNameViewController") as? SettingDiaryNameViewController else {return}
        self.navigationController?.pushViewController(vc, animated: true)
        vc.selectedDiaryNum = selectDiaryNum
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .icon
        
        colorView1.layer.cornerRadius = 8
        colorView2.layer.cornerRadius = 8
        colorView3.layer.cornerRadius = 8
        colorView4.layer.cornerRadius = 8
        
        colorView1.layer.borderWidth = 3
        colorView2.layer.borderWidth = 3
        colorView3.layer.borderWidth = 3
        colorView4.layer.borderWidth = 3
        
        colorView1.layer.borderColor = UIColor.clear.cgColor
        colorView2.layer.borderColor = UIColor.clear.cgColor
        colorView3.layer.borderColor = UIColor.clear.cgColor
        colorView4.layer.borderColor = UIColor.clear.cgColor
        
        colorView1.layer.cornerRadius = 12
        colorView1.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        colorView1.layer.shadowOffset = CGSize(width: 0, height: 4)
        colorView1.layer.shadowRadius = 12
        colorView1.layer.shadowOpacity = 1
        colorView1.layer.masksToBounds = false
        
        colorView2.layer.cornerRadius = 12
        colorView2.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        colorView2.layer.shadowOffset = CGSize(width: 0, height: 4)
        colorView2.layer.shadowRadius = 12
        colorView2.layer.shadowOpacity = 1
        colorView2.layer.masksToBounds = false
        
        colorView3.layer.cornerRadius = 12
        colorView3.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        colorView3.layer.shadowOffset = CGSize(width: 0, height: 4)
        colorView3.layer.shadowRadius = 12
        colorView3.layer.shadowOpacity = 1
        colorView3.layer.masksToBounds = false
        
        colorView4.layer.cornerRadius = 12
        colorView4.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
        colorView4.layer.shadowOffset = CGSize(width: 0, height: 4)
        colorView4.layer.shadowRadius = 12
        colorView4.layer.shadowOpacity = 1
        colorView4.layer.masksToBounds = false
        
        nextBtn.layer.cornerRadius = 8
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(colorView1Tapped))
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(colorView2Tapped))
        
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(colorView3Tapped))
        
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(colorView4Tapped))
        
        colorView1.isUserInteractionEnabled = true
        colorView1.addGestureRecognizer(tapGestureRecognizer1)
        
        colorView2.isUserInteractionEnabled = true
        colorView2.addGestureRecognizer(tapGestureRecognizer2)
        
        colorView3.isUserInteractionEnabled = true
        colorView3.addGestureRecognizer(tapGestureRecognizer3)
        
        colorView4.isUserInteractionEnabled = true
        colorView4.addGestureRecognizer(tapGestureRecognizer4)
        
        changeNextBtnNonActive()
        
    }
    

}
