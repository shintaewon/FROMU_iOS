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
    
    @IBOutlet weak var shadowView: UIView!
    
    let btn2 = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFromCount()
        configureNavigationItems()
        calendarView.delegate = self
        calendarView.dataSource = self
  
        
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 12
        shadowView.layer.shadowOpacity = 1
        
        calendarView.appearance.headerTitleFont = UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 14)
        calendarView.appearance.headerTitleColor = .black
        calendarView.appearance.headerDateFormat = "MMMM YYYY"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0
        
        calendarView.appearance.titleFont = UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 14)
        
        calendarView.appearance.weekdayTextColor = .white
        calendarView.placeholderType = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getFromCount()
    }
}

extension CalendarViewController{
    
    func configureNavigationItems(){
        
        
//        let btn1 = UIImageView(image: UIImage(named: "icn_bell"))
//        btn1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
//        let item1 = UIBarButtonItem()
//        item1.customView = btn1

        btn2.backgroundColor = .primaryLight
        btn2.layer.cornerRadius = 10
        btn2.clipsToBounds = true
        btn2.font = UIFont.Pretendard(.regular, size: 12)
        btn2.text = "    "
        btn2.textColor = .primary02
        btn2.textAlignment = .center
        let size = btn2.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        btn2.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: 20)
        let item2 = UIBarButtonItem()
        item2.customView = btn2
        item2.width = size.width + 20 - 10 // Decrease the width of item2 by 10 points

        let btn3 = UIImageView(image: UIImage(named: "Property 28"))
        btn3.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let item3 = UIBarButtonItem()
        item3.customView = btn3
        item3.width = 32 + 10 // Increase the width of item3 by 10 points

        let space = UIImageView(image: UIImage())
        space.frame = CGRect(x: 0, y: 0, width: 2, height: 0)
        let spacer = UIBarButtonItem()
        spacer.customView = space

        self.navigationItem.rightBarButtonItems = [spacer, item2, item3]
        
        let leftItem = UIImageView(image: UIImage(named: "logotypo"))
        leftItem.frame = CGRect(x: 0, y: 0, width: 65, height: 18)
        
        let imageButtonItem = UIBarButtonItem(customView: leftItem)
                
        // Set the UIBarButtonItem as the left navigation item of your view controller
        navigationItem.leftBarButtonItem = imageButtonItem
    }
}

extension CalendarViewController{
    func getFromCount(){
        
        ViewAPI.providerView.request(.getFromCount){ result in
            switch result{
            case .success(let data):
                do{
                    let response = try data.map(FromCountResponse.self)
                    self.btn2.text = "\(response.result)"
                    print(response)
                } catch{
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> getFromCount Error : \(error.localizedDescription)")
                
            }
        }
    }
}
