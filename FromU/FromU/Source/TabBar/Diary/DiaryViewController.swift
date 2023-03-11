//
//  DiaryViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit

import Moya

class DiaryViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var anniDayLabel: UILabel!
    
    @IBOutlet weak var setFirstDayImgView: UIImageView!
    
    
    @IBOutlet weak var diaryLocationLabel: UILabel!
    
    @IBOutlet weak var plusDiaryBookBtn: UIButton!
    
    @IBOutlet weak var plusDiaryLabel: UILabel!
    
    @IBOutlet weak var pokeBtn: UIButton!
    
    @IBOutlet weak var mainDiaryImageView: UIImageView!
    
    @IBOutlet weak var askPokeLabel: UILabel!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    
    @IBOutlet weak var diaryNameLabel: UILabel!
    
    @objc func diaryImageTapped(){
        
        let storyboard = UIStoryboard(name: "WriteDiary", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SetDiaryCoverViewController") as? SetDiaryCoverViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.diaryName = diaryNameLabel.text ?? ""
    }
    
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
        
        let titleString = "띵동! 벨 울리기"
        
        let attributedString = NSMutableAttributedString(string: titleString)
        let range = NSRange(location: 0, length: attributedString.length)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 16), // set the desired font here
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedString.addAttributes(attributes, range: range)

        pokeBtn.setAttributedTitle(attributedString, for: .normal)
        
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: anniDayLabel.frame.size.height - 2, width: anniDayLabel.frame.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.primaryLight.cgColor
        anniDayLabel.layer.addSublayer(bottomBorder)
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(setFirstDayImageViewTapped))
        
        setFirstDayImgView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(diaryImageTapped))
        
        mainDiaryImageView.addGestureRecognizer(tapGestureRecognizer2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        getMainViewInfo()
    }

}

extension DiaryViewController{
    
    func configureNavigationItems(){
        print("실행은 됨?")
        
        sendBtn.layer.cornerRadius = 8
        
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

        self.navigationItem.rightBarButtonItems = [item1, spacer, item2, item3]
    }
}

extension DiaryViewController{
    
    func getMainViewInfo(){
        plusDiaryBookBtn.isHidden = true
        plusDiaryLabel.isHidden = true
        mainDiaryImageView.isHidden = true
        diaryLocationLabel.isHidden = true
        pokeBtn.isHidden = true
        askPokeLabel.isHidden = true
        diaryNameLabel.isHidden = true
        
        ViewAPI.providerView.request( .getMainViewInfo){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(MainViewResponse.self)
                    
                    print(response)
                    //일단 통신은 성공
      
                    if response.isSuccess == true{
                        //dday가 0이 아니면 처음 만난 날 설정해준것이므로 날짜 띄워주면 됨
                        if response.result?.dday != 0 {
                            self.setFirstDayImgView.removeFromSuperview()
                            self.anniDayLabel.text = String(response.result?.dday ?? 0)
                        }
                        else{//dday 0이면 처음 만난 날 아직 설정 안한겨
                            self.anniDayLabel.text = "    "
                            
                        }
                        
                        //    * 일기장이 생성되지 않았으면 0
                        //    * 일기장이 나에게 있으면 1
                        //    * 일기장이 오는 중이면 2
                        //    * 일기장이 가는 중이면 3
                        //    * 일기장이 상대한테 있으면 4
                        if response.result?.diarybookStatus == 0{
                            self.plusDiaryBookBtn.isHidden = false
                            self.plusDiaryLabel.isHidden = false
                            self.mainDiaryImageView.isHidden = false
                        }
                        else if response.result?.diarybookStatus == 1{
                            self.mainDiaryImageView.isHidden = false
                            self.diaryNameLabel.isHidden = false
                            
                            self.diaryNameLabel.text = response.result?.diarybook?.name
                            let coverNum = "diaryImage" + "\(response.result?.diarybook?.coverNum ?? 0)"
                            
                            self.mainDiaryImageView.image = UIImage(named: coverNum)
                            
                            self.mainDiaryImageView.layer.cornerRadius = 12
                            self.mainDiaryImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
                            self.mainDiaryImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
                            self.mainDiaryImageView.layer.shadowRadius = 12
                            self.mainDiaryImageView.layer.shadowOpacity = 1
                            self.mainDiaryImageView.layer.masksToBounds = false
                            
                            
                        }
                        else if response.result?.diarybookStatus == 2 {
                            self.diaryLocationLabel.isHidden = false
                        }
                        else if response.result?.diarybookStatus == 3 {
                            self.diaryLocationLabel.text = "연인에게로 일기가 가고 있어!"
                            self.diaryLocationLabel.isHidden = false
                        }
                        else{
                            self.pokeBtn.isHidden = false
                            self.askPokeLabel.isHidden = false
                        }
                        
                    }
                    
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> checkMailBoxName Error : \(error.localizedDescription)")
            }
        }
    }
}
