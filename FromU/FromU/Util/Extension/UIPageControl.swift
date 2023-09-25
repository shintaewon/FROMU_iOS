//
//  UIPageControl.swift
//  FromU
//
//  Created by 신태원 on 2023/03/19.
//

import UIKit

class CustomPageControl: UIPageControl {
    
    var dotSize: CGFloat = 8
    var activeDotSize: CGFloat = 16
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let dotSizeDifference = activeDotSize - dotSize
        let dotRadius = dotSize / 2
        let activeDotRadius = activeDotSize / 2

        for (index, subview) in subviews.enumerated() {
            let isCurrentPage = index == currentPage
            let size = isCurrentPage ? activeDotSize : dotSize
            let originX = isCurrentPage ? subview.center.x - activeDotRadius : subview.center.x - dotRadius

            subview.frame = CGRect(x: originX, y: subview.frame.origin.y, width: size, height: size)
            subview.layer.cornerRadius = size / 2
            subview.backgroundColor = isCurrentPage ? tintColor : tintColor.withAlphaComponent(0.5)
        }
    }
}
