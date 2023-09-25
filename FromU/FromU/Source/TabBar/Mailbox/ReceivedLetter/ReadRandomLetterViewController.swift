//
//  ReadRandomLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/16.
//

import UIKit

class ReadRandomLetterViewController: UIViewController, UITextViewDelegate {
    
    //현재 내가 읽고있는 편지의 정보를 담고 있는 변수
    var selectedLetter: GetLetterListResult?
    
    var bgLetterNum = 0
    
    private var letterTextView: UITextView = {
        
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont.BalsamTint(.size18)
        textView.textAlignment = .center
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        return textView
    }()
    
    private lazy var threeDotButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(UIImage(named: "three_dot"), for: .normal)
        button.addTarget(self, action: #selector(threeDotButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var reportButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 48))
        button.setTitle("신고하기", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor( .black, for: .normal)
        button.titleLabel?.font = UIFont.BalsamTint(.size16)
        button.layer.cornerRadius = 4
        button.isHidden = true // 기본적으로 숨김 처리
        button.addTarget(self, action: #selector(reportButtonTapped), for: .touchUpInside)
        
        // 그림자 설정
        button.layer.shadowColor = UIColor.black.withAlphaComponent(0.16).cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 6)
        button.layer.shadowOpacity = 1
        button.layer.shadowRadius = 4
        button.layer.masksToBounds = false
        
        
        return button
    }()
    
    lazy private var letterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy private var stampImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    func applyLineSpacing(to textView: UITextView, lineHeight: CGFloat) {
        let text = textView.text ?? ""
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineHeight
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        
        textView.attributedText = attributedString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        setupTapGestureForLetterTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reportButton.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        readLetter()
        // 다른 코드...
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        setupLetterImageView()
        setupStampImageView()
        setupLetterTextView()
        setupReportButton()
    }
    
    private func setupReportButton() {
        view.addSubview(reportButton)
        reportButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            reportButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            reportButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            reportButton.widthAnchor.constraint(equalToConstant: 90),
            reportButton.heightAnchor.constraint(equalToConstant: 48)
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
    
    private func setupStampImageView(){
        
        letterImageView.addSubview(stampImageView)
        
        NSLayoutConstraint.activate([
            stampImageView.topAnchor.constraint(equalTo: letterImageView.topAnchor, constant: 28),
            stampImageView.trailingAnchor.constraint(equalTo: letterImageView.trailingAnchor, constant: -22),
            stampImageView.heightAnchor.constraint(equalToConstant: 58),
            stampImageView.widthAnchor.constraint(equalToConstant: 58)
        ])
        
    }
    
    private func setupLetterTextView(){
        
        letterTextView.delegate = self
        
        view.addSubview(letterTextView)
        
        NSLayoutConstraint.activate([
            letterTextView.topAnchor.constraint(equalTo: letterImageView.topAnchor, constant: 10),
            letterTextView.leadingAnchor.constraint(equalTo: letterImageView.leadingAnchor, constant: 21),
            letterTextView.trailingAnchor.constraint(equalTo: letterImageView.trailingAnchor, constant: -21),
            letterTextView.bottomAnchor.constraint(equalTo: letterImageView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupReplyButton(){
        
        let customButton = UIButton(type: .system)
        customButton.setTitle("답장하기", for: .normal)
        customButton.titleLabel?.font = UIFont.BalsamTint(.size18)
        customButton.setTitleColor(UIColor.primary01, for: .normal)
        customButton.addTarget(self, action: #selector(replyButtonTapped), for: .touchUpInside)
        
        let replyButton = UIBarButtonItem(customView: customButton)
        let threeDotBarButtonItem = UIBarButtonItem(customView: threeDotButton)
        
        let buttons = [threeDotBarButtonItem, replyButton]
        navigationItem.rightBarButtonItems = buttons    }
    
    private func setupAlreadyReplyButton(){
        
        let customButton = UIButton(type: .system)
        customButton.setTitle("이미 답장을 보냈어!", for: .normal)
        customButton.titleLabel?.font = UIFont.BalsamTint(.size18)
        customButton.setTitleColor(UIColor.disabledText, for: .normal)
        
        let alreadyReplyButton = UIBarButtonItem(customView: customButton)
        alreadyReplyButton.isEnabled = false
        
        let threeDotBarButtonItem = UIBarButtonItem(customView: threeDotButton)
        
        let buttons = [threeDotBarButtonItem, alreadyReplyButton]
        navigationItem.rightBarButtonItems = buttons
    }
    
    @objc func replyButtonTapped() {
        
        let vc = ConfirmReplyLetterViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    private func setupTapGestureForLetterTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(letterTextViewTapped))
        letterTextView.addGestureRecognizer(tapGesture)
    }
    
    private func toggleReportButton() {
        UIView.animate(withDuration: 0.3) {
            self.reportButton.isHidden.toggle()
        }
    }
    
    @objc private func threeDotButtonTapped() {
        toggleReportButton()
    }
    
    @objc private func letterTextViewTapped() {
        if !reportButton.isHidden {
            toggleReportButton()
        }
    }
    
    @objc private func reportButtonTapped() {
        
        let vc = ReportLetterViewController()
        
        vc.letterID = selectedLetter?.letterID ?? 0
        // ReadLetterViewController로 전환 (푸시 또는 모달)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func applyLetterStyling(to textView: UITextView, with response: ReadLetterResponse) {
        
        let responseContent = response.result.content// Response의 content 부분
        let receiveMailboxName = response.result.receiveMailboxName // Response의 receiveMailboxName 부분
        let time = response.result.time// Response의 time 부분 (날짜 형식 변환 필요)
        let timeConverted = convertDate(from: time) ?? time
        let sendMailboxName = response.result.sendMailboxName// Response의 sendMailboxName 부분
        
        let formattedContent = """
        
        to.\(receiveMailboxName)에게
        
        \(responseContent)
        
        \(timeConverted)
        from, \(sendMailboxName)
        """
        
        let font = UIFont.BalsamTint(.size18)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        paragraphStyle.alignment = .center
        
        let rightAlignParagraphStyle = NSMutableParagraphStyle()
        rightAlignParagraphStyle.lineSpacing = 6.0
        rightAlignParagraphStyle.alignment = .right
        
        // 현재 텍스트 뷰의 스타일을 가져옴
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textView.textColor ?? .black,
            .paragraphStyle: paragraphStyle
        ]
        
        let attributedString = NSMutableAttributedString(string: formattedContent, attributes: attributes)
        
        let rangeToCheck_ = (formattedContent as NSString).range(of: "\(timeConverted)\nfrom, \(sendMailboxName)")
        if rangeToCheck_.location != NSNotFound {
            attributedString.addAttribute(.paragraphStyle, value: rightAlignParagraphStyle, range: rangeToCheck_)
        } else {
            print("The string '\(time)\nfrom, \(sendMailboxName)' was not found in formattedContent.")
        }
        
        
        let leftAlignParagraphStyle = NSMutableParagraphStyle()
        leftAlignParagraphStyle.lineSpacing = 6.0
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


extension ReadRandomLetterViewController{
    
    func readLetter(){
        
        LetterAPI.providerLetter.request( .readLetter(letterId: String(selectedLetter?.letterID ?? 0))){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(ReadLetterResponse.self)
                    
                    print(response)
                    
                    if response.isSuccess == true, response.code == 1000 {
                        DispatchQueue.main.async { // UI 업데이트는 메인 스레드에서 수행해야 합니다.
                            self.applyLetterStyling(to: self.letterTextView, with: response)
                            
                            self.bgLetterNum = response.result.stamp
                            
                            self.stampImageView.image = UIImage(named: "stamp\(self.bgLetterNum)_small")
                            
                            self.letterImageView.image = UIImage(named: "letter\(self.bgLetterNum)")
                            
                            //답장을 이미 했을경우
                            if response.result.replyFalg == true {
                                self.setupAlreadyReplyButton()
                            } else{ // 답장을 아직 안했을 경우
                                self.setupReplyButton()
                            }
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

extension ReadRandomLetterViewController: ConfirmReplyLetterViewControllerDelegate{
    
    func goToWritingReplyLetterViewController() {
        let vc = WritingReplyLetterViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
