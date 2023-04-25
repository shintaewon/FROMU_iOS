//
//  AskingWritingLetterViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/16.
//

import UIKit

protocol AskingWritingLetterViewControllerDelegate: AnyObject {
    func goToWritingView()
}

class AskingWritingLetterViewController: UIViewController {

    @IBOutlet weak var alertBGview: UIView!
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var writeBtn: UIButton!
    
    weak var delegate: AskingWritingLetterViewControllerDelegate?
    
    @IBAction func didTapCloseBtn(_ sender: Any) {
        dismiss(animated: false)
    }
    
    
    @IBAction func didTapWriteBtn(_ sender: Any) {
        dismiss(animated: false) {
            self.delegate?.goToWritingView()
        }
    }
    
    
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: view)
        if !alertBGview.frame.contains(tapLocation) {
            self.dismiss(animated: false)
        }
    }
    
    private func configuration(){
        
        alertBGview.layer.cornerRadius = 20
        
        closeBtn.layer.cornerRadius = 12
        closeBtn.layer.borderWidth = 1
        closeBtn.layer.borderColor = UIColor.primary01.cgColor
        
        writeBtn.layer.cornerRadius = 12
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuration()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }

}


