//
//  WriteDiaryViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/03/11.
//
import UIKit

import Alamofire
import SwiftKeychainWrapper

protocol WriteDiaryDelegate: AnyObject{
    
    func goToLastPage()
}

class WriteDiaryViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var diaryImageView: UIImageView!
    
    @IBOutlet weak var addPhotoImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var imageViewSun: UIImageView!
    
    @IBOutlet weak var imageViewSpark: UIImageView!
    
    @IBOutlet weak var imageViewRain: UIImageView!
    
    @IBOutlet weak var redCircle_sun: UIImageView!
    
    @IBOutlet weak var redCircle_spark: UIImageView!
    
    @IBOutlet weak var redCircle_rain: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    weak var delegate: WriteDiaryDelegate?
    
    var emotionWeather = ""
    
    @objc func presentImagePicker() {
        
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
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height + 230
            }
        }
        if textView.text == "" {
            navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: 0x999999)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        else{
            updateRightBarButtonItemColor()
        }
    }
    
    @objc private func keyboardWillChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {
            return
        }

        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets

        // Get the active text view and scroll the scroll view to show it
        let activeTextViewFrame = textView.convert(textView.bounds, to: scrollView)
        scrollView.scrollRectToVisible(activeTextViewFrame, animated: true)

        // Calculate the content offset to scroll the screen down
        let contentOffset = CGPoint(x: 0, y: activeTextViewFrame.maxY - scrollView.bounds.height + keyboardHeight)
        scrollView.setContentOffset(contentOffset, animated: true)

        let animationCurve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? UIView.AnimationOptions.curveEaseInOut.rawValue
        UIView.animate(withDuration: duration, delay: 0, options: UIView.AnimationOptions(rawValue: animationCurve), animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            if keyboardFrame.minY >= self.view.bounds.height {
                // Keyboard is dismissed, restore scroll view insets and content offset
                self.scrollView.contentInset = .zero
                self.scrollView.scrollIndicatorInsets = .zero
                self.scrollView.setContentOffset(.zero, animated: true)
            }
        })
    }
    
    @objc func didTapSun(){
        print("didTapSun")
        redCircle_sun.isHidden = false
        redCircle_spark.isHidden = true
        redCircle_rain.isHidden = true
        emotionWeather = "SUNNY"
        updateRightBarButtonItemColor()
    }
    
    @objc func didTapSpark(){
        redCircle_sun.isHidden = true
        redCircle_spark.isHidden = false
        redCircle_rain.isHidden = true
        emotionWeather = "CLOUD"
        updateRightBarButtonItemColor()
    }
    
    @objc func didTapRain(){
        redCircle_sun.isHidden = true
        redCircle_spark.isHidden = true
        redCircle_rain.isHidden = false
        emotionWeather = "RAINY"
        updateRightBarButtonItemColor()
    }
    
    @objc func doneTapped() {
        // Handle the "완료" button tap
        print("완료 button tapped")
        let image = diaryImageView.image ?? UIImage()
        
        sendRequest(image: image, content: textView.text, weather: emotionWeather)
        
    }

    func updateRightBarButtonItemColor() {
        // Check if the text view and image view are not empty, and if the button is pressed at least once
        if textView.textColor != UIColor.placeholderText && diaryImageView.image != nil && emotionWeather != "" {
            // Set the tintColor of the right bar button item to a custom color
            navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: 0xA735FF)
            navigationItem.rightBarButtonItem?.isEnabled = true
        } else {
            // Reset the tintColor of the right bar button item to the default color
            navigationItem.rightBarButtonItem?.tintColor = UIColor(hex: 0x999999)
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redCircle_sun.isHidden = true
        redCircle_spark.isHidden = true
        redCircle_rain.isHidden = true
        
        
        
        dismissKeyboardWhenTappedAround()
        
        textView.delegate = self
        textView.text = "내용을 입력해주세요"
        textView.textColor = UIColor.placeholderText
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        
        diaryImageView.layer.borderWidth = 1
        diaryImageView.layer.borderColor = UIColor(hex: 0xC1C1C1).cgColor
        diaryImageView.layer.cornerRadius = 8
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(presentImagePicker))
        
        diaryImageView.addGestureRecognizer(tapGestureRecognizer)
        
        textView.isScrollEnabled = false
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = .zero
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        let constraint = textView.heightAnchor.constraint(equalToConstant: 230)
        constraint.isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        dateView.layer.borderColor = UIColor(hex: 0xC1C1C1).cgColor
        dateView.layer.borderWidth = 1
        
        dateView.layer.cornerRadius = 8
        
        // Create date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMddEEEE")
        
        // Get current date and format it
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        
        let components = dateString.components(separatedBy: " ")
        let spacedComponents = components.map { $0 + "   " }

        let spacedString = spacedComponents.joined()
        

        print(spacedString)
        // Set label text to formatted date
        dateLabel.text = spacedString
        
        let tapGestureSun = UITapGestureRecognizer(target: self, action: #selector(didTapSun))
        
        imageViewSun.addGestureRecognizer(tapGestureSun)
        
        let tapGestureSpark = UITapGestureRecognizer(target: self, action: #selector(didTapSpark))
        
        imageViewSpark.addGestureRecognizer(tapGestureSpark)
        
        let tapGestureRain = UITapGestureRecognizer(target: self, action: #selector(didTapRain))
        
        imageViewRain.addGestureRecognizer(tapGestureRain)
        
    
        // Create a UIBarButtonItem with the "완료" title and the "done" action
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneTapped))
        
        doneButton.tintColor = UIColor(hex: 0x999999)
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        doneButton.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 13)], for: [.normal, .disabled, .selected])


        
        // Set the rightBarButtonItem of the navigationItem to the doneButton
        navigationItem.rightBarButtonItem = doneButton
   
    }
}

