//
//  ReadReplyLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/11.
//

import UIKit

class ReadReplyLetterViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    var selectedLetter: GetLetterListResult?
    var imageView: UIImageView!
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 네비게이션바 아래부터 화면 하단까지의 CGRect를 계산합니다.
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let imageViewFrame = CGRect(x: 0, y: statusBarHeight + navigationBarHeight, width: view.frame.width, height: view.frame.height - (statusBarHeight + navigationBarHeight))
        imageView.frame = imageViewFrame
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        setupImageView()
        setupLetterTextView()
        setupReportButton()
    }
    
    private func setupImageView(){
 
        // UIImageView의 초기화는 여기서 해주되, 실제 프레임 설정은 viewDidLayoutSubviews에서 해줍니다.
        imageView = UIImageView()  // 프레임을 나중에 설정하므로 초기화만 합니다.
        imageView.image = UIImage(named: "diaryBGImage")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        view.addSubview(imageView)
    }
    
    private func setupLetterTextView(){
        
        letterTextView.delegate = self
        
        view.addSubview(letterTextView)
        
        NSLayoutConstraint.activate([
            letterTextView.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 0),
            letterTextView.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 9),
            letterTextView.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -9),
            letterTextView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0)
        ])
    }
    
    private func setupThanksButton(){
        
        let customButton = UIButton(type: .system)
        customButton.setTitle("감사인사하기", for: .normal)
        customButton.titleLabel?.font = UIFont.BalsamTint(.size18)
        customButton.setTitleColor(UIColor.primary01, for: .normal)
        customButton.addTarget(self, action: #selector(thankYouButtonTapped), for: .touchUpInside)
        
        let thankYouButton = UIBarButtonItem(customView: customButton)
        let threeDotBarButtonItem = UIBarButtonItem(customView: threeDotButton)
        
        let buttons = [threeDotBarButtonItem, thankYouButton]
        navigationItem.rightBarButtonItems = buttons
        
    }
    
    private func setupAlreadyThanksButton(){
        
        let customButton = UIButton(type: .system)
        customButton.setTitle("감사인사 완료", for: .normal)
        customButton.titleLabel?.font = UIFont.BalsamTint(.size18)
        customButton.setTitleColor(UIColor.disabledText, for: .normal)
        
        let alreadyThankYouButton = UIBarButtonItem(customView: customButton)
        alreadyThankYouButton.isEnabled = false
        
        let threeDotBarButtonItem = UIBarButtonItem(customView: threeDotButton)
        
        let buttons = [threeDotBarButtonItem, alreadyThankYouButton]
        navigationItem.rightBarButtonItems = buttons
    }
    
    private func toggleReportButton() {
        UIView.animate(withDuration: 0.3) {
            self.reportButton.isHidden.toggle()
        }
    }
    
    @objc private func threeDotButtonTapped() {
        toggleReportButton()
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
    
    @objc func thankYouButtonTapped() {
        
        let vc = StarReviewViewController()
        
        vc.letterID = selectedLetter?.letterID ?? 0
        
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    private func setupTapGestureForLetterTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(letterTextViewTapped))
        letterTextView.addGestureRecognizer(tapGesture)
    }

    @objc private func letterTextViewTapped() {
        if !reportButton.isHidden {
            toggleReportButton()
        }
    }
    
}


extension ReadReplyLetterViewController{
    
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
                            
                            if response.result.scoreFlag == true {
                                self.setupAlreadyThanksButton()
                            } else{
                                self.setupThanksButton()
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

