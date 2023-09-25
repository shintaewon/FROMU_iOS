//
//  ConfirmReplyLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/29.
//

import UIKit

protocol ConfirmReplyLetterViewControllerDelegate: AnyObject{
    func goToWritingReplyLetterViewController()
}

class ConfirmReplyLetterViewController: UIViewController {
    
    var starScore: String = ""
    
    var letterID: Int = 0
    
    weak var delegate: ConfirmReplyLetterViewControllerDelegate?
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
            
        let label = UILabel()
        label.font = .BalsamTint(.size22)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6.0
        paragraphStyle.alignment = .center
        
        let attributedString = NSMutableAttributedString(string: """
편지의 답장은 한 번만 가능해서,
내가 쓰면 상대방은 쓰지 못해
""", attributes: [
                            .font: UIFont.BalsamTint(.size22),
                            .paragraphStyle: paragraphStyle
                        ])

        label.attributedText = attributedString

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
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("답장하기", for: .normal)
        button.backgroundColor = .primary01
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.titleLabel?.font = UIFont.BalsamTint(.size18)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        // 배경색 설정
        self.view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.4)
        
        self.view.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(backButton)
        contentView.addSubview(sendButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        
        self.view.addGestureRecognizer(tapGesture)
        
        tapGesture.cancelsTouchesInView = false
        
        contentView.isUserInteractionEnabled = true
        
        // 제약조건 설정
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 28),
            contentView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -28),
            contentView.heightAnchor.constraint(equalToConstant: 186),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            backButton.widthAnchor.constraint(equalToConstant: 132),
            backButton.heightAnchor.constraint(equalToConstant: 48),
            
            sendButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            sendButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            sendButton.widthAnchor.constraint(equalToConstant: 132),
            sendButton.heightAnchor.constraint(equalToConstant: 48),
        ])
        
        backButton.addTarget(self, action: #selector(closePopup), for: .touchUpInside)
        sendButton.addTarget(self, action: #selector(sendReply), for: .touchUpInside)
    }
    
    @objc private func backgroundTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closePopup() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendReply() {
        self.dismiss(animated: true) {
            self.delegate?.goToWritingReplyLetterViewController()
        }
    }
    
}
