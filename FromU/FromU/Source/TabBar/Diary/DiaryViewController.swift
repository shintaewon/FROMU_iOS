//
//  DiaryViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit

class DiaryViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var anniDayLabel: UILabel!
    
    
    @IBOutlet weak var setFirstDayImgView: UILabel!
    
    @objc func setFirstDayImageViewTapped() {
        
        let storyboard = UIStoryboard(name: "SettingFirstDay", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SettingFirstDayViewController") as? SettingFirstDayViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapAddDiaryBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddDiaryBook", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectCoverViewController") as? SelectCoverViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            

        configureNavigationItems()
        
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 12
        shadowView.layer.shadowOpacity = 1
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: anniDayLabel.frame.size.height - 2, width: anniDayLabel.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.primaryLight.cgColor
        anniDayLabel.layer.addSublayer(bottomBorder)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setFirstDayImageViewTapped))
        
        setFirstDayImgView.isUserInteractionEnabled = true
        setFirstDayImgView.addGestureRecognizer(tapGestureRecognizer)
    }
    

}

extension DiaryViewController{
    
    func configureNavigationItems(){
        print("실행은 됨?")
        
        navigationItem.hidesBackButton = true
        
        let btn1 = UIImageView(image: UIImage(named: "icn_bell"))
        btn1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let item1 = UIBarButtonItem()
        item1.customView = btn1

        let btn2 = UILabel()
        btn2.backgroundColor = .primaryLight
        btn2.layer.cornerRadius = 10
        btn2.clipsToBounds = true
        btn2.font = UIFont.Pretendard(.regular, size: 12)
        btn2.text = "10"
        btn2.textColor = .primary02
        btn2.textAlignment = .center

        let size = btn2.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        btn2.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: 20)
        let item2 = UIBarButtonItem()
        item2.customView = btn2

        let btn3 = UIImageView(image: UIImage(named: "Property 28"))
        btn3.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let item3 = UIBarButtonItem()
        item3.customView = btn3

        
        let space = UIImageView(image: UIImage())
        space.frame = CGRect(x: 0, y: 0, width: 5, height: 0)
        // Set the padding between the items
        let spacer = UIBarButtonItem()
        spacer.customView = space

        self.navigationItem.rightBarButtonItems = [item1, spacer, item2, item3]
    }
}
