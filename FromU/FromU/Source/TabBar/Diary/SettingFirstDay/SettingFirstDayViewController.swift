//
//  SettingBirthDayViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/24.
//

import UIKit

class SettingFirstDayViewController: UIViewController {

    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var monthTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton! //하단 다음 버튼
    
    var yearTextCount : Int = 0 // 텍스트 길이 세주는 변수
    var monthTextCount : Int = 0 // 텍스트 길이 세주는 변수
    var dayTextCount : Int = 0 // 텍스트 길이 세주는 변수
    let bottomBorder = CALayer()
    
    var bottomConstraint: NSLayoutConstraint? //다음 버튼 하단 유동적 Constraint를 위한 변수
    
    //다음 버튼 활성화시켜주는 함수
    func changeNextBtnActive() {
        nextBtn.backgroundColor = UIColor.primary01
        bottomBorder.backgroundColor = UIColor.primary02.cgColor
        nextBtn.isEnabled = true
    }
    
    //다음 버튼 비활성화시켜주는 함수
    func changeNextBtnNonActive() {
        nextBtn.backgroundColor = UIColor.disabled
        bottomBorder.backgroundColor = UIColor.disabled.cgColor
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
    
    @IBAction func didTapNextBtn(_ sender: Any) {
         
        let storyboard = UIStoryboard(name: "Invitation", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "InvitationViewController") as? InvitationViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func yearTextFieldDidChange(_ textField: UITextField) {

        yearTextCount = textField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount == 2){
            changeNextBtnActive()
        }
        else{
            changeNextBtnNonActive()
        }
        
        if yearTextCount == 4 {
            monthTextField.becomeFirstResponder()
        }
        
    }
    
    @objc func monthTextFieldDidChange(_ textField: UITextField) {

        monthTextCount = textField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount == 2){
            changeNextBtnActive()
        }
        else{
            changeNextBtnNonActive()
        }
        
        if monthTextCount == 2 {
            dayTextField.becomeFirstResponder()
        }
    }
    
    @objc func dayTextFieldDidChange(_ textField: UITextField) {

        dayTextCount = textField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount == 2){
            changeNextBtnActive()
        }
        else{
            changeNextBtnNonActive()
        }
        
        if dayTextCount == 2 {
            dismissKeyboard()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "디데이 설정"
        
        
        
        yearTextField.delegate = self
        monthTextField.delegate = self
        dayTextField.delegate = self
        
        //화면 어딘가를 눌렀을때 키보드 내리기
        dismissKeyboardWhenTappedAround()
        
        // Set the border style to .none
        yearTextField.borderStyle = .none
        monthTextField.borderStyle = .none
        dayTextField.borderStyle = .none

        nextBtn.layer.cornerRadius = 8
        
        //키보드 올라올때 로그인 버튼도 같이 올리기 위한 설정
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.bottomConstraint = NSLayoutConstraint(item: self.nextBtn ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: safeArea, attribute: .bottom, multiplier: 1.0, constant: -80)
        
        self.bottomConstraint?.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        yearTextField.addTarget(self, action: #selector(SettingBirthDayViewController.yearTextFieldDidChange(_:)), for: .editingChanged)
        
        monthTextField.addTarget(self, action: #selector(SettingBirthDayViewController.monthTextFieldDidChange(_:)), for: .editingChanged)
        
        dayTextField.addTarget(self, action: #selector(SettingBirthDayViewController.dayTextFieldDidChange(_:)), for: .editingChanged)
    }

}

extension SettingFirstDayViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    //return 버튼 눌렀을 때 이벤트 생성
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.dayTextField {
            if nextBtn.isEnabled == true{
                nextBtn.sendActions(for: .touchUpInside)
            }
        }
            return true
        }
    
    //공백 입력 방지 && 최대숫자 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == yearTextField{
     
            let maxLength = 4
            let currentString = (textField.text ?? "") as NSString
            
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
                
            }
        else{
            let maxLength = 2
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        
        return true
    }
    
}