extension WriteDiaryViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
        var newImage: UIImage? = nil // update 할 이미지
        
        if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            newImage = possibleImage // 수정된 이미지가 있을 경우(편집을 사용했을 때)
        } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            newImage = possibleImage // 원본 이미지가 있을 경우
        }
        
        self.diaryImageView.image = newImage // 받아온 이미지를 update (imageView는 화면에 띄워 줄 UIImageView를 의미)
        updateRightBarButtonItemColor()
        self.addPhotoImageView.isHidden = true
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
    }
    
    // 취소 버튼을 눌렀을 때 이미지 피커를 dismiss 시킴
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension WriteDiaryViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Get the current text of the text view
        guard let currentText = textView.text else { return true }
        
        // Get the new text after the user types
        let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        // Restrict the maximum length to 200 characters
        let maxLength = 200
        if newText.count > maxLength {
            return false
        }
        
        // Update the character count string
        let countString = "\(newText.count)/\(maxLength)"
        
        countLabel.text = countString
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      if textView.textColor == UIColor.placeholderText {
        textView.text = nil
        textView.textColor = UIColor.black
      }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
      if textView.text.isEmpty {
          textView.text = "내용을 입력해주세요."
          textView.textColor = UIColor.placeholderText
      }
    }
}

extension WriteDiaryViewController{
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width // 새 이미지 확대/축소 비율
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.draw(in: CGRectMake(0, 0, newWidth, newHeight))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func sendRequest(image: UIImage, content: String, weather: String) {
        let url = "\(Constant.BASE_URL)/diaries" // Replace with your server's URL
        let postDiaryReq: [String: String] = [
            "content": content,
            "weather": weather
        ]
        let header : HTTPHeaders = [
            "X-ACCESS-TOKEN" : KeychainWrapper.standard.string(forKey: "X-ACCESS-TOKEN") ?? ""
        ]
     
        let imageData = image.jpegData(compressionQuality: 0.7)
        
        AF.upload(multipartFormData: { multipartFormData in
            // Append the image data
            if let imageData = imageData {
                multipartFormData.append(imageData, withName: "imageFile", fileName: "image.jpeg", mimeType: "image/jpeg")
            }
            
            // Append the postDiaryReq object as JSON string
            if let postData = try? JSONSerialization.data(withJSONObject: postDiaryReq, options: []) {
                multipartFormData.append(postData, withName: "postDiaryReq", mimeType: "application/json")
            }
            
        }, to: "\(url)", method: .post, headers: header).responseDecodable(of :WriteDirayResponse.self) {
            response in
            
            switch response.result {
                
            case .success(let response):
                print("Success>> postCoverImg \(response) ")
                
                if response.isSuccess == true{
                    if response.code == 1000 { //제대로 업로드 완료
                        self.navigationController?.popViewController(animated: true)
                        self.delegate?.goToLastPage()
                    }
                    else if response.code == 2032{
                        //나중에 처리 -> 이미 편지 썼는데 또 쓰는거..
                    }
                }
                
                
            case .failure(let error):
                print("DEBUG>> sendRequest Error : \(error.localizedDescription)")
                
            }
        }
}
}
