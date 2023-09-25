//
//  UIViewController.swift
//  FromU
//
//  Created by 신태원 on 2023/02/24.
//

import UIKit

extension UIViewController {
    // MARK: 빈 화면을 눌렀을 때 키보드가 내려가도록 처리
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboardWithChangeBoarderColorWhenTappedAround() {
        let tap: UITapGestureRecognizer =
        UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        //        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    // MARK: 인디케이터 표시
    func showIndicator() {
        IndicatorView.shared.show()
        IndicatorView.shared.showIndicator()
    }
    
    // MARK: 인디케이터 숨김
    @objc func dismissIndicator() {
        IndicatorView.shared.dismiss()
    }
    
    // MARK: - 우측에서 좌측으로 슬라이드되며 self.dismiss
    
    func disMissLeftToRight() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window!.layer.add(transition, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    func convertDate(from originalString: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")  // 서버로부터 받은 날짜 형식이 고정되어 있다면 이 Locale을 설정합니다.

        if let date = inputFormatter.date(from: originalString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy. MM. dd a h:mm"
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}
