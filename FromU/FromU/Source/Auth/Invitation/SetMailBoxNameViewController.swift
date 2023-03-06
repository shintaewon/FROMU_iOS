//
//  SetMailBoxNameViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/28.
//

import UIKit

import Moya

class SetMailBoxNameViewController: UIViewController {

    
    @IBOutlet weak var mailboxNameTextField: UITextField!
    
    @IBOutlet weak var decideBtn: UIButton! //하단 다음 버튼
    
    let bottomBorder = CALayer()
    
    var bottomConstraint: NSLayoutConstraint? //다음 버튼 하단 유동적 Constraint를 위한 변수
    
    var isKeyboardAppear = false
    
    //다음 버튼 활성화시켜주는 함수
    func changeDecideBtnActive() {
        decideBtn.backgroundColor = UIColor.primary01
        decideBtn.isEnabled = true
    }
    
    //다음 버튼 비활성화시켜주는 함수
    func changeDecideBtnNonActive() {
        decideBtn.backgroundColor = UIColor.disabled
        decideBtn.isEnabled = false
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
        if let text = mailboxNameTextField.text {
            if text.count > 0 {
                changeDecideBtnActive()
            }
            else{
                changeDecideBtnNonActive()
            }
            if text.count >= 4 {
                print("걸림")
                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: 3)
                let substring = text[startIndex...endIndex]
                
                mailboxNameTextField.text = substring + " "
                
                let when = DispatchTime.now() + 0.01
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.mailboxNameTextField.text = String(substring)
                }
            }
        }
    }
    
    
    @IBAction func didTapDecideBtn(_ sender: Any) {
         
        if isKeyboardAppear == true{
            view.endEditing(true)
        }
        else{
            
            checkMailBoxName()
//            let storyboard = UIStoryboard(name: "Diary", bundle: nil)
//
//            guard let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {return}
//
//            vc.modalPresentationStyle = .fullScreen
//
//            self.present(vc, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decideBtn.isEnabled = false
        
        mailboxNameTextField.delegate = self
        
        //화면 어딘가를 눌렀을때 키보드 내리기
        dismissKeyboardWhenTappedAround()
        
        // Set the border style to .none
        mailboxNameTextField.borderStyle = .none

        // Create a new CALayer for the bottom border
        bottomBorder.frame = CGRect(x: 0, y: mailboxNameTextField.frame.size.height - 1, width: mailboxNameTextField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.disabled.cgColor
        
        mailboxNameTextField.layer.addSublayer(bottomBorder)
        
        
        decideBtn.layer.cornerRadius = 8
        
        //키보드 올라올때 로그인 버튼도 같이 올리기 위한 설정
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.bottomConstraint = NSLayoutConstraint(item: self.decideBtn ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: safeArea, attribute: .bottom, multiplier: 1.0, constant: -80)
        
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

extension SetMailBoxNameViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isKeyboardAppear = true
        changeDecideBtnNonActive()
        textField.text = ""
        bottomBorder.backgroundColor = UIColor.primary02.cgColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        bottomBorder.backgroundColor = UIColor.disabled.cgColor
        
        isKeyboardAppear = false
        
        if textField.text != ""{
            textField.text = (textField.text ?? " ") + "함"
        }
    }
    
    //return 버튼 눌렀을 때 이벤트 생성
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.mailboxNameTextField {
            if decideBtn.isEnabled == true{
                decideBtn.sendActions(for: .touchUpInside)
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

extension SetMailBoxNameViewController{
    
    func checkMailBoxName(){
        
        let mailBoxName = mailboxNameTextField.text
        let suffix = "함"
        
        let result = mailBoxName?.replacingOccurrences(of: suffix, with: "") ?? ""
        print(result) // Output: 우편
        
        CoupleAPI.providerCouple.request( .checkMail(mailboxName: result)){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(CheckMailResponse.self)
                    print(response)
                    
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> checkMailBoxName Error : \(error.localizedDescription)")
            }
        }
    }

    
    func setMailBoxName(){
        CoupleAPI.providerCouple.request( .setMailBoxName(mailboxName: mailboxNameTextField.text ?? "")){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(InputPartnerCodeResponse.self)
                    
                    
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> signUpFromU Error : \(error.localizedDescription)")
            }
        }
    }
}
