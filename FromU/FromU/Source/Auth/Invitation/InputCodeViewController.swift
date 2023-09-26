//
//  InputCodeViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/27.
//

import UIKit

import SwiftKeychainWrapper

class InputCodeViewController: UIViewController {

    @IBOutlet weak var connectBtn: UIButton! //하단 다음 버튼
    
    @IBOutlet weak var explainLabel: UILabel!
    
    let bottomBorder = CALayer()
    
    var bottomConstraint: NSLayoutConstraint? //다음 버튼 하단 유동적 Constraint를 위한 변수
    
    @IBOutlet weak var codeTextField: UITextField!
    
    //다음 버튼 활성화시켜주는 함수
    func changeConnectBtnActive() {
        connectBtn.backgroundColor = UIColor.primary01
        connectBtn.isEnabled = true
    }

    //다음 버튼 비활성화시켜주는 함수
    func changeConnectBtnNonActive() {
        connectBtn.backgroundColor = UIColor.disabled
        connectBtn.isEnabled = false
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
        if codeTextField.text?.count == 8 {
            changeConnectBtnActive()
        }
        else{
            changeConnectBtnNonActive()
        }
    
    }
    
    @IBAction func didTapConnectBtn(_ sender: Any) {
         
        inputPartnerCode()
        
//        if codeTextField.text == "11111111"{
//            let storyboard = UIStoryboard(name: "MatchingComplete", bundle: nil)
//
//            guard let vc = storyboard.instantiateViewController(withIdentifier: "MatchingCompleteViewController") as? MatchingCompleteViewController else{ return }
//
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//        else{
//            showToast(message: "존재하지 않는 코드를 입력했어!", font: UIFont.Pretendard(.regular, size: 14))
//        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        connectBtn.isEnabled = false
        
        codeTextField.delegate = self
        
        //화면 어딘가를 눌렀을때 키보드 내리기
        dismissKeyboardWhenTappedAround()
        
        // Set the border style to .none
        codeTextField.borderStyle = .none
        
        connectBtn.layer.cornerRadius = 8
        
        //키보드 올라올때 로그인 버튼도 같이 올리기 위한 설정
        let safeArea = self.view.safeAreaLayoutGuide
        
        self.bottomConstraint = NSLayoutConstraint(item: self.connectBtn ?? UIButton(), attribute: .bottom, relatedBy: .equal, toItem: safeArea, attribute: .bottom, multiplier: 1.0, constant: -80)
        
        self.bottomConstraint?.isActive = true
        
        // Create a new CALayer for the bottom border
        bottomBorder.frame = CGRect(x: 0, y: codeTextField.frame.size.height - 1, width: codeTextField.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.disabled.cgColor
        
        codeTextField.layer.addSublayer(bottomBorder)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }

}

extension InputCodeViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomBorder.backgroundColor = UIColor.primary02.cgColor
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomBorder.backgroundColor = UIColor.disabled.cgColor
    }

    //return 버튼 눌렀을 때 이벤트 생성
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.codeTextField {
            if codeTextField.isEnabled == true{
                codeTextField.sendActions(for: .touchUpInside)
            }
        }
        return true
    }
    
    //공백 입력 방지
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (string == " ") {
            return false
        }
        
        let maxLength = 8
        let currentString = (textField.text ?? "") as NSString
        
        let newString = currentString.replacingCharacters(in: range, with: string)

        return newString.count <= maxLength
        
        return true
    }
}

extension InputCodeViewController{
    
    func inputPartnerCode(){
        print("code:", codeTextField.text ?? "")
        CoupleAPI.providerCouple.request( .inputPartnerCode(partnerCode: codeTextField.text ?? "")){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(InputPartnerCodeResponse.self)
                    
                    print(response)
                    //일단 엔드포인트 호출 성공
                    if response.isSuccess == true{
                        
                        //코드 잘못 입력한겨
                        if response.code == 4001 {
                            self.showToast(message: "존재하지 않는 코드를 입력했어!", font: UIFont.Pretendard(.regular, size: 14))
                        }
                        //이미 커플 매칭 완료.. 바람..?
                        else if response.code == 2020 {
                            
                            self.showToast(message: "이미 커플 매칭이 완료된 유저입니다.", font: UIFont.Pretendard(.regular, size: 14))
                        }
                        //매칭 성공
                        else if response.code == 1000 {
                            
                            UserDefaults.standard.set(response.result?.partnerNickname, forKey: "partnerNickName")
                            
                            UserDefaults.standard.set(response.result?.nickname, forKey: "nickName")
                            
                            KeychainWrapper.standard.set(response.result?.coupleID ?? 0, forKey: "coupleID")
                                                        
                            let storyboard = UIStoryboard(name: "MatchingComplete", bundle: nil)
                            guard let vc = storyboard.instantiateViewController(withIdentifier: "MatchingCompleteViewController") as? MatchingCompleteViewController else{ return }
                
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
            
                } catch {
                    print(error)
                }

            case .failure(let error):
                print("DEBUG>> signUpFromU Error : \(error.localizedDescription)")
            }
        }
    }
}

//Toast Message를 위한 클래스 extension(코드길이가 길어서 밑에 빼둠)
extension InputCodeViewController{
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: explainLabel.layer.frame.origin.x, y: explainLabel.layer.frame.origin.y - 94, width: self.view.frame.width - explainLabel.layer.frame.origin.x * 2 , height: 52))
        toastLabel.backgroundColor = UIColor(red: 0.167, green: 0.167, blue: 0.167, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 5.0, delay: 0.1, options: .curveEaseOut,animations: {
            toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
}

