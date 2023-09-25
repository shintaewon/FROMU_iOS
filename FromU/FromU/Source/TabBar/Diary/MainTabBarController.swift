//
//  MainTabBarController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.selectedImageTintColor = UIColor.primary02
        
        // For iOS 15 and later:
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.selectionIndicatorTintColor = UIColor.primary02
            self.tabBar.standardAppearance = appearance
        }
        
//        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
//
//        navigationItem.hidesBackButton = true
//
//
//        let btn1 = UIImageView(image: UIImage(named: "icn_bell"))
//        btn1.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
//        let item1 = UIBarButtonItem()
//        item1.customView = btn1
//
//        let btn2 = UILabel()
//        btn2.backgroundColor = .primaryLight
//        btn2.layer.cornerRadius = 10
//        btn2.clipsToBounds = true
//        btn2.font = UIFont.Pretendard(.regular, size: 12)
//        btn2.text = "10"
//        btn2.textColor = .primary02
//        btn2.textAlignment = .center
//
//        let size = btn2.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
//        btn2.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: 20)
//        let item2 = UIBarButtonItem()
//        item2.customView = btn2
//
//        let btn3 = UIImageView(image: UIImage(named: "Property 28"))
//        btn3.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
//        let item3 = UIBarButtonItem()
//        item3.customView = btn3
//
//
//        let space = UIImageView(image: UIImage())
//        space.frame = CGRect(x: 0, y: 0, width: 5, height: 0)
//        // Set the padding between the items
//        let spacer = UIBarButtonItem()
//        spacer.customView = space
//
//        self.navigationItem.rightBarButtonItems = [item1, spacer, item2, item3]
        
    }
}
