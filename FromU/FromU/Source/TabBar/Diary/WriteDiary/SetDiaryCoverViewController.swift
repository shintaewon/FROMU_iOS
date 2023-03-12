//
//  SetDiaryCoverViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/08.
//

import UIKit

import Photos

class SetDiaryCoverViewController: UIViewController {

    @IBOutlet weak var diaryBackgroundView: UIImageView!
    @IBOutlet weak var diaryCoverImageView: UIImageView!
    
    @IBOutlet weak var diaryNameLabel: UILabel!
    
    @IBOutlet weak var goToLastPageBtn: UIButton!
    
    @IBOutlet weak var addPhotoImageView: UIImageView!
    
    var tapGestureRecognizer = UITapGestureRecognizer()
    
    @objc func okAction(){
        print("hi")
    }
    
    @IBAction func didTapBtn(_ sender: Any) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewDiaryViewController") as? ReviewDiaryViewController else {return}
        
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // Handle btn2 tap event
    @objc func btn2Tapped() {
        print("2")
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        PHPhotoLibrary.requestAuthorization( { status in })
        configureNavigationItems()
        
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

        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: -6, y: diaryNameLabel.frame.size.height - 1, width: diaryNameLabel.frame.size.width + 12, height: 2)
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
        print("실행은 됨?")
        
        
        let btn1 = UIImageView(image: UIImage(named: "icn_edit"))
        btn1.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let item1 = UIBarButtonItem()
        item1.customView = btn1

        let btn2 = UIImageView(image: UIImage(named: "icn_list"))
        btn2.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
        let item2 = UIBarButtonItem()
        item2.customView = btn2

    
        self.navigationItem.rightBarButtonItems = [item2, item1]
        
        // Add tap gesture recognizer to btn1
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(btn1Tapped))
        btn1.isUserInteractionEnabled = true
        btn1.addGestureRecognizer(tapGesture1)

        // Add tap gesture recognizer to btn2
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
