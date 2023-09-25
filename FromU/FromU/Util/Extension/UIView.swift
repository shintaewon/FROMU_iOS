//
//  UIView.swift
//  FromU
//
//  Created by 신태원 on 2023/02/22.
//

import UIKit

extension UIView{
    func setGradient(color1:UIColor,color2:UIColor){
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [color1.cgColor,color2.cgColor]
        gradient.locations = [0.1]
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: 1, b: 1, c: -271.79, d: 57.97, tx: 135.9, ty: -28.98))
        gradient.bounds = bounds.insetBy(dx: -0.5*bounds.size.width, dy: -0.5*bounds.size.height)
        gradient.position = center
        layer.addSublayer(gradient)
    }
}
