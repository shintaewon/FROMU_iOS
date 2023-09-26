//
//  ConventionTemplateViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/08/30.
//

import UIKit

class ConventionTemplateViewController: UIViewController {

    // MARK: - Properties
    
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
        view.backgroundColor = .white
    }
    
    func setupConstraints() {
        // AutoLayout 또는 다른 방식의 레이아웃 설정
    }
    
    func setupActions() {
        // UI 컴포넌트에 대한 액션 설정
        // 예) button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    func setupNavigation() {
        // Navigation 관련 설정
        // 예) navigationItem.title, barButtonItems 등
    }
    
    // MARK: - Data Handling
    func fetchData() {
        // 네트워크 요청 또는 초기 데이터 로딩
    }
    
    // MARK: - Actions
    @objc func buttonTapped() {
        // 버튼 클릭 시 동작 정의b
    }
    
    // MARK: - Helpers
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    // MARK: - Functions

}
