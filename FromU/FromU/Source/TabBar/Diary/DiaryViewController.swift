//
//  DiaryViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/01.
//

import UIKit

import Moya
import Lottie
import SwiftKeychainWrapper

class DiaryViewController: UIViewController {

    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var anniDayLabel: UILabel!
    
    @IBOutlet weak var setFirstDayImgView: UIImageView!
    
    @IBOutlet weak var setFirstDayLabel: UILabel!
    
    @IBOutlet weak var plusDiaryBookBtn: UIButton!
    
    @IBOutlet weak var plusDiaryLabel: UILabel!
    
    @IBOutlet weak var pokeBtn: UIButton!
    
    @IBOutlet weak var mainDiaryImageView: UIImageView!
    
    @IBOutlet weak var askPokeLabel: UILabel!
    
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var diaryNameLabel: UILabel!
    
    @IBOutlet weak var myNickNameLabel: UILabel!
    
    @IBOutlet weak var partnerNickNameLabel: UILabel!
    
    @IBOutlet weak var partnerHasDiaryPic: UIImageView!
    
    @IBOutlet weak var fingerLottieView: LottieAnimationView!
    
    @IBOutlet weak var locationLottieView: LottieAnimationView!
    
    let animationFinger = LottieAnimationView(name: "hand")
    let animationGoing = LottieAnimationView(name: "goingdiary")
    let animationComing = LottieAnimationView(name: "comingdiary")
    
    //현재 내가 일기를 썼는지 안썼는지 알려주는 flag
    var writeFlag = true
    
    //    * 일기장이 생성되지 않았으면 0
    //    * 일기장이 나에게 있으면 1
    //    * 일기장이 오는 중이면 2
    //    * 일기장이 가는 중이면 3
    //    * 일기장이 상대한테 있으면 4
    var diarybookStatus = 5
    
    var fromCountLabel = UILabel()
    
    @objc func diaryImageTapped(){
        
        let storyboard = UIStoryboard(name: "WriteDiary", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SetDiaryCoverViewController") as? SetDiaryCoverViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        vc.diaryName = diaryNameLabel.text ?? ""
    }
    
    @objc func setFirstDayImageViewTapped() {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingFirstDayViewController") as? SettingFirstDayViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapAddDiaryBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "AddDiaryBook", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SelectCoverViewController") as? SelectCoverViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapSendBtn(_ sender: Any) {
        //일기장도 나한테 있는데, 일기까지 썼을때 -> 일기 전송하고 리로드 시켜야됨
        if diarybookStatus == 1 && writeFlag == true {
            sendDiaryBook()
        }
        //일기장은 나한테 있지만, 아직 일기를 쓰지 않았을때 -> Alert 띄워줘야됨
        else if diarybookStatus == 1 && writeFlag == false {
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CanNotSendAlertViewController") as? CanNotSendAlertViewController else {return}
            
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false, completion: nil)
        }
    }
    
    private let loadingIndicator: UIActivityIndicatorView = {
           let indicator = UIActivityIndicatorView(style: .medium)
           indicator.hidesWhenStopped = true
           return indicator
       }()
    
    func reloadContent() {
        
        // Start the loading indicator
        loadingIndicator.startAnimating()
        
        // Refresh the UI elements and fetch new data here
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.getMainViewInfo()
            
            self?.loadingIndicator.stopAnimating()
        }
    }

    
    @IBAction func didTapPokeBtn(_ sender: Any) {
        showToast(message: "띵동! 연인에게 벨을 울렸어!", font: UIFont.Pretendard(.regular, size: 14))
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
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(setFirstDayImageViewTapped))
        
        setFirstDayImgView.addGestureRecognizer(tapGestureRecognizer1)
        
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(diaryImageTapped))
        
        mainDiaryImageView.addGestureRecognizer(tapGestureRecognizer2)
        
        fingerLottieView.addSubview(animationFinger)
        animationFinger.frame = fingerLottieView.bounds
        animationFinger.contentMode = .scaleToFill
        animationFinger.loopMode = .loop
        
        locationLottieView.addSubview(animationComing)
        locationLottieView.addSubview(animationGoing)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false

        self.getMainViewInfo()
        self.getFromCount()
        
    }

}

extension DiaryViewController{
    

    func showAnimation(_ animationView: LottieAnimationView) {
        animationView.isHidden = false
        animationView.frame = self.locationLottieView.bounds
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .loop
        animationView.play()
    }
    
