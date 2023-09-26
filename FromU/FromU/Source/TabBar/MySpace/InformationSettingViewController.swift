//
//  InformationSettingViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/09/25.
//

import UIKit

import SwiftKeychainWrapper

class InformationSettingViewController: UIViewController {

    // MARK: - Properties
    private let myNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint( .size22)
        label.textColor = .black
        label.textAlignment = .center

        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let myBirthDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint( .size22)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let heartImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icn_heart.png"))
        imageView.contentMode = .scaleAspectFill
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let partnerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint( .size22)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let partnerBirthDayLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.BalsamTint( .size22)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var myUserId: String?
    private var partnerUserId: String?
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIComponents()
        setupConstraints()
        setupActions()
        setupNavigation()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK: - UI Setup
    func setupUIComponents() {
        // 기본적인 view 설정
        // 예) backgroundColor, addSubView 등
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        // AutoLayout 또는 다른 방식의 레이아웃 설정
        setupMyNameLabel()
        setupMyBirthDayLabel()
        setupHeartImageView()
        setupPartnerNameLabel()
        setupPartnerBirthDayLabel()
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let nameTapGesture = UITapGestureRecognizer(target: self, action: #selector(nameLabelTapped))
        myNameLabel.isUserInteractionEnabled = true
        myNameLabel.addGestureRecognizer(nameTapGesture)
        
        let birthDayTapGesture = UITapGestureRecognizer(target: self, action: #selector(birthDayLabelTapped))
        myBirthDayLabel.isUserInteractionEnabled = true
        myBirthDayLabel.addGestureRecognizer(birthDayTapGesture)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
        title = "정보 설정"
        
        if let customFont = UIFont(name: "777Balsamtint", size: 18) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
        }
    }
    
    // MARK: - Data Handling
    func fetchData() {
        // 네트워크 요청 또는 초기 데이터 로딩
        getUserInfoWithCouplID()
    }
    
    // MARK: - Actions
    @objc func nameLabelTapped() {
        let vc = EditMyNameViewController() // 인스턴스 생성. 초기화 메서드에 따라 변경 가능.
        vc.name = myNameLabel.text ?? "None"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @objc func birthDayLabelTapped() {
        let vc = EditMyBirthDayViewController() // 인스턴스 생성. 초기화 메서드에 따라 변경 가능.
        vc.birthday = myBirthDayLabel.text ?? "0000. 00. 00"
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Helpers
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // MARK: - Functions
    private func setupMyNameLabel() {
        view.addSubview(myNameLabel)
        
        NSLayoutConstraint.activate([
            myNameLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            myNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupMyBirthDayLabel() {
        view.addSubview(myBirthDayLabel)
        
        NSLayoutConstraint.activate([
            myBirthDayLabel.topAnchor.constraint(equalTo: self.myNameLabel.bottomAnchor, constant: 3),
            myBirthDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupHeartImageView() {
        view.addSubview(heartImageView)
        
        NSLayoutConstraint.activate([
            heartImageView.topAnchor.constraint(equalTo: self.myBirthDayLabel.bottomAnchor, constant: 12),
            heartImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            heartImageView.heightAnchor.constraint(equalToConstant: 54),
            heartImageView.widthAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private func setupPartnerNameLabel() {
        view.addSubview(partnerNameLabel)
        
        NSLayoutConstraint.activate([
            partnerNameLabel.topAnchor.constraint(equalTo: heartImageView.bottomAnchor, constant: 31),
            partnerNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func setupPartnerBirthDayLabel() {
        view.addSubview(partnerBirthDayLabel)
        
        NSLayoutConstraint.activate([
            partnerBirthDayLabel.topAnchor.constraint(equalTo: self.partnerNameLabel.bottomAnchor, constant: 3),
            partnerBirthDayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    func getUserInfoWithCouplID(){
        showIndicator()
        CoupleAPI.providerCouple.request( .getUserInfo(coupleId: String(KeychainWrapper.standard.integer(forKey: "coupleID") ?? 0))){ [weak self] result in
            guard let self = self else { return }
                
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(UserIdWithCoupleIdResponse.self)

                    // 첫 번째 userId를 myUserId로 저장
                    self.myUserId = String(response.result?.userId1 ?? 0)
                    self.getUserInfoWithUserID(userId: self.myUserId ?? "")
                    
                    // 두 번째 userId를 partnerUserId로 저장
                    self.partnerUserId = String(response.result?.userId2 ?? 0)
                    self.getUserInfoWithUserID(userId: self.partnerUserId ?? "")

                } catch {
                    print(error)
                }

            case .failure(let error):
                print("DEBUG>> getUserInfoWithCouplID Error : \(error.localizedDescription)")
            }
        }
    }

    func getUserInfoWithUserID(userId: String){
        UserAPI.providerUser.request( .getUserInfo(userId: userId)){ [weak self] result in
            guard let self = self else { return }
                
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(UserInfoResponse.self)
                    // 날짜 포맷 변환
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"
                    if let date = dateFormatter.date(from: response.result?.birthday ?? "") {
                        dateFormatter.dateFormat = "yyyy. MM. dd"
                        let formattedDate = dateFormatter.string(from: date)

                        // userId를 비교하여 현재 사용자와 파트너 구분
                        // 메인 스레드에서 UI 업데이트
                        DispatchQueue.main.async {
                            // userId를 비교하여 현재 사용자와 파트너 구분
                            if userId == self.myUserId {
                                self.myNameLabel.text = response.result?.nickname ?? "Unknown"
                                self.myBirthDayLabel.text = formattedDate
                                
                                self.myNameLabel.sizeToFit()
                                self.myBirthDayLabel.sizeToFit()
                                
                                let bottomBorderForNameLabel = CALayer()
                                bottomBorderForNameLabel.backgroundColor = UIColor.primaryLight.cgColor
                                bottomBorderForNameLabel.frame = CGRect(x: 0, y: self.myNameLabel.frame.size.height + 1, width: self.myNameLabel.frame.width + 3, height: 1)
                                self.myNameLabel.layer.addSublayer(bottomBorderForNameLabel)
                                
                                let bottomBorderForBirthDayLabel = CALayer()
                                bottomBorderForBirthDayLabel.backgroundColor = UIColor.primaryLight.cgColor
                                bottomBorderForBirthDayLabel.frame = CGRect(x: 0, y: self.myBirthDayLabel.frame.size.height + 1, width: self.myBirthDayLabel.frame.width + 3, height: 1)
                                self.myBirthDayLabel.layer.addSublayer(bottomBorderForBirthDayLabel)
                            } else if userId == self.partnerUserId {
                                self.partnerNameLabel.text = response.result?.nickname ?? "Unknown"
                                self.heartImageView.isHidden = false
                                self.partnerBirthDayLabel.text = formattedDate
                            }
                        }
                    }
                        
                } catch {
                    print(error)
                }

            case .failure(let error):
                print("DEBUG>> getUserInfoWithUserID Error : \(error.localizedDescription)")
            }
        }
        
        dismissIndicator()
    }
}

extension InformationSettingViewController: EditMyNameViewControllerDelegate, EditMyBirthDayViewControllerDelegate {
    func didUpdateUserBirthday() {
        DispatchQueue.main.async {
            self.getUserInfoWithUserID(userId: self.myUserId ?? "")
        }
    }
    
    
    func didUpdateUserName() {
        DispatchQueue.main.async {
            self.getUserInfoWithUserID(userId: self.myUserId ?? "")
        }
    }
}

