//
//  CalendarViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendarView: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.delegate = self
        calendarView.dataSource = self
  
        calendarView.appearance.headerTitleFont = UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 14)
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.headerDateFormat = "MMMM YYYY"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendarView.appearance.titleFont = UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 14)
        
        calendarView.appearance.weekdayTextColor = .white
        calendarView.placeholderType = .none
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
