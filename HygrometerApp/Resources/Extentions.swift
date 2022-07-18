//
//  Extentions.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import Foundation
import UIKit

extension UIColor {
    
    static func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return self.RGBA(r: r, g: g, b: b, a: 1)
    }
    
    static func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

    
    static let themeColor = RGB(r: 60, g: 65, b: 97)

}


struct ShadowSet {
    static let whiteShadowColor = UIColor.white.cgColor
    static let shadowColor = UIColor.black.cgColor
    static let shadowOffset = CGSize(width: 0, height: 2.0)
    static let shadowRadius = 1.0
    static let shadowOpacity = Float(0.4)
    
    static let shadowOffsetWeak = CGSize(width: 0, height: 1.0)
    static let shadowOpacityWeakest = Float(0.2)
    //whiteShadow : 배경색이 연할때
    static let shadowRadiusWeakest = 5.0
    static let shadowOpacityWeak = Float(0.6)
    //배경이 있을 때
    static let shadowOffsetStrong = CGSize(width: 0, height: 0.0)
    static let shadowRadiusStrong = 10.0             //확산비율
    static let shadowOpacityStrong = Float(0.4)     //투명도
}

extension UIView {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
