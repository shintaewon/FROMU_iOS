//
//  ModalStampExplainViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/30.
//

import UIKit

import UIKit

class ModalStampExplainViewController: UIViewController {
        
    // MARK: - Properties
    var stampNum = 0
    weak var parentVC: BuyStampViewController? // 참조 추가
    
    var contentViewHeightConstraint: NSLayoutConstraint?
    var stampExplainLabelHeightConstraint: NSLayoutConstraint?

    var loadingIndicator: UIActivityIndicatorView!
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy private var stampImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stamp\(stampNum)_small")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    lazy private var stampExplainLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .BalsamTint(.size22)
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("돌아가기", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(UIColor.primary01, for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.titleLabel?.font = UIFont.BalsamTint(.size18)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.primary01.cgColor
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let buyButton: UIButton = {
        let button = UIButton()
        button.setTitle("구매하기", for: .normal)
        button.backgroundColor = .primary01
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.titleLabel?.font = UIFont.BalsamTint(.size18)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let fromImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Property 28")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    private let fromCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint(.size22)
        label.text = "3 프롬"
        label.textColor = .primary01
        
        // NSAttributedString 적용 부분
        if let currentText = label.text {
            let attributedString = NSMutableAttributedString(string: currentText)
            attributedString.addAttribute(.baselineOffset, value: 3, range: NSRange(location: 0, length: attributedString.length))
            label.attributedText = attributedString
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var fromStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [fromImageView, fromCountLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        self.view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
        
    }
    
    func setupConstraints() {
        // AutoLayout 또는 다른 방식의 레이아웃 설정
        setupContentView()
        setupStampImageView()
        setupStampExplainLabel()
        setupStackViewWithFromComponents()
        setupBackButton()
        setupBuyButton()
        setupLoadingIndicator()
        
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buyStampButtonTapped), for: .touchUpInside)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
    
    }
    
    // MARK: - Data Handling
    func fetchData() {
        // 네트워크 요청 또는 초기 데이터 로딩
        setTextForStampNumber(stampNum: stampNum)
    }
    
    // MARK: - Actions
    @objc func buyStampButtonTapped() {
        buyStamp()
    }
    
    @objc private func backgroundTapped(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: self.view)
        if !contentView.frame.contains(location) {
            self.dismiss(animated: true, completion: nil)
        }
    }

    
    @objc func closePopup() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Functions
    private func setupContentView(){
        
        self.view.addSubview(contentView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
        contentView.isUserInteractionEnabled = true
        contentViewHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 156)

        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -28),
            contentViewHeightConstraint!
        ])
    }
    
    private func setupStampImageView(){
    
        contentView.addSubview(stampImageView)
        
        NSLayoutConstraint.activate([
            stampImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stampImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stampImageView.heightAnchor.constraint(equalToConstant: 90),
            stampImageView.widthAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func setupStampExplainLabel(){
    
        contentView.addSubview(stampExplainLabel)
        
        NSLayoutConstraint.activate([
            stampExplainLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stampExplainLabel.topAnchor.constraint(equalTo: stampImageView.bottomAnchor, constant: 16),
            stampExplainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            stampExplainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }
    
    private func setupBackButton(){
    
        contentView.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: fromStackView.bottomAnchor, constant: 16),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            backButton.widthAnchor.constraint(equalToConstant: 132),
            backButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupBuyButton(){
    
        contentView.addSubview(buyButton)
        
        NSLayoutConstraint.activate([
            buyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            buyButton.topAnchor.constraint(equalTo: fromStackView.bottomAnchor, constant: 16),
            buyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            buyButton.widthAnchor.constraint(equalToConstant: 132),
            buyButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupStackViewWithFromComponents() {
        
        contentView.addSubview(fromStackView)

        NSLayoutConstraint.activate([
            fromStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            fromStackView.topAnchor.constraint(equalTo: stampExplainLabel.bottomAnchor, constant: 16),  // 16은 간격이므로 필요에 따라 조정하세요.
            fromStackView.heightAnchor.constraint(equalToConstant: 27)
        ])
    }
    
    private func setTextForStampNumber(stampNum: Int) {
        var text: String
        switch stampNum {
        case 1:
            text = """
            프롬유의 대표적인 우표야.
            엄청난 호기심이 생기지 않니?
            """
        case 2:
            text = """
            신비함을 상징하는 우표야.
            몽환적인 보라색 편지지와 함께
            우리의 이야기를 전달해볼까?
            """
        case 3:
            text = """
            당당함을 상징하는 우표야.
            장난끼 가득한 알록달록한
            편지지와 함께
            우리의 이야기를 적어보자!
            """
        case 4:
            text = """
            부드러움을 상징하는 우표야.
            귀여운 분홍색의 편지지와 함께
            우리의 이야기를 전달해볼까?
            """
        case 5:
            text = """
            희망과 자유를 상징하는 우표야.
            청량감 가득한 푸른 색의
            편지지와 함께
            우리의 이야기를 적어볼까?
            """
        case 6:
            text = """
            명량함과 활기를 상징하는 우표야.
            햇살 같은 편지지와 함께
            우리의 이야기를 써 내려가볼까?
            엄청난 호기심이 생기지 않니?
            """
        default:
            text = ""
        }
        
        // 여기에서 lineSpacing 및 폰트 설정을 추가합니다.
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        stampExplainLabel.attributedText = attributedString
        stampExplainLabel.textAlignment = .center
        stampExplainLabel.numberOfLines = 0
        stampExplainLabel.font = .BalsamTint(.size22)
        
        let padding: CGFloat = 24 + 24 + 90 + 30 + 48 + 12 + 59 // stampImageView, backButton, buyButton 및 각각의 padding 합산
        let textHeight = stampExplainLabel.sizeThatFits(CGSize(width: contentView.frame.width - 48, height: CGFloat.infinity)).height
        let totalHeight = padding + textHeight

        contentViewHeightConstraint?.constant = totalHeight
        self.view.layoutIfNeeded() // 필요하면 뷰 갱신
    }

    func setupLoadingIndicator() {
        guard let window = UIApplication.shared.keyWindow else { return }

        loadingIndicator = UIActivityIndicatorView(style: .large)
        loadingIndicator.center = window.center
        loadingIndicator.hidesWhenStopped = true
        window.addSubview(loadingIndicator)
    }

    func startLoadingIndicator() {
        loadingIndicator.startAnimating()
        UIApplication.shared.keyWindow?.bringSubviewToFront(loadingIndicator)
    }

    func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
}

extension ModalStampExplainViewController{
    
    func buyStamp(){

        // 로딩 인디케이터 시작
        startLoadingIndicator()
        
        CoupleAPI.providerCouple.request( .buyStamp(stampNum: String(stampNum))){ result in
            
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(BuyStampResponse.self)

                    print(response)

                    if response.isSuccess == true{
                        //구매 성공
                        if response.code == 1000{
                            self.dismiss(animated: true) { [weak self] in
                                self?.stopLoadingIndicator()
                                // 프롬 갯수 새로고침
                                self?.parentVC?.getFromCount()
                                self?.showToast(message: "오예! 성공적으로 구매했어!")
                            }
                        }
                    }
                    else{
                        //프롬 부족
                        if response.code == 3061{
                            self.dismiss(animated: true) { [weak self] in
                                self?.stopLoadingIndicator()
                                self?.showToast(message: "헉...프롬이 부족해...")
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
    
    func showToast(message: String) {
        guard let window = UIApplication.shared.keyWindow else { return }

        // 흐린 배경 뷰 추가
        let backgroundView = UIView(frame: window.bounds)
        backgroundView.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)

        window.addSubview(backgroundView)
        window.bringSubviewToFront(backgroundView)

        let toastLabel = UILabel(frame: CGRect(x: (window.frame.width - 320) / 2, y: (window.frame.height - 152) / 2, width: 320, height: 152))
        toastLabel.backgroundColor = .white
        toastLabel.textColor = UIColor.black
        toastLabel.font = UIFont.BalsamTint(.size22)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.layer.cornerRadius = 20
        toastLabel.alpha = 1.0
        toastLabel.clipsToBounds = true

        window.addSubview(toastLabel)
        window.bringSubviewToFront(toastLabel)

        UIView.animate(withDuration: 3.0, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
            backgroundView.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
            backgroundView.removeFromSuperview()
        }
    }


}
