//
//  SetDiaryCoverViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/08.
//

import UIKit

import Alamofire
import Photos
import Kingfisher
import SwiftKeychainWrapper

class SetDiaryCoverViewController: UIViewController {

    @IBOutlet weak var diaryBackgroundView: UIImageView!
    @IBOutlet weak var diaryCoverImageView: UIImageView!
    
    @IBOutlet weak var diaryNameLabel: UILabel!
    
    @IBOutlet weak var goToLastPageBtn: UIButton!
    
    @IBOutlet weak var addPhotoImageView: UIImageView!
    
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    private var interactivePopGestureRecognizerEnabled = true
    private var shouldPushViewController = false
    var diaryBookID = 0
    
    var isDiaryEmpty = false
    
    @objc func okAction(){
        print("hi")
    }
    
    @IBAction func didTapBtn(_ sender: Any) {
        
        getDiaryList()
        
    }
    var diaryName = ""
    
    @objc func presentImagePicker() {
        
        if diaryCoverImageView.image == nil {
            let imagePicker = UIImagePickerController()

            // 모달 형식이기에, 모달 방식에서 화면 전환 스타일을 골라줄 수 있어요.
            imagePicker.modalPresentationStyle = .fullScreen

            // 앨범에서 불러올 지, 카메라를 실행할 지 골라주세요. 저는 앨범으로 했어요.
            imagePicker.sourceType = .photoLibrary

            // 이미지 피커를 다루기 위해 대리자를 채택해주세요.
            imagePicker.delegate = self

            // 사진을 찍거나 앨범에서 가져왔을 때, 해당 사진을 정방형(1:1)으로 편집을 원하면 추가해주세요.
            imagePicker.allowsEditing = true

            // 이미지 피커 실행
            present(imagePicker, animated: true)
        } else {
            print("안비어있음")
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeCoverAlertViewController") as? ChangeCoverAlertViewController else {return}
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.delegate = self
            present(vc, animated: false, completion: nil)
        }
    
    }
    
    // Handle btn1 tap event
    @objc func btn1Tapped() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteDiaryViewController") as? WriteDiaryViewController else {return}
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)

    }

    // Handle btn2 tap event
    @objc func btn2Tapped() {
        print("2")
    }

    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)

        switch gesture.state {
        case .began:
            if translation.x < 0 {
                self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            }
        case .changed:
            if translation.x < -100 {
                shouldPushViewController = true
            } else if translation.x > 100 {
                // Trigger pop action for left-to-right gesture
                self.navigationController?.popViewController(animated: true)
            }
        case .ended:
            if shouldPushViewController {
                if let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "ReviewDiaryViewController") as? ReviewDiaryViewController {
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                }
                shouldPushViewController = true
            }
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = interactivePopGestureRecognizerEnabled
        case .cancelled:
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = interactivePopGestureRecognizerEnabled
        default:
            break
        }
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            return SlideLeftPushAnimator()
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDiaryCover()
        PHPhotoLibrary.requestAuthorization( { status in })
        configureNavigationItems()
        
        self.navigationController?.delegate = self
        self.interactivePopGestureRecognizerEnabled = self.navigationController?.interactivePopGestureRecognizer?.isEnabled ?? true
        
        if isDiaryEmpty == false {
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
            view.addGestureRecognizer(panGestureRecognizer)
        }
        
        let titleString = "마지막 페이지로"
        
        let attributedString = NSMutableAttributedString(string: titleString)
        let range = NSRange(location: 0, length: attributedString.length)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 16), // set the desired font here
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        attributedString.addAttributes(attributes, range: range)

        goToLastPageBtn.setAttributedTitle(attributedString, for: .normal)
        
        diaryCoverImageView.layer.borderWidth = 1
        diaryCoverImageView.layer.borderColor = UIColor(hex: 0xC1C1C1).cgColor
        diaryCoverImageView.layer.cornerRadius = 8
        
        navigationController?.navigationBar.tintColor = .icon
        
        diaryNameLabel.text = diaryName

        diaryNameLabel.sizeToFit()
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: diaryNameLabel.frame.size.height + 4, width: diaryNameLabel.frame.size.width, height: 2)
        bottomBorder.backgroundColor = UIColor.gray06.cgColor
        
        diaryNameLabel.layer.addSublayer(bottomBorder)
        
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        
        diaryCoverImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }

}

extension SetDiaryCoverViewController{
    
    func configureNavigationItems(){

        
        let btn1 = UIImageView(image: UIImage(named: "icn_write"))
        btn1.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let item1 = UIBarButtonItem()
        item1.customView = btn1

        let btn2 = UIImageView(image: UIImage(named: "icn_list"))
        btn2.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let item2 = UIBarButtonItem()
        item2.customView = btn2

        let btn3 = UIImageView(image: UIImage(named: "three_dot"))
        btn3.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let item3 = UIBarButtonItem()
        item3.customView = btn3
        
        self.navigationItem.rightBarButtonItems = [item3, item2, item1]
                
        // Add tap gesture recognizer to btn1
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(btn1Tapped))
        btn1.isUserInteractionEnabled = true
        btn1.addGestureRecognizer(tapGesture1)

