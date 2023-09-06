//
//  CalendarBottomSheetViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/09/03.
//

import UIKit

class CalendarBottomSheetViewController: UIViewController {
    
    // MARK: - Properties
    // 바텀 시트 높이
    let bottomHeight: CGFloat = 320
    
    var selectedDate: Date?
    var data: [GetCalendarSchedulesResult] = []
    
    // bottomSheet가 view의 상단에서 떨어진 거리
    private var bottomSheetViewTopConstraint: NSLayoutConstraint!
    
    // 기존 화면을 흐려지게 만들기 위한 뷰
    private let dimmedBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        return view
    }()
    
    // 바텀 시트 뷰
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        
        return view
    }()
    
    // dismiss Indicator View UI 구성 부분
    private let dismissIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray2
        view.layer.cornerRadius = 3
        
        return view
    }()

    private let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupGestureRecognizer()
        setupTableView()
        fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showBottomSheet()
    }

    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(dimmedBackView)
        view.addSubview(bottomSheetView)
        view.addSubview(dismissIndicatorView)
        
        dimmedBackView.alpha = 0.0
        setupLayout()
    }
    
    // GestureRecognizer 세팅 작업
    private func setupGestureRecognizer() {
        // 흐린 부분 탭할 때, 바텀시트를 내리는 TapGesture
        let dimmedTap = UITapGestureRecognizer(target: self, action: #selector(dimmedViewTapped(_:)))
        dimmedBackView.addGestureRecognizer(dimmedTap)
        dimmedBackView.isUserInteractionEnabled = true
        
        // 스와이프 했을 때, 바텀시트를 내리는 swipeGesture
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        bottomSheetView.addGestureRecognizer(panGesture)
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        dimmedBackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dimmedBackView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedBackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedBackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedBackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        bottomSheetView.translatesAutoresizingMaskIntoConstraints = false
        let topConstant = view.safeAreaInsets.bottom + view.safeAreaLayoutGuide.layoutFrame.height
        bottomSheetViewTopConstraint = bottomSheetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstant)
        NSLayoutConstraint.activate([
            bottomSheetView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomSheetView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomSheetView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomSheetViewTopConstraint
        ])
        
        dismissIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissIndicatorView.widthAnchor.constraint(equalToConstant: 102),
            dismissIndicatorView.heightAnchor.constraint(equalToConstant: 7),
            dismissIndicatorView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 12),
            dismissIndicatorView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
    }
    
    private func fetchData(){
        if let date = selectedDate {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYYMM"
            let monthString = formatter.string(from: date)
            formatter.dateFormat = "dd"
            let dateString = formatter.string(from: date)
            
            print("monthString:", monthString)
            print("dateString:", dateString)
            getSpecificCalendarSchedules(month: monthString, date: dateString)
        }
    }
    
    // 바텀 시트 표출 애니메이션
    private func showBottomSheet() {
        let safeAreaHeight: CGFloat = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding: CGFloat = view.safeAreaInsets.bottom
        
        bottomSheetViewTopConstraint.constant = (safeAreaHeight + bottomPadding) - bottomHeight
        
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.5
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    // 바텀 시트 사라지는 애니메이션
    private func hideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseIn, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
        }) { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CalendarEventCell.self, forCellReuseIdentifier: "CalendarEventCell")
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: bottomSheetView.topAnchor, constant: 44),
            tableView.bottomAnchor.constraint(equalTo: bottomSheetView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -16)
        ])
    }
    
    
    // MARK: - Actions
    // UITapGestureRecognizer 연결 함수 부분
    @objc private func dimmedViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideBottomSheetAndGoBack()
    }
    
    // UISwipeGestureRecognizer 연결 함수 부분
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        
        if bottomSheetViewTopConstraint.constant + translation.y >= (safeAreaHeight + bottomPadding) - bottomHeight {
            bottomSheetViewTopConstraint.constant += translation.y
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }

        if recognizer.state == .ended {
            let velocity = recognizer.velocity(in: self.view)
            let midPoint = (safeAreaHeight + bottomPadding) - (bottomHeight / 2)
            
            if velocity.y >= 1500 {
                hideBottomSheetAndGoBack()
                return
            }
            
            if bottomSheetViewTopConstraint.constant > midPoint {
                hideBottomSheetAndGoBack()
            } else {
                showBottomSheet()
            }
        }
    }
    
    @objc func handleEditButtonTap() {
        print("Edit button tapped!")
    }

    @objc func handleDeleteButtonTap() {
        print("Delete button tapped!")
    }
}

extension CalendarBottomSheetViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarEventCell", for: indexPath) as! CalendarEventCell
        cell.textLabel?.text = data[indexPath.row].content
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        cell.contentView.clipsToBounds = true
        
        // 버튼 액션 연결 (예시로 print 문 사용)
        cell.editButton.addTarget(self, action: #selector(handleEditButtonTap), for: .touchUpInside)
        cell.deleteButton.addTarget(self, action: #selector(handleDeleteButtonTap), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CalendarBottomSheetViewController{
    
    private func getSpecificCalendarSchedules(month: String, date: String) {
        ScheduleAPI.providerSchedule.request(.getSpecificCalendarSchedules(month: month, date: date)) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(GetCalendarSchedulesResponse.self)
                    self.data = response.result.compactMap { $0 }
                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("DEBUG>> getSpecificCalendarSchedules Error : \(error.localizedDescription)")
            }
        }
    }

}
