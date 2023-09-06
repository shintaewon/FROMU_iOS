//
//  UIColor.swift
//  FromU
//
//  Created by 신태원 on 2023/02/24.
//

import UIKit

extension UIColor {
    // MARK: hex code를 이용하여 정의
    // ex. UIColor(hex: 0xF5663F)
    convenience init(hex: UInt, alpha: CGFloat = 1.0) {
        self.init(
            red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(hex & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
    
    // MARK: 메인 테마 색 또는 자주 쓰는 색을 정의
    // ex. label.textColor = .mainOrange
    static var primary01: UIColor {
        return UIColor(hex:0xC983FF)
    }
    
    static var primary02: UIColor {
        return UIColor(hex:0xA735FF)
    }
    
    static var primaryLight: UIColor {
        return UIColor(hex:0xE2DBFF)
    }
    
    static var disabled: UIColor {
        return UIColor(hex:0xDEDEE2)
    }
    
    static var disabledText: UIColor {
        return UIColor(hex:0x999999)
    }
    
    static var icon: UIColor {
        return UIColor(hex:0x6F6F6F)
    }
    
    static var error: UIColor {
        return UIColor(hex:0xFF4A6B)
    }
  
    static var gray06: UIColor {
        return UIColor(hex:0x7D7D7D)
    }
    
    static var highlight: UIColor {
        return UIColor(hex:0xEBD0FF)
    }
}
