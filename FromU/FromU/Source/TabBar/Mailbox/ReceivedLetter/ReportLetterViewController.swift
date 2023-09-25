//
//  ReportLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/18.
//

import UIKit

class ReportLetterViewController: UIViewController {

    // MARK: - Properties
    var letterID: Int = 0
    
    private var reportExplainLabel: UILabel = {
        
        let label = UILabel()
        label.text = "이 사용자를 신고할까요?"
        label.font = .BalsamTint(.size22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var reportTextView: UITextView = {
        
        let textView = UITextView()
        textView.backgroundColor = UIColor(hex: 0xF9F9F9, alpha: 1.0)
        textView.font = UIFont.BalsamTint(.size18)
        textView.tintColor = .primary01
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "내용을 입력해주세요."
        label.font = UIFont.BalsamTint(.size18)
        label.textColor = UIColor(hex: 0x999999, alpha: 1)
        return label
    }()
    
    private var reportButton: UIButton = {
        let button = UIButton()
        button.setTitle("완료", for: .normal)
        button.backgroundColor = .disabled
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.BalsamTint(.size22)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(reportBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    private var characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/100"
        label.font = UIFont.BalsamTint(.size16) // 폰트는 원하는대로 설정하세요
        label.textColor = .gray06
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
        // 다른 코드...
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupExplainLabel()
        setupLetterTextView()
        addDoneButtonOnKeyboard()
        setupReportBtn()
        
        // 다른 영역을 탭했을 때 키보드를 내리는 코드 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        view.endEditing(true)
    }
    
    private func setupExplainLabel(){
        view.addSubview(reportExplainLabel)
        
        NSLayoutConstraint.activate([
            reportExplainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 107),
            reportExplainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        ])
    }
    
    private func setupLetterTextView(){
        view.addSubview(reportTextView)
        
        reportTextView.delegate = self
        
        NSLayoutConstraint.activate([
            reportTextView.topAnchor.constraint(equalTo: reportExplainLabel.bottomAnchor, constant: 14),
            reportTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reportTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reportTextView.heightAnchor.constraint(equalToConstant: 400)
        ])
        
        reportTextView.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            placeholderLabel.topAnchor.constraint(equalTo: reportTextView.topAnchor, constant: 8),
            placeholderLabel.leadingAnchor.constraint(equalTo: reportTextView.leadingAnchor, constant: 6),
            placeholderLabel.trailingAnchor.constraint(equalTo: reportTextView.trailingAnchor)
        ])
        
        view.addSubview(characterCountLabel)
        NSLayoutConstraint.activate([
            characterCountLabel.bottomAnchor.constraint(equalTo: reportTextView.bottomAnchor, constant: -8),
            characterCountLabel.trailingAnchor.constraint(equalTo: reportTextView.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupReportBtn(){
        view.addSubview(reportButton)

        NSLayoutConstraint.activate([
            reportButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -58),
            reportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            reportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            reportButton.heightAnchor.constraint(equalToConstant: 56)
        ])

    }
   
    @objc private func reportBtnTapped() {
        reportLetter()
    }
    
    @objc func doneButtonTapped() {
        reportTextView.resignFirstResponder()
    }
    
    func addDoneButtonOnKeyboard() {
        // 키보드에 'Done' 버튼을 추가합니다.
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .primary01
        toolbar.items = [flexibleSpace, doneButton]

        reportTextView.inputAccessoryView = toolbar

    }
    
    func applyLetterStyling(to textView: UITextView, with response: ReadLetterResponse) {
        
        let responseContent = response.result.content// Response의 content 부분
        let receiveMailboxName = response.result.receiveMailboxName // Response의 receiveMailboxName 부분
        let time = response.result.time// Response의 time 부분 (날짜 형식 변환 필요)
        let sendMailboxName = response.result.sendMailboxName// Response의 sendMailboxName 부분

        let formattedContent = """
        
        to.\(receiveMailboxName)에게

        \(responseContent)

        \(time)
        from, \(sendMailboxName)
        """
        
        let font = UIFont.BalsamTint(.size18)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        paragraphStyle.alignment = .center
        
        let rightAlignParagraphStyle = NSMutableParagraphStyle()
        rightAlignParagraphStyle.alignment = .right
        
        // 현재 텍스트 뷰의 스타일을 가져옴
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textView.textColor ?? .black,
            .paragraphStyle: paragraphStyle
        ]
    
        let attributedString = NSMutableAttributedString(string: formattedContent, attributes: attributes)
                
        let rangeToCheck_ = (formattedContent as NSString).range(of: "\(time)\nfrom, \(sendMailboxName)")
        if rangeToCheck_.location != NSNotFound {
            attributedString.addAttribute(.paragraphStyle, value: rightAlignParagraphStyle, range: rangeToCheck_)
        } else {
            print("The string '\(time)\nfrom, \(sendMailboxName)' was not found in formattedContent.")
        }

        
        let leftAlignParagraphStyle = NSMutableParagraphStyle()
        leftAlignParagraphStyle.alignment = .left

        let rangeToCheck = (formattedContent as NSString).range(of: "to.\(receiveMailboxName)에게")
        if rangeToCheck.location != NSNotFound {
            attributedString.addAttribute(.paragraphStyle, value: leftAlignParagraphStyle, range: rangeToCheck)
        } else {
            print("The string 'to.\(receiveMailboxName)에게' was not found in formattedContent.")
        }
        
        textView.attributedText = attributedString
    }

}

extension ReportLetterViewController{
    
    func reportLetter(){
        
        LetterAPI.providerLetter.request( .reportLetter(letterId: String(self.letterID ), content: reportTextView.text)){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(ReportLetterResponse.self)

                    print(response)

                    if response.isSuccess == true, response.code == 1000 {
                        let vc = ReportLetterCompleteViewController()

                        self.navigationController?.pushViewController(vc, animated: true)
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

extension ReportLetterViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        
        let count = textView.text.count
        characterCountLabel.text = "\(count)/100"
        
        if count > 0 {
            reportButton.isEnabled = true
            reportButton.backgroundColor = .primary01
        } else {
            reportButton.isEnabled = false
            reportButton.backgroundColor = .disabled
        }
        
        // 최대 100자 제한
        if count > 100 {
            let index = textView.text.index(textView.text.startIndex, offsetBy: 100)
            textView.text = String(textView.text.prefix(upTo: index))
            characterCountLabel.text = "100/100"
        }
    }
    
}
