//
//  SelectCoverViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/03.
//

import UIKit

class SelectCoverViewController: UIViewController {

    @IBOutlet weak var colorView1: UIView!
    @IBOutlet weak var colorView2: UIView!
    @IBOutlet weak var colorView3: UIView!
    @IBOutlet weak var colorView4: UIView!
    
    
    @IBOutlet weak var nextBtn: UIButton!
    
    var isClickView1 = false
    var isClickView2 = false
    var isClickView3 = false
    var isClickView4 = false
    
    
    
    @objc func colorView1Tapped(){
        isClickView1 = true
        isClickView2 = false
        isClickView3 = false
        isClickView4 = false
        
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
