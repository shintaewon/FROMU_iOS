//
//  CalendarViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    // MARK: - Properties
    @IBOutlet weak var calendarView: FSCalendar!
    @IBOutlet weak var shadowView: UIView!
    
    private var calendarEventDates = [Date]()
    
    let fromCountLabel = UILabel()

    lazy private var plusPlanButtonContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.layer.shadowColor = UIColor.black.cgColor
        container.layer.shadowOffset = CGSize(width: 0, height: 4)
        container.layer.shadowOpacity = 0.31 // 0x1F / 0xFF
        container.layer.shadowRadius = 4
        
        container.addSubview(plusPlanButton)
        NSLayoutConstraint.activate([
            plusPlanButton.topAnchor.constraint(equalTo: container.topAnchor),
            plusPlanButton.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            plusPlanButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            plusPlanButton.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }()

    private var plusPlanButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "plus_icon"), for: .normal)
        button.backgroundColor = .primary01
        button.layer.cornerRadius = 28
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(plusPlanButtonTapped), for: .touchUpInside)
        return button
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - UI Setup
    private func setupUIComponents() {
        setupShadowView()
        setupCalendarView()
        setplusPlanButton()
    }
    
    private func setupShadowView() {
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 12
        shadowView.layer.shadowOpacity = 1
    }
    
    private func setupCalendarView() {
        calendarView.appearance.headerTitleFont = UIFont.BalsamTint(.size22)
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.headerDateFormat = "MMMM YYYY"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        calendarView.appearance.titleFont = UIFont.BalsamTint(.size22)
        calendarView.appearance.weekdayTextColor = .black
        calendarView.placeholderType = .none
        calendarView.appearance.selectionColor = .primary02
        calendarView.appearance.todayColor = .primary01
        calendarView.appearance.todaySelectionColor = .none
        
        calendarView.appearance.caseOptions = FSCalendarCaseOptions.weekdayUsesUpperCase
        
        calendarView.appearance.eventDefaultColor = UIColor.primaryLight
        calendarView.appearance.eventSelectionColor = UIColor.primaryLight
        
    }

    private func setupConstraints() {
        // Place AutoLayout or other layout logic here
    }

    private func setupActions() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
    }
    
    private func setupNavigation() {
        configureNavigationItems()
    }

    // MARK: - Data Handling
    private func fetchData() {
        configureNavigationItems()
        getFromCount()
        
        // 오늘 날짜 가져오기
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMM"
        let monthString = formatter.string(from: today)
        
        // 원하는 형식의 문자열로 변환된 month를 사용하여 getSpecificCalendarSchedules 메서드 호출
        getSpecificCalendarSchedules(month: monthString, date: "")
    }

    // MARK: - Actions
    @objc private func plusPlanButtonTapped() {
        let bottomSheetVC = CalendarBottomSheetViewController()
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }

    // MARK: - Helpers
    private func configureNavigationItems() {
        fromCountLabel.backgroundColor = .primaryLight
        fromCountLabel.layer.cornerRadius = 10
        fromCountLabel.clipsToBounds = true
        fromCountLabel.font = UIFont.BalsamTint(.size16)
        fromCountLabel.text = "    "
        fromCountLabel.textColor = .primary02
        fromCountLabel.textAlignment = .center
        
        // NSAttributedString 적용 부분
        if let currentText = fromCountLabel.text {
            let attributedString = NSMutableAttributedString(string: currentText)
            attributedString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: attributedString.length))
            fromCountLabel.attributedText = attributedString
        }

        let size = fromCountLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        fromCountLabel.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: 20)
        
        let rightBarItem2 = UIBarButtonItem()
        rightBarItem2.customView = fromCountLabel
        rightBarItem2.width = size.width + 20 - 10

        let heartImage = UIImageView(image: UIImage(named: "Property 28"))
        heartImage.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let rightBarItem3 = UIBarButtonItem()
        rightBarItem3.customView = heartImage
        rightBarItem3.width = 32 + 10

        let space = UIImageView(image: UIImage())
        space.frame = CGRect(x: 0, y: 0, width: 2, height: 0)
        let spacer = UIBarButtonItem()
        spacer.customView = space

        self.navigationItem.rightBarButtonItems = [spacer, rightBarItem2, rightBarItem3]
        
        let leftItem = UIImageView(image: UIImage(named: "logotypo"))
        leftItem.frame = CGRect(x: 0, y: 0, width: 65, height: 18)
        
        let imageButtonItem = UIBarButtonItem(customView: leftItem)
                
        // Set the UIBarButtonItem as the left navigation item of your view controller
        navigationItem.leftBarButtonItem = imageButtonItem
    }

    // MARK: - Funtions
    private func setplusPlanButton(){
        view.addSubview(plusPlanButtonContainer)
            
        NSLayoutConstraint.activate([
            plusPlanButtonContainer.heightAnchor.constraint(equalToConstant: 56),
            plusPlanButtonContainer.widthAnchor.constraint(equalToConstant: 56),
            plusPlanButtonContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            plusPlanButtonContainer.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -32) // Assuming you want it 32 points above the bottom
        ])
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        if calendarEventDates.contains(date) {
            return 1
        }
        return 0
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let firstDayOfMonth = calendar.currentPage
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMM"
        let monthString = formatter.string(from: firstDayOfMonth)
        
        // 원하는 형식의 문자열로 변환된 month를 사용하여 getSpecificCalendarSchedules 메서드 호출
        getSpecificCalendarSchedules(month: monthString, date: "")
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let bottomSheetVC = CalendarBottomSheetViewController()
        bottomSheetVC.selectedDate = date
        bottomSheetVC.modalPresentationStyle = .overFullScreen
        self.present(bottomSheetVC, animated: false, completion: nil)
    }
}

extension CalendarViewController{
    
    private func getFromCount() {
        ViewAPI.providerView.request(.getFromCount) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(FromCountResponse.self)
                    self.fromCountLabel.text = "\(response.result)"
                    print(response)
                } catch {
                    print(error)
                }
            case .failure(let error):
                print("DEBUG>> getFromCount Error : \(error.localizedDescription)")
            }
        }
    }
    
    private func getSpecificCalendarSchedules(month: String, date: String) {
        ScheduleAPI.providerSchedule.request(.getSpecificCalendarSchedules(month: month, date: date)) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try data.map(GetCalendarSchedulesResponse.self)
                    print(response)

                    // Date formatter 설정
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyyMMdd"

                    // 날짜 데이터 추출 후 Date 객체로 변환
                    for schedule in response.result {
                        if let dateString = schedule?.date, let date = dateFormatter.date(from: dateString) {
                            self.calendarEventDates.append(date)
                        }
                    }
                    // 이벤트가 추가된 후 FSCalendar 갱신
                    self.calendarView.reloadData()

                } catch {
                    print(error)
                }
            case .failure(let error):
                print("DEBUG>> getSpecificCalendarSchedules Error : \(error.localizedDescription)")
            }
        }
    }
    
}
