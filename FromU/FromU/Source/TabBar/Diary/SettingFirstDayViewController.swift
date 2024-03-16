//
//  SettingBirthDayViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/24.
//

import UIKit

import Moya

class SettingFirstDayViewController: UIViewController {

    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var monthTextField: UITextField!
    
    @IBOutlet weak var dayTextField: UITextField!
    
    @IBOutlet weak var nextBtn: UIButton! //하단 다음 버튼
    
    var yearTextCount : Int = 0 // 텍스트 길이 세주는 변수
    var monthTextCount : Int = 0 // 텍스트 길이 세주는 변수
    var dayTextCount : Int = 0 // 텍스트 길이 세주는 변수
    
    @IBOutlet var bottomBorder: UIView!
    
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
    
    @IBAction func didTapNextBtn(_ sender: Any) {
         
        var completeBirthDay = yearTextField.text ?? ""
        
        if monthTextField.text?.count == 1 {
            completeBirthDay = completeBirthDay + "0" +  (monthTextField.text ?? "")
        }
        else{
            completeBirthDay = completeBirthDay + (monthTextField.text ?? "")
        }
        
        if dayTextField.text?.count == 1 {
            completeBirthDay = completeBirthDay + "0" +  (dayTextField.text ?? "")
        }
        else{
            completeBirthDay = completeBirthDay + (dayTextField.text ?? "")
        }
        
        print("completeBirthDay:", completeBirthDay)

        postFirstMetDay(day: completeBirthDay)
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
        
        if (yearTextCount == 4) && (monthTextCount > 0) && (dayTextCount == 2){
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
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount > 0){
            changeNextBtnActive()
        }
        else{
            changeNextBtnNonActive()
        }

        
        if dayTextCount == 2 {
            dismissKeyboard()
        }
        
    }
    
    func checkValidation(){
        yearTextCount = yearTextField.text?.count ?? 0
        monthTextCount = monthTextField.text?.count ?? 0
        dayTextCount = dayTextField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount == 2){
            changeNextBtnActive()
        }
        else{
            changeNextBtnNonActive()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextBtn.isEnabled = false
        
        
        yearTextField.font = .BalsamTint( .size22)
        monthTextField.font = .BalsamTint( .size22)
        dayTextField.font = .BalsamTint( .size22)
        
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

    override func viewWillAppear(_ animated: Bool) {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.tintColor = .icon
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
}

extension SettingFirstDayViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomBorder.backgroundColor = UIColor.primary02
        textField.text = ""
        changeNextBtnNonActive()
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomBorder.backgroundColor = UIColor.disabled
        if textField == monthTextField{
            if textField.text?.count == 1 {
                textField.text = "0" + (textField.text ?? "")
            }
        }
        else if textField == dayTextField{
            if textField.text?.count == 1 {
                textField.text = "0" + (textField.text ?? "")
            }
        }
        checkValidation()
    }
    
    //공백 입력 방지 && 최대숫자 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == yearTextField{
     
            // Check if the resulting text will be within the range of 1 to 12
            if let text = textField.text, let range = Range(range, in: text), let input = Int(string) {
                
                let newText = text.replacingCharacters(in: range, with: String(input))
                if let number = Int(newText), (1...2023).contains(number) {
                    print(number)
                    return true
                }
                else{
                    return false
                }
                
            }
            
            let maxLength = 4
            let currentString = (textField.text ?? "") as NSString
            
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
                
            }
        else if textField == monthTextField{
            
            // Check if the resulting text will be within the range of 1 to 12
            if let text = textField.text, let range = Range(range, in: text), let input = Int(string) {
                
                let newText = text.replacingCharacters(in: range, with: String(input))
                if let number = Int(newText), (1...12).contains(number) {
                    print(number)
                    return true
                }
                else{
                    return false
                }
                
            }
            
            let maxLength = 2
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        else{
            // Check if the resulting text will be within the range of 1 to 12
            if let text = textField.text, let range = Range(range, in: text), let input = Int(string) {
                
                let newText = text.replacingCharacters(in: range, with: String(input))
                if let number = Int(newText), (1...31).contains(number) {
                    print(number)
                    return true
                }
                else{
                    return false
                }
                
            }
            
            let maxLength = 2
            let currentString = (textField.text ?? "") as NSString
            let newString = currentString.replacingCharacters(in: range, with: string)

            return newString.count <= maxLength
        }
        
        if (string == " ") {
            return false
        }
        
        return true
    }
    
}

extension SettingFirstDayViewController{
    
    func postFirstMetDay(day: String){
        
        CoupleAPI.providerCouple.request(.setFirstMetDay(firstMetDay: day)){ result in
            switch result{
            case .success(let data):
                do{
                    let response = try data.map(FirstMetDayResponse.self)
                    if response.isSuccess == true{
                        if response.code == 1000{
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    print(response)
                } catch{
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> postFirstMetDay Error : \(error.localizedDescription)")
                
            }
        }
    }
}
