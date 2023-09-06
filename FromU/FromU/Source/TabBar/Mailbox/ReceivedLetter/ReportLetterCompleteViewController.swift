//
//  ReportLetterCompleteViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/22.
//

import UIKit

class ReportLetterCompleteViewController: UIViewController {

    private let explainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint(.size22)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 0
        // 줄간격 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 30 - UIFont.BalsamTint(.size22).lineHeight
        
        let attributedString = NSMutableAttributedString(string: "신고가 접수되었습니다.\n확인 후 조치하도록 하겠습니다.",
                                                             attributes: [
                                                                .font: UIFont.BalsamTint(.size22),
                                                                .kern: 0.02, // 글자 간 간격
                                                                .paragraphStyle: paragraphStyle
                                                             ])
        
        label.attributedText = attributedString
        
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()
    
    private let reportCompletedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "report_complete")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideBars()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showBars()
    }
    
    private func setupView() {
        view.setGradient(color1: UIColor(red: 0.396, green: 0.667, blue: 1, alpha: 1), color2: UIColor(red: 0.786, green: 0.514, blue: 1, alpha: 1))
        
        view.addSubview(explainLabel)
        view.addSubview(reportCompletedImageView)
    }
    
    private func setupConstraints() {
    
        NSLayoutConstraint.activate([
            explainLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 138),
            explainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            reportCompletedImageView.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 118),
            reportCompletedImageView.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            reportCompletedImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    
    private func hideBars() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            
            // 현재 뷰 컨트롤러 스택에서 받은 MailboxLetterViewController를 찾아 돌아가기
            if let viewControllers = self?.navigationController?.viewControllers {
                for controller in viewControllers {
                    if controller is MailboxLetterViewController {
                        self?.navigationController?.popToViewController(controller, animated: false)
                        break
                    }
                }
            }
        }
    }
    
    private func showBars() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
}
