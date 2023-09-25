//
//  CanNotSendAlertViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/16.
//

import UIKit

class CanNotSendAlertViewController: UIViewController {

    @IBOutlet weak var alertBGview: UIView!
    
    @IBOutlet weak var changeBtn: UIButton!
    
    @IBOutlet weak var alertLabel: UILabel!
    
    @IBAction func didTapChangeBtn(_ sender: Any) {
        self.dismiss(animated: false)
  
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        if !alertBGview.frame.contains(tapLocation) {
            self.dismiss(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertBGview.layer.cornerRadius = 20
        
        changeBtn.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
        
        alertLabel.lineBreakMode = .byWordWrapping
        
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.27
        paragraphStyle.alignment = .center
        alertLabel.attributedText = NSMutableAttributedString(string:"""
일기를 작성하지 않으면
상대방에게 일기를 보낼 수 없어
""" ,attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }

}
