//
//  MailboxViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit

import Moya

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var stampBtn: UIButton!
    @IBOutlet weak var writingBtn: UIButton!
    
    @IBOutlet weak var mailboxNameLabel: UILabel!
    
    @IBOutlet weak var explainLabel: UILabel!
    
    @IBOutlet weak var mainBoxImageView: UIImageView!
    
    @IBOutlet weak var tooltipImageView: UIImageView!
    @IBOutlet weak var tooltipLabel: UILabel!
    
    let fromCountLabel = UILabel()
    
    @IBAction func didTapStampBtn(_ sender: Any) {
        
        let vc = StampBoxViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTapWritingBtn(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AskingWritingLetterViewController") as? AskingWritingLetterViewController else {return}
        vc.delegate = self
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
    
    @objc func didTapMailBox(){
//        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "AskingWritingLetterViewController") as? AskingWritingLetterViewController else {return}
//
//        vc.modalPresentationStyle = .overCurrentContext
//        present(vc, animated: false, completion: nil)
        let vc = MailboxLetterViewController()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationItems()
        
        self.tooltipImageView.isHidden = true
        self.tooltipLabel.isHidden = true
        
        
        shadowView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
        shadowView.layer.shadowRadius = 12
        shadowView.layer.shadowOpacity = 1
        
        // Set corner radius
        stampBtn.layer.cornerRadius = 10
        stampBtn.clipsToBounds = true

        // Add shadow
        stampBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        stampBtn.layer.shadowOffset = CGSize(width: 0, height: 4)
        stampBtn.layer.shadowOpacity = 1
        stampBtn.layer.shadowRadius = 12
        
        stampBtn.layer.masksToBounds = false
        
        // Set corner radius
        writingBtn.layer.cornerRadius = 10
        writingBtn.clipsToBounds = true

        // Add shadow
        writingBtn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        writingBtn.layer.shadowOffset = CGSize(width: 0, height: 4)
        writingBtn.layer.shadowOpacity = 1
        writingBtn.layer.shadowRadius = 12
        
        writingBtn.layer.masksToBounds = false
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMailBox))
        
        mainBoxImageView.addGestureRecognizer(tapGestureRecognizer)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getFromCount()
        getMailboxView()
    }
}

extension MailboxViewController{
    
    func configureNavigationItems(){
        fromCountLabel.backgroundColor = .primaryLight
        fromCountLabel.layer.cornerRadius = 10
        fromCountLabel.clipsToBounds = true
        fromCountLabel.font = UIFont.BalsamTint(.size16)
        fromCountLabel.text = "    "
        fromCountLabel.textColor = .primary02
        fromCountLabel.textAlignment = .center
        
        // NSAttributedString 적용 부분
        if let currentText = fromCountLabel.text {
            let attributedString = NSMutableAttributedString(string: currentText)
            attributedString.addAttribute(.baselineOffset, value: 2, range: NSRange(location: 0, length: attributedString.length))
            fromCountLabel.attributedText = attributedString
        }

        let size = fromCountLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        fromCountLabel.frame = CGRect(x: 0, y: 0, width: size.width + 20, height: 20)
        
        let fromCountItem = UIBarButtonItem()
        fromCountItem.customView = fromCountLabel
        fromCountItem.width = size.width + 20 - 10

        let heartImage = UIImageView(image: UIImage(named: "Property 28"))
        heartImage.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        let heartImageItem = UIBarButtonItem()
        heartImageItem.customView = heartImage
        heartImageItem.width = 32 + 10

        let space = UIImageView(image: UIImage())
        space.frame = CGRect(x: 0, y: 0, width: 2, height: 0)
        let spacer = UIBarButtonItem()
        spacer.customView = space

        let bellButton = UIButton()
        bellButton.setImage(UIImage(named: "icn_bell"), for: .normal)
        bellButton.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let bellItem = UIBarButtonItem()
        bellItem.customView = bellButton
        bellItem.width = 32 + 10
        
        self.navigationItem.rightBarButtonItems = [bellItem, spacer, fromCountItem, heartImageItem]
        
        let leftItem = UIImageView(image: UIImage(named: "logotypo"))
        leftItem.frame = CGRect(x: 0, y: 0, width: 65, height: 18)
        
        let imageButtonItem = UIBarButtonItem(customView: leftItem)
                
        // Set the UIBarButtonItem as the left navigation item of your view controller
        navigationItem.leftBarButtonItem = imageButtonItem
        
    }
}

extension MailboxViewController: AskingWritingLetterViewControllerDelegate, OnboardingWrittingLetterViewControllerDelegate{
    
    
    func goToSelectStampView() {
        
        let storyboard = UIStoryboard(name: "SelectStamp", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectStampViewController") as? SelectStampViewController else {return}
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func goToWritingView() {
        let storyboard = UIStoryboard(name: "WritingLetter", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "OnboardingWrittingLetterViewController") as? OnboardingWrittingLetterViewController else {return}
        vc.hidesBottomBarWhenPushed = true
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension MailboxViewController{
    
    func getMailboxView(){
        
        ViewAPI.providerView.request(.getMailBoxViewInfo){ result in
            switch result{
            case .success(let data):
                do{
                    let response = try data.map(MailboxViewResponse.self)
                    
                    self.explainLabel.lineBreakMode = .byWordWrapping
                        
                    let paragraphStyle = NSMutableParagraphStyle()

                    paragraphStyle.lineHeightMultiple = 1.27

                    self.explainLabel.attributedText = NSMutableAttributedString(string: """
                        \(response.result.mailboxName)의 이야기를
                        다른 우편함으로 전송해볼까?
                        """, attributes: [
                            .font: UIFont.BalsamTint(.size22),
                            NSAttributedString.Key.paragraphStyle: paragraphStyle])
                    
                    self.mailboxNameLabel.text = response.result.mailboxName
                    self.mailboxNameLabel.font = UIFont.BalsamTint(.size14)
                    self.mailboxNameLabel.textAlignment = .center
                    
                    //편지 온거 있을때!
                    if response.result.newLetterID != 0 {
                        self.mainBoxImageView.image = UIImage(named: "mainBox_Mail")
                        self.tooltipImageView.isHidden = false
                        self.tooltipLabel.isHidden = false
                    } else{
                        self.mainBoxImageView.image = UIImage(named: "mainBox_Empty")
                        self.tooltipImageView.isHidden = true
                        self.tooltipLabel.isHidden = true
                    }
                    
                } catch{
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> getFromCount Error : \(error.localizedDescription)")
                
            }
        }
    }
    
    func getFromCount(){
        ViewAPI.providerView.request(.getFromCount){ result in
            switch result{
            case .success(let data):
                do{
                    let response = try data.map(FromCountResponse.self)
                    self.fromCountLabel.text = "\(response.result)"
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

