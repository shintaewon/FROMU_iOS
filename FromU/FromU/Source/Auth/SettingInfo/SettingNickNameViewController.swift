//
//  SettingNickNameViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/24.
//

import UIKit

class SettingNickNameViewController: UIViewController {

    
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton! //하단 다음 버튼
    
    let bottomBorder = CALayer()
    
    var bottomConstraint: NSLayoutConstraint? //다음 버튼 하단 유동적 Constraint를 위한 변수
    
    //다음 버튼 활성화시켜주는 함수
    func changeNextBtnActive() {
        nextBtn.backgroundColor = UIColor.primary01
        nextBtn.isEnabled = true
    }
    
    //다음 버튼 비활성화시켜주는 함수
    func changeNextBtnNonActive() {
        nextBtn.backgroundColor = UIColor.disabled
        nextBtn.isEnabled = false
    }
    
    //키보드 올라올때 비밀번호 찾기 버튼 같이 따라 올라오게 하기 위한 객체 함수
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight: CGFloat
            keyboardHeight = keyboardSize.height - self.view.safeAreaInsets.bottom
            self.bottomConstraint?.constant = -1 * keyboardHeight - 12
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        debugPrint("keyboardWillHide")
        self.bottomConstraint?.constant = -80
        self.view.layoutIfNeeded()
    }
    
    @objc func textDidChange(_ noti: NSNotification) {
        if let text = nickNameTextField.text {
            if text.count > 0 {
                changeNextBtnActive()
            }
            else{
                changeNextBtnNonActive()
            }
            if text.count >= 5 {
                print("걸림")
                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: 4)
                let substring = text[startIndex...endIndex]
                
                nickNameTextField.text = substring + " "
                
                let when = DispatchTime.now() + 0.001
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.nickNameTextField.text = String(substring)
                }
            }
        }
    }
    
    
    @IBAction func didTapNextBtn(_ sender: Any) {
         
        UserDefaults.standard.set(nickNameTextField.text, forKey: "nickName")

        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingBirthDayViewController") as? SettingBirthDayViewController else {return}

        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.isEnabled = false
        
        nickNameTextField.delegate = self
        
        //화면 어딘가를 눌렀을때 키보드 내리기
        dismissKeyboardWhenTappedAround()
        
        // Set the border style to .none
        nickNameTextField.borderStyle = .none

        // Create a new CALayer for the bottom border
        bottomBorder.frame = CGRect(x: 0, y: nickNameTextField.frame.size.height - 1, width: nickNameTextField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.disabled.cgColor
        
        nickNameTextField.layer.addSublayer(bottomBorder)
        
        
        nextBtn.layer.cornerRadius = 8
        
        //키보드 올라올때 로그인 버튼도 같이 올리기 위한 설정
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.bottomConstraint = NSLayoutConstraint(item: self.nextBtn ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: safeArea, attribute: .bottom, multiplier: 1.0, constant: -80)
        
        self.bottomConstraint?.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
}

extension SettingNickNameViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomBorder.backgroundColor = UIColor.primary02.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomBorder.backgroundColor = UIColor.disabled.cgColor
    }
    
    //return 버튼 눌렀을 때 이벤트 생성
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.nickNameTextField {
            if nextBtn.isEnabled == true{
                nextBtn.sendActions(for: .touchUpInside)
            }
        }
        return true
    }
    
    //공백 입력 방지
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string == " ") {
            return false
        }
        
        return true
    }
}
