//
//  ChangeCoverAlertViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/11.
//

import UIKit

protocol ChangeCoverAlertDelegate: AnyObject {
    
    func goToGallery()
}

class ChangeCoverAlertViewController: UIViewController {

    weak var delegate: ChangeCoverAlertDelegate?
    
    @IBOutlet weak var alertBGview: UIView!
    
    @IBOutlet weak var changeBtn: UIButton!
    
 
    @IBAction func didTapChangeBtn(_ sender: Any) {
        self.dismiss(animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.delegate?.goToGallery()
        }
    
    }
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        if sender.view != alertBGview {
            self.dismiss(animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        alertBGview.layer.cornerRadius = 20
        
        changeBtn.layer.cornerRadius = 12
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
}
