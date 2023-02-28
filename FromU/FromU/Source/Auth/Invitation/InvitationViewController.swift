//
//  InvitationViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/25.
//

import UIKit

class InvitationViewController: UIViewController {

  
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var invitationBtn: UIButton!//"초대장 보내기" 버튼
    @IBOutlet weak var inputCodeBtn: UIButton!//"연인의 코드 입력하기" 버튼
    
    @IBOutlet weak var invitationCodeLabel: UILabel!
    
    @IBAction func didTapInvitationBtn(_ sender: Any) {
        var objectsToShare = [String]()
        if let text = invitationCodeLabel.text {
            let textToShare : String = """
                당신의 연인 ‘아라'로부터
                FROMU 초대장이 도착했어.
                링크를 눌러 우리와 함께 할래?
                커플코드: \(invitationCodeLabel.text ?? "")
                """
            
            objectsToShare.append(textToShare)
            print("[INFO] textField's Text : ", textToShare)
        }
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        
        self.present(activityVC, animated: true, completion: nil)
    }
    
    
    @IBAction func didTapInputCodeBtn(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "InputCode", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "InputCodeViewController") as? InputCodeViewController else{ return }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func yourSelectorMethod() {
        // Code to handle the action goes here
        print("The user tapped the right UIBarButtonItem")
    }
    
    
    @IBAction func didTapCloseBtn(_ sender: Any) {
        descriptionView.isHidden = true
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

        navigationController?.navigationBar.tintColor = .icon
       
        // Create a UIImage for your UIBarButtonItem
        let refreshImage = UIImage(named: "refresh_white")

        // Create a UIBarButtonItem with your UIImage
        let barButtonItem = UIBarButtonItem(image: refreshImage, style: .plain, target: self, action: #selector(yourSelectorMethod))

        // Set the UIBarButtonItem as the rightBarButtonItem of the UINavigationItem of your UIViewController
        navigationItem.rightBarButtonItem = barButtonItem
    
        invitationBtn.layer.cornerRadius = 8
        inputCodeBtn.layer.cornerRadius = 8
        
    }
    

}
