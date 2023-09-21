//
//  PlusCalendarUIViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/09/13.
//
import UIKit

class PlusCalendarUIViewController: UIViewController {

    // MARK: - Properties
    private let handleView: UIView = {
        let view = UIView()
        view.backgroundColor = .disabled
        view.layer.cornerRadius = 2
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        
        button.setImage(UIImage(named: "icn_exit"), for: .normal)
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "일정을 추가해줘!"
        label.font = UIFont.BalsamTint( .size22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var textField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let bottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xDEDEE2)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let limitTextLabel: UILabel = {
        let label = UILabel()
        label.text = "20자 이내"
        label.font = UIFont.BalsamTint( .size16)
        label.textColor = .icon
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
        setupHandleView()
        setupDismissButton()
        setupTitleLabel()
        setupTextField()
        setupBottomBorderBorder()
        setupLimitTextLabel()
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        textField.delegate = self
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
    @objc private func dismissButtonTapped() {
        self.dismiss(animated: true)
    }
    
    @objc private func textFieldTextChanged(_ textField: UITextField) {
        if let text = textField.text, text.isEmpty {
            bottomBorderView.backgroundColor = UIColor(hex: 0xDEDEE2)
            completeButton.backgroundColor = .disabled
            completeButton.isEnabled = false
        } else {
            bottomBorderView.backgroundColor = UIColor.primary01
            completeButton.backgroundColor = .primary01
            completeButton.isEnabled = true
        }
    }
    
    @objc private func completeButtonTapped() {
        
        let vc = ConfirmSendReviewAlertViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve

        self.present(vc, animated: true, completion: nil)

    }
    
    // MARK: - Helpers
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // MARK: - Functions

    private func setupDismissButton(){
        view.addSubview(dismissButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupHandleView(){
        view.addSubview(handleView)
        
        NSLayoutConstraint.activate([
            handleView.widthAnchor.constraint(equalToConstant: 30),
            handleView.heightAnchor.constraint(equalToConstant: 4),
            handleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            handleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupTextField() {
        view.addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 44),
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
    
    private func setupLimitTextLabel() {
        
        view.addSubview(limitTextLabel)
        
        NSLayoutConstraint.activate([
            limitTextLabel.topAnchor.constraint(equalTo: bottomBorderView.bottomAnchor, constant: 6),
            limitTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            limitTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - UITextFieldDelegate
extension PlusCalendarUIViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        return updatedText.count <= 20 // Limit to 20 characters
    }
}
