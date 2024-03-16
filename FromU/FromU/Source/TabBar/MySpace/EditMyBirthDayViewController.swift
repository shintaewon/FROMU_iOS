//
//  EditMyBirthDayViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/09/25.
//

import UIKit

protocol EditMyBirthDayViewControllerDelegate: AnyObject {
    func didUpdateUserBirthday()
}


class EditMyBirthDayViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: EditMyBirthDayViewControllerDelegate?
   
    var yearTextCount : Int = 0 // 텍스트 길이 세주는 변수
    var monthTextCount : Int = 0 // 텍스트 길이 세주는 변수
    var dayTextCount : Int = 0 // 텍스트 길이 세주는 변수
    
    var birthday = ""
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "생일을 수정하고 싶어?"
        label.font = UIFont.BalsamTint( .size22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var yearTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.BalsamTint( .size22)
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let firstSlashLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = UIFont.BalsamTint( .size18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var monthTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.BalsamTint( .size22)
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let secondSlashLabel: UILabel = {
        let label = UILabel()
        label.text = "/"
        label.font = UIFont.BalsamTint( .size18)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var dayTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.BalsamTint( .size22)
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [yearTextField, firstSlashLabel, monthTextField, secondSlashLabel, dayTextField])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xDEDEE2)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
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
        setupStackView()
        setupBottomBorderBorder()
        setupCompleteButton()
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        yearTextField.delegate = self
        monthTextField.delegate = self
        dayTextField.delegate = self
        
        // 키보드의 등장과 소멸에 대한 알림을 등록합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        yearTextField.addTarget(self, action: #selector(EditMyBirthDayViewController.yearTextFieldDidChange(_:)), for: .editingChanged)
        
        monthTextField.addTarget(self, action: #selector(EditMyBirthDayViewController.monthTextFieldDidChange(_:)), for: .editingChanged)
        
        dayTextField.addTarget(self, action: #selector(EditMyBirthDayViewController.dayTextFieldDidChange(_:)), for: .editingChanged)
    
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
        
        title = "생일 수정"
            
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
    
    deinit {
        // 객체가 해제될 때 알림을 해제합니다.
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func completeButtonTapped() {
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
        
        print("completeBirthDay: ", completeBirthDay)
        
        editMyBirthday(typeNum: "2", string: completeBirthDay)
    }
    
    @objc func yearTextFieldDidChange(_ textField: UITextField) {

        yearTextCount = textField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount == 2){
            changeCompleteButtonActive()
        }
        else{
            changeCompleteButtonNonActive()
        }
        
        if yearTextCount == 4 {
            monthTextField.becomeFirstResponder()
        }
        
    }
    
    @objc func monthTextFieldDidChange(_ textField: UITextField) {

        monthTextCount = textField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount > 0) && (dayTextCount == 2){
            changeCompleteButtonActive()
        }
        else{
            changeCompleteButtonNonActive()
        }
        
        if monthTextCount == 2 {
            dayTextField.becomeFirstResponder()
        }
    }
    
    @objc func dayTextFieldDidChange(_ textField: UITextField) {

        dayTextCount = textField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount > 0){
            changeCompleteButtonActive()
        }
        else{
            changeCompleteButtonNonActive()
        }

        
        if dayTextCount == 2 {
            dismissKeyboard()
        }
        
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
    
    private func setupStackView() {
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 120),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        let components = birthday.split(separator: ".")
            
        // 나눈 문자열의 각 부분을 텍스트 필드의 text로 설정합니다.
        if components.count == 3 {
            yearTextField.text = String(components[0]).trimmingCharacters(in: .whitespaces)
            monthTextField.text = String(components[1]).trimmingCharacters(in: .whitespaces)
            dayTextField.text = String(components[2]).trimmingCharacters(in: .whitespaces)
        }
    }

    
    private func setupBottomBorderBorder() {
        
        view.addSubview(bottomBorderView)
        
        NSLayoutConstraint.activate([
            bottomBorderView.topAnchor.constraint(equalTo: stackView.bottomAnchor),
            bottomBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bottomBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1),
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
    
    func checkValidation(){
        yearTextCount = yearTextField.text?.count ?? 0
        monthTextCount = monthTextField.text?.count ?? 0
        dayTextCount = dayTextField.text?.count ?? 0
        
        if (yearTextCount == 4) && (monthTextCount == 2) && (dayTextCount == 2){
            changeCompleteButtonActive()
        }
        else{
            changeCompleteButtonNonActive()
        }
        
    }
    
    private func editMyBirthday(typeNum: String, string: String) {
        UserAPI.providerUser.request(.updateUserInfo(typeNum: typeNum, string: string)) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(UpdateUserInfoResponse.self)
                    
                    if response.code == 1000{
                        self.delegate?.didUpdateUserBirthday()
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
extension EditMyBirthDayViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomBorderView.backgroundColor = UIColor.primary02
        textField.text = ""
        changeCompleteButtonNonActive()
    }
    
    //return 버튼 눌렀을 때 이벤트 생성
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.dayTextField {
            if completeButton.isEnabled == true{
                completeButton.sendActions(for: .touchUpInside)
            }
        }
            return true
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        bottomBorderView.backgroundColor = UIColor.disabled
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
