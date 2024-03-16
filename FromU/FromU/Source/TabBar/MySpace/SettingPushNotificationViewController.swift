//
//  SettingPushNotificationViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/10/04.
//

import UIKit

import DropDown

class SettingPushNotificationViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dropdownView: UIView = {
        let view = UIView()
        view.backgroundColor = .none
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    
    let downButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "icn_down"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(downButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy private var messageTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.BalsamTint( .size22)
        textField.textColor = .black
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = .primary02
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private var completeButton: UIButton = {
        let button = UIButton()
        button.setTitle("변경완료", for: .normal)
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
    
    let dropdown = DropDown()
    
    let messageList = ["오늘 너의 하루가 궁금해:)", "쟈깅 일기쓰고 있어?", "빨리 일기장 내놔 -ㅅ-"]
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        setupConstraints()
        setupActions()
        setupNavigation()
        fetchData()
        // messageTextField의 초기값 설정
        setMessageTextFieldInitialValue()

    }
    
    // MARK: - UI Setup
    func setupUIComponents() {
        // 기본적인 view 설정
        // 예) backgroundColor, addSubView 등
        view.backgroundColor = .white
        title = "알림 메세지"
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.BalsamTint( .size18),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
    }
    
    func setupConstraints() {
        // AutoLayout 또는 다른 방식의 레이아웃 설정
        setupTitleLabel()
        setupDropdownView()
        setupDownButton()
        setupMessageTextField()
        setupDropdown()
        setupBottomBorderView()
        setupCompleteButton()
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
                
        // 키보드의 등장과 소멸에 대한 알림을 등록합니다.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
    }
    
    // MARK: - Data Handling
    func fetchData() {
        // 네트워크 요청 또는 초기 데이터 로딩
    }
    
    // MARK: - Actions
    @objc private func downButtonTapped() {
        dropdown.show()
    }
    
    @objc private func completeButtonTapped() {
        //API 날리기
    }
    
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
    
    // MARK: - Helpers
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // MARK: - Functions
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        
        titleLabel.font = UIFont.BalsamTint(.size22)

        let attributedString = NSMutableAttributedString(string: "연인에게 울릴\n알람 메세지를 바꿔볼래?")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        paragraphStyle.alignment = .left
        // 현재 텍스트 뷰의 스타일을 가져옴
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
    
        titleLabel.attributedText = attributedString
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupDropdownView() {
        view.addSubview(dropdownView)
        
        NSLayoutConstraint.activate([
            dropdownView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            dropdownView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            dropdownView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dropdownView.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupDownButton() {
        dropdownView.addSubview(downButton)
        
        NSLayoutConstraint.activate([
            downButton.trailingAnchor.constraint(equalTo: dropdownView.trailingAnchor, constant: -12),
            downButton.centerYAnchor.constraint(equalTo: dropdownView.centerYAnchor),
            downButton.heightAnchor.constraint(equalToConstant: 24),
            downButton.widthAnchor.constraint(equalToConstant: 24),
        ])
    }
    
    private func setupMessageTextField() {
        dropdownView.addSubview(messageTextField)
        
        NSLayoutConstraint.activate([
            messageTextField.leadingAnchor.constraint(equalTo: dropdownView.leadingAnchor, constant: 12),
            messageTextField.trailingAnchor.constraint(equalTo: downButton.leadingAnchor, constant: 0),
            messageTextField.centerYAnchor.constraint(equalTo: dropdownView.centerYAnchor),
            messageTextField.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func setupBottomBorderView() {
        dropdownView.addSubview(bottomBorderView)
        
        NSLayoutConstraint.activate([
            bottomBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            bottomBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            bottomBorderView.topAnchor.constraint(equalTo: dropdownView.bottomAnchor, constant: -1),
            bottomBorderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupDropdown(){
        
        DropDown.appearance().textColor = UIColor.black // 아이템 텍스트 색상
        DropDown.appearance().selectedTextColor = UIColor.red // 선택된 아이템 텍스트 색상
        DropDown.appearance().backgroundColor = UIColor.white // 아이템 팝업 배경 색상
        DropDown.appearance().selectionBackgroundColor = UIColor.lightGray // 선택한 아이템 배경 색상
        DropDown.appearance().setupCornerRadius(8)
        dropdown.dismissMode = .automatic // 팝업을 닫을 모드 설정
        dropdown.cellHeight = 56
        dropdown.direction = .bottom
        dropdown.selectedTextColor = .black
        dropdown.selectionBackgroundColor = .primaryLight
        dropdown.textFont = .BalsamTint( .size18)
        messageTextField.text = UserDefaults.standard.string(forKey: "alertMessage") // 힌트 텍스트
        
        dropdown.dataSource = messageList
            
        // anchorView를 통해 UI와 연결
        dropdown.anchorView = self.dropdownView

        // View를 갖리지 않고 View아래에 Item 팝업이 붙도록 설정
        dropdown.bottomOffset = CGPoint(x: 0, y: dropdownView.bounds.height + 64)
        
        // Item 선택 시 처리
        dropdown.selectionAction = { [weak self] (index, item) in
            //선택한 Item을 TextField에 넣어준다.
            self!.messageTextField.text = item
            self?.updateCompleteButtonState()
        }
        
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
    
    func setMessageTextFieldInitialValue() {
        // UserDefaults에서 값이 있으면 그 값을 사용하고, 없으면 기본 값을 사용
        let initialMessage = UserDefaults.standard.string(forKey: "alertMessage") ?? "빨리 일기장 내놔 -ㅅ-"
        messageTextField.text = initialMessage
        
        // completeButton 초기 상태 업데이트
        updateCompleteButtonState()
    }

    func updateCompleteButtonState() {
        let initialMessage = UserDefaults.standard.string(forKey: "alertMessage") ?? "빨리 일기장 내놔 -ㅅ-"
        guard let currentText = messageTextField.text else { return }
        
        if currentText != initialMessage && currentText != "직접 입력하기" && currentText != "" {
            completeButton.backgroundColor = .primary01
            completeButton.isEnabled = true
        } else {
            completeButton.backgroundColor = .disabled
            completeButton.isEnabled = false
        }
    }
}

extension SettingPushNotificationViewController{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 이 메서드가 호출된 직후에 textField의 텍스트는 아직 업데이트되지 않았습니다.
        // 따라서 예상되는 최종 텍스트를 계산합니다.
        if let currentText = textField.text, let textRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: textRange, with: string)
            textField.text = updatedText
        }
        
        // 여기서 상태 업데이트 메서드를 호출합니다.
        updateCompleteButtonState()
        
        return false // 우리가 직접 텍스트를 설정하기 때문에 false를 반환합니다.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        completeButton.backgroundColor = .disabled
        textField.text = ""
        textField.placeholder = "직접 입력하기"
    }
}
