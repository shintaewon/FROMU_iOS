//
//  EditMyNameViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/09/25.
//

import UIKit

protocol EditMyNameViewControllerDelegate: AnyObject {
    func didUpdateUserName()
}


class EditMyNameViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: EditMyNameViewControllerDelegate?
    var name = ""
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임을 수정하고 싶어?"
        label.font = UIFont.BalsamTint( .size22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.text = name
        textField.font = UIFont.BalsamTint( .size22)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xDEDEE2)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let explainConstraintLabel: UILabel = {
        let label = UILabel()
        label.text = "5글자 이내(특수문자 및 공백 제외)"
        label.font = UIFont.BalsamTint( .size16)
        label.textColor = .icon
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = .disabled
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.titleLabel?.font = UIFont.BalsamTint(.size22)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var completeButtonBottomConstraint: NSLayoutConstraint!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        setupConstraints()
        setupActions()
        setupNavigation()
        fetchData()
    }
    
    // MARK: - UI Setup
    func setupUIComponents() {
        // 기본적인 view 설정
        // 예) backgroundColor, addSubView 등
        self.view.backgroundColor = .white
    }
    
    func setupConstraints() {
        // AutoLayout 또는 다른 방식의 레이아웃 설정
        setupTitleLabel()
        setupTextField()
        setupBottomBorderBorder()
        setupExplainConstraintLabel()
        setupCompleteButton()
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        textField.delegate = self
        
        // 키보드의 등장과 소멸에 대한 알림을 등록합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
        title = "닉네임 수정"
            
        if let customFont = UIFont(name: "777Balsamtint", size: 18) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
        }
    }
    
    // MARK: - Data Handling
    func fetchData() {
        // 네트워크 요청 또는 초기 데이터 로딩
    }
    
    // MARK: - Actions
    @objc private func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        completeButtonBottomConstraint.constant = -(keyboardHeight + 24)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        completeButtonBottomConstraint.constant = -58
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func textDidChange(_ noti: NSNotification) {
        if let text = textField.text {
            
            if text.count == 0 {
                changeCompleteButtonNonActive()
            }
            
            if text.count >= 5 {
                print("걸림")
                let startIndex = text.index(text.startIndex, offsetBy: 0)
                let endIndex = text.index(text.startIndex, offsetBy: 4)
                let substring = text[startIndex...endIndex]
                
                textField.text = substring + " "
                
                let when = DispatchTime.now() + 0.001
                DispatchQueue.main.asyncAfter(deadline: when) {
                    self.textField.text = String(substring)
                }
            }
        }
    }
    
    deinit {
        // 객체가 해제될 때 알림을 해제합니다.
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func completeButtonTapped() {
        editMyName(typeNum: "1", string: textField.text ?? " ")
    }
    
    // MARK: - Helpers
    
    
    
    // MARK: - Functions
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 120),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 34),
        ])
        
    }
    
    private func setupBottomBorderBorder() {
        
        view.addSubview(bottomBorderView)
        
        NSLayoutConstraint.activate([
            bottomBorderView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            bottomBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    private func setupExplainConstraintLabel(){
        view.addSubview(explainConstraintLabel)
        
        NSLayoutConstraint.activate([
            explainConstraintLabel.topAnchor.constraint(equalTo: bottomBorderView.bottomAnchor, constant: 6),
            explainConstraintLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupCompleteButton() {
        view.addSubview(completeButton)
        
        completeButtonBottomConstraint = completeButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -58)
        completeButtonBottomConstraint.isActive = true

        NSLayoutConstraint.activate([
            completeButton.heightAnchor.constraint(equalToConstant: 56),
            completeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    //다음 버튼 활성화시켜주는 함수
    func changeCompleteButtonActive() {
        completeButton.backgroundColor = UIColor.primary01
        completeButton.isEnabled = true
    }
    
    //다음 버튼 비활성화시켜주는 함수
    func changeCompleteButtonNonActive() {
        completeButton.backgroundColor = UIColor.disabled
        completeButton.isEnabled = false
    }
    
    private func editMyName(typeNum: String, string: String) {
        UserAPI.providerUser.request(.updateUserInfo(typeNum: typeNum, string: string)) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(UpdateUserInfoResponse.self)
                    
                    if response.code == 1000{
                        self.delegate?.didUpdateUserName()
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("DEBUG>> editMyName Error : \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - UITextFieldDelegate
extension EditMyNameViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // 현재 텍스트를 가져오고, 새로 입력된 문자를 추가합니다.
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        
        // 정규식 패턴을 설정합니다. 이 패턴은 공백, 숫자, 알파벳 및 한글을 제외한 모든 문자를 찾습니다.
        let pattern = "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9]$"
        // 문자열 길이가 한개 이상인 경우만 패턴 검사 수행
        var resultString = ""
        
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            var index = 0
            let strArr = Array(updatedText)
            while index < strArr.count { // string 문자 하나 마다 개별 정규식 체크
                let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                if checkString.count == 0 {
                    index += 1 // 정규식 패턴 외의 문자가 포함된 경우
                    bottomBorderView.backgroundColor = UIColor.error
                    explainConstraintLabel.textColor = UIColor.error
                    
                    completeButton.isEnabled = false
                    completeButton.backgroundColor = .disabled
                }
                else { // 정규식 포함 패턴의 문자
                    resultString += String(strArr[index]) // 리턴 문자열에 추가
                    index += 1
                    if updatedText == name {
                        completeButton.isEnabled = false
                        completeButton.backgroundColor = .disabled
                    } else {
                        completeButton.isEnabled = true
                        completeButton.backgroundColor = .primary01
                    }
                    
                    bottomBorderView.backgroundColor = UIColor.primary02 // 원래의 색상 값으로 설정
                    explainConstraintLabel.textColor = .icon // 원래의 색상 값으로 설정
                }
            }
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomBorderView.backgroundColor = UIColor.primary02
        explainConstraintLabel.isHidden = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomBorderView.backgroundColor = UIColor(hex: 0xDEDEE2)
        explainConstraintLabel.isHidden = true
    }
}


