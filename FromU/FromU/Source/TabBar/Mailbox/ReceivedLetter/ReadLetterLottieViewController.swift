//
//  ReadLetterLottieViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/11.
//

import UIKit
import Lottie

class ReadLetterLottieViewController: UIViewController {

    // 현재 내가 읽고 있는 편지의 정보를 담고 있는 변수
    var selectedLetter: GetLetterListResult?
    
    private lazy var lottieView: LottieAnimationView = {
        let animation = LottieAnimationView(name: "comingletter")
        animation.contentMode = .scaleToFill
        animation.loopMode = .loop
        animation.play()
        return animation
    }()
    
    private lazy var explainLabel: UILabel = {
        let label = UILabel()
        label.text = getTextForExplainLabel()
        label.font = UIFont.BalsamTint(.size20)
        label.textColor = .black
        label.textAlignment = .center
        return label
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
        view.addSubview(lottieView)
        view.addSubview(explainLabel)
    }

    private func setupConstraints() {
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        explainLabel.translatesAutoresizingMaskIntoConstraints = false

        let topPadding: CGFloat = 162
        let animationSize: CGFloat = 343
        let distanceBetweenViews: CGFloat = 24

        NSLayoutConstraint.activate([
            lottieView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lottieView.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding),
            lottieView.widthAnchor.constraint(equalToConstant: animationSize),
            lottieView.heightAnchor.constraint(equalToConstant: animationSize),
            
            explainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            explainLabel.topAnchor.constraint(equalTo: lottieView.bottomAnchor, constant: distanceBetweenViews)
        ])
    }
    
    private func hideBars() {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            
            //그냥 일반(랜덤) 받은편지일 경우
            if self?.selectedLetter?.status == 0 {
                let vc = ReadRandomLetterViewController()
                var viewControllers = self?.navigationController?.viewControllers
                viewControllers?.removeLast()
                viewControllers?.append(vc)
                
                vc.selectedLetter = self?.selectedLetter
                
                self?.navigationController?.setViewControllers(viewControllers!, animated: true)
            }
            
            //답장편지일 경우
            else if self?.selectedLetter?.status == 2 {
                let vc = ReadReplyLetterViewController()
                var viewControllers = self?.navigationController?.viewControllers
                viewControllers?.removeLast()
                viewControllers?.append(vc)
                
                vc.selectedLetter = self?.selectedLetter
                
                self?.navigationController?.setViewControllers(viewControllers!, animated: true)
            }
        }
    }
    
    private func showBars() {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }

    private func getTextForExplainLabel() -> String {
        if let mailboxName = selectedLetter?.mailboxName {
            return "\(mailboxName)에서 편지가 도착했어!"
        } else {
            return "프롬유 개발팀으로부터 편지가 도착했어!" // 디폴트 메세지
        }
    }
}