         //Add tap gesture recognizer to btn2
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(btn2Tapped))
        btn2.isUserInteractionEnabled = true
        btn2.addGestureRecognizer(tapGesture2)


    }
}

extension SetDiaryCoverViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우(편집을 사용했을 때)
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.diaryCoverImageView.image = newImage // 받아온 이미지를 update (imageView는 화면에 띄워 줄 UIImageView를 의미)
        
        self.addPhotoImageView.isHidden = true
        postCoverImg()
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
    }
    
    // 취소 버튼을 눌렀을 때 이미지 피커를 dismiss 시킴
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension SetDiaryCoverViewController: ChangeCoverAlertDelegate{
    func goToGallery() {
        let imagePicker = UIImagePickerController()

        // 모달 형식이기에, 모달 방식에서 화면 전환 스타일을 골라줄 수 있어요.
        imagePicker.modalPresentationStyle = .fullScreen

        // 앨범에서 불러올 지, 카메라를 실행할 지 골라주세요. 저는 앨범으로 했어요.
        imagePicker.sourceType = .photoLibrary

        // 이미지 피커를 다루기 위해 대리자를 채택해주세요.
        imagePicker.delegate = self

        // 사진을 찍거나 앨범에서 가져왔을 때, 해당 사진을 정방형(1:1)으로 편집을 원하면 추가해주세요.
        imagePicker.allowsEditing = true

        // 이미지 피커 실행
        present(imagePicker, animated: true)
    }
    
    
}

extension SetDiaryCoverViewController{
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func postCoverImg(){
        
        let url = "\(Constant.BASE_URL)/diarybooks/image"
        
        let resizedImage = resizeImage(image: diaryCoverImageView.image ?? UIImage(), newWidth: 345)
        
        let imageData = resizedImage.jpegData(compressionQuality: 0.7)
        
        AF.upload(
            multipartFormData: {multipartFormData in
                
                if((imageData) != nil){
                    
                    multipartFormData.append(imageData!, withName: "imageFile", fileName: "imageFile.jpeg", mimeType: "image/jpeg")
                }
            }, to: "\(url)", usingThreshold: UInt64.init(), method: .patch, headers: [ "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? "" ]).responseDecodable(of :RegisterDiaryCoverResponse.self) {
                response in
                
                switch response.result {
                    
                case .success(let response):
                    print("Success>> postCoverImg \(response) ")
                    
                case .failure(let error):
                    print("DEBUG>> postCoverImg Error : \(error.localizedDescription)")
                    
                }
            }
    }
    
    func getDiaryCover(){
        DiaryBookAPI.providerDiaryBook.request( .getDiaryCover){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(GetDiaryCoverResponse.self)
                    
                    self.diaryBookID = response.result.diarybookID
                    
                    print(response)
                    
                    if response.isSuccess == true {
                        if response.code == 1000{
                            self.addPhotoImageView.isHidden = true
                            
                            UserDefaults.standard.set(response.result.diarybookID, forKey: "diaryBookID")
                        }
                    }
                    
                    let url = URL(string: response.result.imageURL)
                    
                    self.diaryCoverImageView.kf.setImage(with: url)
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> setMailBoxName Error : \(error.localizedDescription)")
            }
        }
    }
    
    func getDiaryList(){
       
        DiaryAPI.providerDiary.request( .getDiaryList){ result in
            switch result {
            case .success(let data):
                do{
                    let response = try data.map(GetDiaryListResponse.self)
                    
                    print(response)
                    
                    if response.isSuccess == true {
                        if response.code == 1000 {
                            
                            if response.result?.isEmpty == true {
                                self.isDiaryEmpty = true
                                self.showToast(message: "아직 작성한 일기가 없어!", font: UIFont.Pretendard(.regular, size: 14))
                            }
                            else{

                                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewDiaryViewController") as? ReviewDiaryViewController else {return}
                                vc.isFromLastBtn = true
                                self.navigationController?.pushViewController(vc, animated: true)
                            }

                        }
                    }

                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print("DEBUG>> setMailBoxName Error : \(error.localizedDescription)")
            }
        }
    }
}

extension SetDiaryCoverViewController: WriteDiaryDelegate{
    func goToLastPage() {
        goToLastPageBtn.sendActions(for: .touchUpInside)
    }
}

extension SetDiaryCoverViewController{
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: diaryCoverImageView.layer.frame.origin.x, y: view.bounds.size.height - 145, width: self.view.frame.width - diaryCoverImageView.layer.frame.origin.x * 2 , height: 52))
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

class SlideLeftPushAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let toViewController = transitionContext.viewController(forKey: .to),
              let fromViewController = transitionContext.viewController(forKey: .from) else { return }
        
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toViewController.view)
        toViewController.view.frame.origin.x = containerView.frame.size.width
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            fromViewController.view.frame.origin.x = -containerView.frame.size.width
            toViewController.view.frame.origin.x = 0
        }) { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
