//
//  StarReviewViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/22.
//

import UIKit

class StarReviewViewController: UIViewController {

    // 별 UI 및 밑줄을 포함하는 뷰 배열
    private var starViews: [UIView] = []

    private var starButtons: [UIButton] = []

    private var starScore: String = ""
    
    var letterID: Int = 0

    private let mainExplainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint(.size22)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        // 줄간격 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedString = NSMutableAttributedString(string: "편지의 답장이 마음에 들었다면,\n별점을 남겨줘", attributes: [
                                                    .font: UIFont.BalsamTint(.size22),
                                                    .kern: 0.02, // 글자 간 간격
                                                     .paragraphStyle: paragraphStyle
                                                             ])
        
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let subExplainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint(.size18)
        label.textColor = .icon
        label.textAlignment = .left
        label.numberOfLines = 0
        // 줄간격 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        
        let attributedString = NSMutableAttributedString(string: "별점 점수를 통해,\n답장을 보내준 커플에게 프롬을 줄꺼야.", attributes: [
                                                    .font: UIFont.BalsamTint(.size18),
                                                    .kern: 0.02, // 글자 간 간격
                                                     .paragraphStyle: paragraphStyle
                                                             ])
        
        label.attributedText = attributedString
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private var sendReviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("별점보내기", for: .normal)
        button.backgroundColor = .disabled
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.highlight, for: .highlighted)
        button.titleLabel?.font = UIFont.BalsamTint(.size22)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendReviewBtnTapped), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupStars()
        setupView()
        setupConstraints()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)

    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showBars()
    }
    
    @objc private func sendReviewBtnTapped() {
        
        let vc = ConfirmSendReviewAlertViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.letterID = self.letterID
        vc.starScore = self.starScore
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)

    }
    
    private func setupStars() {
        for _ in 0..<5 {
            let starButton = UIButton()
            starButton.setImage(UIImage(named: "star_empty"), for: .normal)
            starButton.setImage(UIImage(named: "star_fill"), for: .selected)
            starButton.translatesAutoresizingMaskIntoConstraints = false
            starButton.addTarget(self, action: #selector(handleStarTap(_:)), for: .touchUpInside)

            // 20 x 1 크기의 밑줄 뷰 생성
            let underline = UIView()
            underline.backgroundColor = .primary01
            underline.translatesAutoresizingMaskIntoConstraints = false

            let container = UIView()
            container.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(starButton)
            container.addSubview(underline)

            // 별 버튼의 위치 제약 조건 설정
            NSLayoutConstraint.activate([
                starButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                starButton.widthAnchor.constraint(equalToConstant: 32),  // 별 버튼 크기 설정. 원하시는 크기로 조절하세요.
                starButton.heightAnchor.constraint(equalToConstant: 32),

                underline.topAnchor.constraint(equalTo: starButton.bottomAnchor, constant: 4),
                underline.centerXAnchor.constraint(equalTo: starButton.centerXAnchor),
                underline.widthAnchor.constraint(equalToConstant: 20),
                underline.heightAnchor.constraint(equalToConstant: 2)
            ])

            starViews.append(container)
            starButtons.append(starButton)
        }
    }
    
    @objc private func handleStarTap(_ sender: UIButton) {
        // 클릭한 별의 인덱스 찾기
        guard let index = starButtons.firstIndex(of: sender) else { return }
        
        for i in 0...index {
            starButtons[i].setImage(UIImage(named: "star_fill"), for: .normal)
            starButtons[i].isSelected = true
        }

        for i in (index+1)..<starButtons.count {
            starButtons[i].setImage(UIImage(named: "star_empty"), for: .normal)
            starButtons[i].isSelected = false
        }
        
        // 클릭한 별은 별도로 처리
        sender.isSelected = true
        
        sendReviewButton.isEnabled = true
        sendReviewButton.backgroundColor = .primary01
        
        // 선택된 별 개수를 starScore에 설정
        starScore = "\(index + 1)"
    }

    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: view)
        for (index, button) in starButtons.enumerated() {
            if button.convert(button.bounds, to: view).contains(location) {
                for i in 0...index {
                    starButtons[i].setImage(UIImage(named: "star_fill"), for: .normal)
                    starButtons[i].isSelected = true
                }
                for i in (index+1)..<starButtons.count {
                    starButtons[i].setImage(UIImage(named: "star_empty"), for: .normal)
                    starButtons[i].isSelected = false
                }
                
                sendReviewButton.isEnabled = true
                sendReviewButton.backgroundColor = .primary01
                
                // 선택된 별 개수를 starScore에 설정
                starScore = "\(index + 1)"
                
                break
            }
        }
    }

    
    private func setupView() {
        title = "감사인사하기"
        view.backgroundColor = .white
        
        view.addSubview(mainExplainLabel)
        view.addSubview(subExplainLabel)
        
        let stackView = UIStackView(arrangedSubviews: starViews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: subExplainLabel.bottomAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            stackView.heightAnchor.constraint(equalToConstant: 50) // 스택 뷰 높이. 원하시는 크기로 조절하세요.
        ])
        
        view.addSubview(sendReviewButton)
        
        NSLayoutConstraint.activate([
            sendReviewButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -58),
            sendReviewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            sendReviewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            sendReviewButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupConstraints() {
    
        NSLayoutConstraint.activate([
            mainExplainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            mainExplainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            subExplainLabel.topAnchor.constraint(equalTo: mainExplainLabel.bottomAnchor, constant: 20),
            subExplainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func hideBars() {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    private func showBars() {
        self.tabBarController?.tabBar.isHidden = false
    }
}

extension StarReviewViewController: ConfirmSendReviewAlertViewControllerDelegate{
    
    func dismissStarReviewVC() {
        self.navigationController?.popViewController(animated: true)
    }
}
