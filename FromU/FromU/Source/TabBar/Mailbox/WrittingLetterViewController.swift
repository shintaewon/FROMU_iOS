//
//  WrittingLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/04/26.
//

import UIKit

class WrittingLetterViewController: UIViewController {

    // MARK: - Properties
    var bgLetterNum = 0
        
    private var letterTextView: UITextView = {
        
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.BalsamTint(.size18)
        textView.textAlignment = .center
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    lazy private var letterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "letter\(self.bgLetterNum)")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var stampImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stamp\(bgLetterNum)_small")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private var characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/300"
        label.font = UIFont.BalsamTint(.size16)
        label.textColor = .gray06
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc private func sendBtnTapped() {
        sendLetter()
    }
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIComponents()
        setupConstraints()
        setupActions()
        setupNavigation()
        fetchData()
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - UI Setup
    func setupUIComponents() {
        // 기본적인 view 설정
        // 예) backgroundColor, addSubView 등
        view.backgroundColor = .white
        
    }
    
    func setupConstraints() {
        // AutoLayout 또는 다른 방식의 레이아웃 설정
        setupLetterImageView()
        setupLetterTextView()
        setupStampImageView()
        addDoneButtonOnKeyboard()
        setupCharacterCountLabel()
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
        let customButton = UIButton(type: .system)
        customButton.setTitle("편지 보내기", for: .normal)
        customButton.titleLabel?.font = UIFont.BalsamTint(.size18)
        customButton.setTitleColor(UIColor.disabledText, for: .normal)
        customButton.addTarget(self, action: #selector(sendReplyButtonTapped), for: .touchUpInside)
        
        let sendLetterButton = UIBarButtonItem(customView: customButton)
        
        navigationItem.rightBarButtonItem = sendLetterButton
    }
    
    // MARK: - Data Handling
    func fetchData() {
        // 네트워크 요청 또는 초기 데이터 로딩
    }
    
    // MARK: - Actions
    @objc func doneButtonTapped() {
        letterTextView.resignFirstResponder()
    }

    @objc func sendReplyButtonTapped() {
        
        sendLetter()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let toolbarHeight: CGFloat = 44
            let additionalPadding: CGFloat = 10
            let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + toolbarHeight + additionalPadding, right: 0)
            letterTextView.contentInset = contentInsets
            letterTextView.scrollIndicatorInsets = contentInsets
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        letterTextView.contentInset = UIEdgeInsets.zero
        letterTextView.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    // MARK: - Functions
    private func hideBars() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func showBars() {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func addDoneButtonOnKeyboard() {
        // 키보드에 'Done' 버튼을 추가합니다.
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .primary01
        toolbar.items = [flexibleSpace, doneButton]

        letterTextView.inputAccessoryView = toolbar

    }
    
    private func setupStampImageView(){
     
        view.addSubview(stampImageView)
        
        NSLayoutConstraint.activate([
            stampImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 28),
            stampImageView.trailingAnchor.constraint(equalTo: letterImageView.trailingAnchor, constant: -22),
            stampImageView.heightAnchor.constraint(equalToConstant: 58),
            stampImageView.widthAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    private func setupLetterImageView(){
        
        view.addSubview(letterImageView)
        
        NSLayoutConstraint.activate([
            letterImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            letterImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            letterImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            letterImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupLetterTextView(){
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.BalsamTint(.size18),
            .paragraphStyle: paragraphStyle
        ]
        
        letterTextView.typingAttributes = attributes
        letterTextView.textAlignment = .center
        letterTextView.delegate = self
        
        view.addSubview(letterTextView)
        
        NSLayoutConstraint.activate([
            letterTextView.topAnchor.constraint(equalTo: letterImageView.topAnchor, constant: 86),
            letterTextView.leadingAnchor.constraint(equalTo: letterImageView.leadingAnchor, constant: 22),
            letterTextView.trailingAnchor.constraint(equalTo: letterImageView.trailingAnchor, constant: -22),
            letterTextView.bottomAnchor.constraint(equalTo: letterImageView.bottomAnchor, constant: 0)
        ])
        
    }
    
    private func setupCharacterCountLabel(){
        let overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = .clear
        overlayView.isUserInteractionEnabled = false // 추가된 코드
        view.addSubview(overlayView)

        overlayView.addSubview(characterCountLabel)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: letterTextView.topAnchor),
            overlayView.leadingAnchor.constraint(equalTo: letterTextView.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: letterTextView.trailingAnchor),
            overlayView.bottomAnchor.constraint(equalTo: letterTextView.bottomAnchor, constant: -54),

            characterCountLabel.bottomAnchor.constraint(equalTo: overlayView.bottomAnchor, constant: -50),
            characterCountLabel.trailingAnchor.constraint(equalTo: overlayView.trailingAnchor, constant: 0)
        ])
    }


}


extension WrittingLetterViewController{
    
    func sendLetter(){
       
        LetterAPI.providerLetter.request( .sendLetter(content: letterTextView.text, stampNum: bgLetterNum)){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(SendLetterResponse.self)
                                        
                    print(response)
                    
                    if response.isSuccess == true {
                        if response.code == 1000 {
                            let stroyboard = UIStoryboard(name: "CompleteSendLetter", bundle: nil)
                            
                            guard let vc = stroyboard.instantiateViewController(withIdentifier: "CompleteSendLetterViewController") as? CompleteSendLetterViewController else { return }
                            vc.mailboxName = response.result?.receiveMailboxName ?? "아무개"
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                    
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> setMailBoxName Error : \(error.localizedDescription)")
            }
        }
    }
}

extension WrittingLetterViewController: UITextViewDelegate, UIScrollViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.BalsamTint(.size18),
            .paragraphStyle: paragraphStyle
        ]
        
        textView.typingAttributes = attributes
                
        let count = textView.text.count
        characterCountLabel.text = "\(count)/300"
        
        // 최대 300자 제한
        if count > 300 {
            let index = textView.text.index(textView.text.startIndex, offsetBy: 300)
            textView.text = String(textView.text.prefix(upTo: index))
            characterCountLabel.text = "300/300"
        }
        
        // Navigation Button Color Update
        if let customView = navigationItem.rightBarButtonItem?.customView as? UIButton {
            if count > 0 {
                customView.isEnabled = true
                customView.setTitleColor( .primary01, for: .normal)
            } else {
                customView.isEnabled = false
                customView.setTitleColor( .disabledText, for: .normal)
            }
        }
        
        adjustCharacterCountLabelPosition()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == letterTextView {
            adjustCharacterCountLabelPosition()
        }
    }
    
    private func adjustCharacterCountLabelPosition() {
        if letterTextView.text.isEmpty {
            // 텍스트가 비어있을 때 원래 위치로 복구
            characterCountLabel.transform = .identity
        } else {
            let yOffset = letterTextView.contentSize.height - (letterTextView.frame.size.height + letterTextView.contentOffset.y - 134)
            // characterCountLabel의 위치를 UITextView의 오른쪽 하단에 고정
            characterCountLabel.transform = CGAffineTransform(translationX: 0, y: yOffset)
        }
    }

}
