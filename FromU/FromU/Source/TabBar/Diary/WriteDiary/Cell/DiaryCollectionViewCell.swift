//
//  DiaryCollectionViewCell.swift
//  FromU
//
//  Created by 신태원 on 2023/03/12.
//

import UIKit

import Kingfisher

class DiaryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var dateView: UIView!
    
    @IBOutlet weak var icn_sun: UIImageView!
    @IBOutlet weak var icn_spark: UIImageView!
    @IBOutlet weak var icn_rain: UIImageView!
    
    @IBOutlet weak var redcircleSun: UIImageView!
    @IBOutlet weak var redcircleSpark: UIImageView!
    @IBOutlet weak var redcircleRain: UIImageView!
    
    
    @IBOutlet weak var diaryImageView: UIImageView!
    
    
    @IBOutlet weak var diaryContentLabel: UILabel!
    
    @IBOutlet weak var writterLabel: UILabel!
    
    func update(with data: GetDiaryResponse) {
        
        dateView.layer.borderWidth = 1
        dateView.layer.cornerRadius = 8
        dateView.layer.borderColor = UIColor(hex: 0xC1C1C1).cgColor
        
        let dayOfWeek = data.result?.day ?? 1
        let dayOfWeekString: String
        switch dayOfWeek {
        case 1:
            dayOfWeekString = "월요일"
        case 2:
            dayOfWeekString = "화요일"
        case 3:
            dayOfWeekString = "수요일"
        case 4:
            dayOfWeekString = "목요일"
        case 5:
            dayOfWeekString = "금요일"
        case 6:
            dayOfWeekString = "토요일"
        case 7:
            dayOfWeekString = "일요일"
        default:
            dayOfWeekString = ""
        }

        let inputDateString = data.result?.date ?? ""
        let month = String(inputDateString.prefix(6)).suffix(2)
        let day = String(inputDateString.suffix(2))

        let outputDateString = "\(Int(month) ?? 0)월   \(Int(day) ?? 0)일   \(dayOfWeekString)"
        print(outputDateString) // Output: "3월 14일 월요일"
        
        dateLabel.text = outputDateString
        
        if data.result?.weather == "sunny"{
            redcircleSun.isHidden = false
            redcircleSpark.isHidden = true
            redcircleRain.isHidden = true
        }
        else if data.result?.weather == "cloud"{
            redcircleSun.isHidden = true
            redcircleRain.isHidden = true
            redcircleSpark.isHidden = false
        }
        else{
            redcircleSun.isHidden = true
            redcircleSpark.isHidden = true
            redcircleRain.isHidden = false
        }
        
        let url = URL(string: data.result?.imageURL ?? "")
        
        let processor = RoundCornerImageProcessor(cornerRadius: 8)
        
        diaryImageView.kf.setImage(with: url, options: [.processor(processor)])
        
        diaryContentLabel.font = UIFont.Cafe24SsurroundAir(.Cafe24SsurroundAir, size: 16)

        diaryContentLabel.lineBreakMode = .byWordWrapping

        var paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineHeightMultiple = 1.27

        diaryContentLabel.attributedText = NSMutableAttributedString(string: (data.result?.content ?? "") + "\n", attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
        
        
        writterLabel.text = "From. \(data.result?.writerNickname ?? "")의 기록"
        
        // ...
    }
    
}
