//
//  ProhibitAlertViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/16.
//

import UIKit

class ProhibitAlertViewController: UIViewController {

    @IBOutlet weak var alertBGview: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
 
    @IBAction func didTapCloseBtn(_ sender: Any) {
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
        
        closeBtn.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

}