    private func configureNavigationItems() {
        
        plusDiaryBookBtn.isHidden = true
        plusDiaryLabel.isHidden = true
        mainDiaryImageView.isHidden = true
        pokeBtn.isHidden = true
        askPokeLabel.isHidden = true
        diaryNameLabel.isHidden = true
        sendBtn.isHidden = true
        partnerHasDiaryPic.isHidden = true
        fingerLottieView.isHidden = true
        locationLottieView.isHidden = true
        
        
        sendBtn.layer.cornerRadius = 8
        
        navigationItem.hidesBackButton = true
        
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

extension DiaryViewController{
    
    func getMainViewInfo(){
        
        ViewAPI.providerView.request( .getMainViewInfo){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(MainViewResponse.self)
                    
                    print(response)
                    //통신 성공
                    
                    if response.code == 1000{
                        
                        //dday가 0이 아니면 처음 만난 날 설정해준것이므로 날짜 띄워주면 됨
                        if response.result?.dday != 0 {
                            UserDefaults.standard.set(response.result?.dday, forKey: "dDay")
                            
                            self.setFirstDayImgView.isHidden = true
                            self.setFirstDayLabel.isHidden = true
                            self.anniDayLabel.text = "\(response.result?.dday ?? 0)"
                            self.anniDayLabel.sizeToFit()
                            
                            let bottomBorder = CALayer()
                            bottomBorder.frame = CGRect(x: 0, y: self.anniDayLabel.frame.size.height - 2, width: self.anniDayLabel.frame.size.width, height: 1)
                            bottomBorder.backgroundColor = UIColor.primaryLight.cgColor
                            self.anniDayLabel.layer.addSublayer(bottomBorder)
                        }
                        else{//dday 0이면 처음 만난 날 아직 설정 안한겨
                            self.setFirstDayImgView.isHidden = false
                            self.setFirstDayLabel.isHidden = false
                            self.anniDayLabel.text = "    "
                            self.anniDayLabel.sizeToFit()
                            
                            let bottomBorder = CALayer()
                            bottomBorder.frame = CGRect(x: 0, y: self.anniDayLabel.frame.size.height - 2, width: self.anniDayLabel.frame.size.width, height: 1)
                            bottomBorder.backgroundColor = UIColor.primaryLight.cgColor
                            self.anniDayLabel.layer.addSublayer(bottomBorder)
                            
                        }
                        
                        self.myNickNameLabel.text = response.result?.nickname
                        self.partnerNickNameLabel.text = response.result?.partnerNickname
                        
                        self.writeFlag = ((response.result?.diarybook?.writeFlag) != nil)
                        
                        print("writeFlag:", self.writeFlag)
                        
                        self.diarybookStatus = response.result?.diarybookStatus ?? 5
                        
                        UserDefaults.standard.setValue(response.result?.nickname, forKey: "myNickName")
                        
                        UserDefaults.standard.setValue(response.result?.partnerNickname, forKey: "partnerNickName")
                        
                        UserDefaults.standard.setValue(response.result?.dday, forKey: "dDay")
                        
                        print("diarybookStatus:", self.diarybookStatus)
                        
                        //    * 일기장이 생성되지 않았으면 0
                        //    * 일기장이 나에게 있으면 1
                        //    * 일기장이 오는 중이면 2
                        //    * 일기장이 가는 중이면 3
                        //    * 일기장이 상대한테 있으면 4
                      
                        self.animationComing.isHidden = true
                        self.animationGoing.isHidden = true
                        
                        if response.result?.diarybookStatus == 0{
                        
                            self.pokeBtn.isHidden = true
                            self.askPokeLabel.isHidden = true
                            self.diaryNameLabel.isHidden = true
                            self.sendBtn.isHidden = true
                            self.plusDiaryBookBtn.isHidden = false
                            self.plusDiaryLabel.isHidden = false
                            self.mainDiaryImageView.isHidden = true
                            self.partnerHasDiaryPic.isHidden = true
                            self.locationLottieView.isHidden = true
                            self.fingerLottieView.isHidden = true
                        }
                        else if response.result?.diarybookStatus == 1{
                            
                            self.mainDiaryImageView.isHidden = false
                            self.diaryNameLabel.isHidden = false
                            self.fingerLottieView.isHidden = true
                            self.locationLottieView.isHidden = true
                            self.plusDiaryBookBtn.isHidden = true
                            self.plusDiaryLabel.isHidden = true
                            self.pokeBtn.isHidden = true
                            self.askPokeLabel.isHidden = true
    
                            self.sendBtn.isHidden = false
                            self.partnerHasDiaryPic.isHidden = true
                            self.diaryNameLabel.text = response.result?.diarybook?.name
                            
                            UserDefaults.standard.set(response.result?.diarybook?.name, forKey: "diaryBookName")
                            let coverNum = "diaryImage" + "\(response.result?.diarybook?.coverNum ?? 0)"
                            
                            self.mainDiaryImageView.image = UIImage(named: coverNum)
                            
                            self.mainDiaryImageView.layer.cornerRadius = 12
                            self.mainDiaryImageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor
                            self.mainDiaryImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
                            self.mainDiaryImageView.layer.shadowRadius = 12
                            self.mainDiaryImageView.layer.shadowOpacity = 1
                            self.partnerHasDiaryPic.isHidden = true
                                                                                    
                        }
                        
                        else if response.result?.diarybookStatus == 2 {
              
                            self.plusDiaryBookBtn.isHidden = true
                            self.plusDiaryLabel.isHidden = true
                            self.mainDiaryImageView.isHidden = true

                            self.pokeBtn.isHidden = true
                            self.askPokeLabel.isHidden = true
                            self.diaryNameLabel.isHidden = true
                            self.sendBtn.isHidden = true
                            self.fingerLottieView.isHidden = true
                            self.partnerHasDiaryPic.isHidden = true
                            self.locationLottieView.isHidden = false
                            
                            self.animationGoing.isHidden = true
                            self.showAnimation(self.animationComing)
                        }
                        
                        else if response.result?.diarybookStatus == 3 {
              
                            self.plusDiaryBookBtn.isHidden = true
                            self.plusDiaryLabel.isHidden = true
                            self.mainDiaryImageView.isHidden = true

                            self.pokeBtn.isHidden = true
                            self.askPokeLabel.isHidden = true
                            self.diaryNameLabel.isHidden = true
                            self.sendBtn.isHidden = true
                            self.fingerLottieView.isHidden = true
                            self.partnerHasDiaryPic.isHidden = true
                            self.locationLottieView.isHidden = false
                            
                            self.animationComing.isHidden = true
                            self.showAnimation(self.animationGoing)
                        }
                        else{
                            self.fingerLottieView.isHidden = false
                            self.plusDiaryBookBtn.isHidden = true
                            self.plusDiaryLabel.isHidden = true
                            self.mainDiaryImageView.isHidden = true
                            self.diaryNameLabel.isHidden = true
                            self.sendBtn.isHidden = true
                            
                            self.pokeBtn.isHidden = false
                            self.askPokeLabel.isHidden = false
                            self.partnerHasDiaryPic.isHidden = false
            
                            self.animationFinger.play()
                        }
                    }
                    //어떤 이유로 토큰이 사라짐 -> 로그아웃
                    else if response.code == 2000{
                        self.logout()
                    }
                    //토큰 만료
                    else if response.code == 2001 {
                        print("토큰 만료")
                        self.refreshToken()
                    }
                    //상대방이 커플 연결 끊어버린거
                    else if response.code == 4002{
                        self.logout()
                    }
                    
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> checkMailBoxName Error : \(error.localizedDescription)")
            }
        }
    }
    
    func sendDiaryBook(){
        
        DiaryBookAPI.providerDiaryBook.request( .sendDiaryBook){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(SendDiaryBookResponse.self)
                    print(response)
                    if response.isSuccess == true{
            
                        self.reloadContent()
                    }
                    else{
                        if response.code == 2071{
                            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "CanNotSendAlertViewController") as? CanNotSendAlertViewController else {return}
                            
                            vc.modalPresentationStyle = .overCurrentContext
                            self.present(vc, animated: false, completion: nil)
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
    
    func refreshToken(){
        
        UserAPI.providerUser.request(.refreshToken){ result in
            switch result{
            case .success(let data):
                do{
                    let response = try data.map(RefreshTokenResponse.self)
                    
                    print(response)
                    
                    if response.code == 1000{
                        KeychainWrapper.standard.set(response.result?.jwt ?? "" , forKey: "X-ACCESS-TOKEN")
                        KeychainWrapper.standard.set(response.result?.refreshToken ?? "" , forKey: "RefreshToken")
                        
                        DispatchQueue.main.async { // UI 업데이트는 메인 스레드에서 수행해야 합니다.
                            self.getMainViewInfo()
                            
                        }
                    } else{
                        self.logout()
                    }
                    
                } catch{
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> getFromCount Error : \(error.localizedDescription)")
                
            }
        }
    }
    
    func logout(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let viewControllerA = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            let navigationController = UINavigationController(rootViewController: viewControllerA)

            //키체인에 UserPassword 삭제
            KeychainWrapper.standard.removeObject(forKey: "X-ACCESS-TOKEN")

            //키체인에 RefreshToken 삭제
            KeychainWrapper.standard.removeObject(forKey: "RefreshToken")
            
            //오토로그인 false로 설정
            UserDefaults.standard.setValue(false, forKey: "isAutoLoginValidation")
            
            // Dismiss all presented view controllers and set the new root view controller
            self.view.window?.rootViewController?.dismiss(animated: true, completion: {
                UIApplication.shared.keyWindow?.rootViewController = navigationController
            })
        }
    }
}

extension DiaryViewController{
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: sendBtn.layer.frame.origin.x, y: 50, width: self.view.frame.width - sendBtn.layer.frame.origin.x * 2 , height: 52))
        toastLabel.backgroundColor = UIColor(red: 0.167, green: 0.167, blue: 0.167, alpha: 1)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 4
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.5, delay: 0.1, options: .curveEaseOut,animations: {
            toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
        }
    
}
