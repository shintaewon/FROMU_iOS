//
//  MailboxLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/05/03.
//

import UIKit

class MailboxLetterViewController: UIViewController {

    var receivedViewController: UIViewController!
    var sentViewController: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("viewDidLoad됨")
        view.backgroundColor = .white
        
        navigationController?.navigationBar.tintColor = .icon
        
        title = "우편함"
        
        if let customFont = UIFont(name: "777Balsamtint", size: 18) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: customFont]
        }
        
        
        let navBarY = self.navigationController?.navigationBar.frame.origin.y ?? 0
        let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        
        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: navBarY + navBarHeight, width: self.view.bounds.width, height: 44), buttonTitle: ["받은편지","보낸편지"])
        codeSegmented.backgroundColor = .clear
        view.addSubview(codeSegmented)
        codeSegmented.delegate = self
        
        // Instantiate received and sent view controllers
        receivedViewController = ReceivedLetterViewController() // 변경된 부분
        
        sentViewController = SentLetterViewController()

        // Set initial view controller
        change(to: 0)
    }


}

extension MailboxLetterViewController: CustomSegmentedControlDelegate{
    
    func change(to index: Int) {
        
        let navBarY = self.navigationController?.navigationBar.frame.origin.y ?? 0
        let navBarHeight = self.navigationController?.navigationBar.frame.height ?? 0
        
        if index == 0 {
            addChild(receivedViewController)
            receivedViewController.view.frame = CGRect(x: 0, y: navBarY + navBarHeight + 46 , width: view.bounds.width, height: view.bounds.height - (navBarY + navBarHeight + 46))
            view.insertSubview(receivedViewController.view, belowSubview: view.subviews[0])
            receivedViewController.didMove(toParent: self)
            
            sentViewController.willMove(toParent: nil)
            sentViewController.view.removeFromSuperview()
            sentViewController.removeFromParent()
        } else {
            addChild(sentViewController)
            sentViewController.view.frame = CGRect(x: 0, y: navBarY + navBarHeight + 46, width: view.bounds.width, height: view.bounds.height - (navBarY + navBarHeight + 46))
            view.insertSubview(sentViewController.view, belowSubview: view.subviews[0])
            sentViewController.didMove(toParent: self)
            
            receivedViewController.willMove(toParent: nil)
            receivedViewController.view.removeFromSuperview()
            receivedViewController.removeFromParent()
        }
    }
}
