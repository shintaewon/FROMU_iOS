//
//  UIFont.swift
//  FromU
//
//  Created by 신태원 on 2023/02/28.
//

import UIKit

extension UIFont {
    public enum PretendardType: String {
        case black = "Black"
        case bold = "Bold"
        case extraBold = "ExtraBold"
        case extraLight = "ExtraLight"
        case light = "Light"
        case medium = "Medium"
        case regular = "Regular"
        case semiBold = "SemiBold"
        case thin = "Thin"
    }

    static func Pretendard(_ type: PretendardType, size: CGFloat) -> UIFont {
        return UIFont(name: "Pretendard-\(type.rawValue)", size: size)!
    }
    
    public enum EF_DiaryType: String {
        case EF_Diary = "EF_Diary"
    }
    
    static func EF_Diary(_ type: EF_DiaryType, size: CGFloat) -> UIFont {
        return UIFont(name: "\(type.rawValue)", size: size)!
    }
    
    public enum Cafe24SsurroundAirType: String {
        case Cafe24SsurroundAir = "Cafe24SsurroundAir"
    }
    
    static func Cafe24SsurroundAir(_ type: Cafe24SsurroundAirType, size: CGFloat) -> UIFont {
        return UIFont(name: "\(type.rawValue)", size: size)!
    }
    
    public enum BalsamTintSize: CGFloat {
        case size14 = 14
        case size16 = 16
        case size18 = 18
        case size20 = 20
        case size22 = 22
    }

    static func BalsamTint(_ size: BalsamTintSize) -> UIFont {
        return UIFont(name: "777Balsamtint", size: size.rawValue)!
    }
    
    
}
