//
//  DiaryCollectionViewCell.swift
//  FromU
//
//  Created by 신태원 on 2023/03/12.
//

import UIKit

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
    
    
}
