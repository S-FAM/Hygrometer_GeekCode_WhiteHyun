//
//  ShadowSet.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/17.
//

import UIKit

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
