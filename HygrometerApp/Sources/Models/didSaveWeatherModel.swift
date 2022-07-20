//
//  didSaveWeatherModel.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/15.
//

import Foundation

struct didSaveWeatherModel {
    var location: String = ""       // 지역이름
    var lat: String = ""            // 위도
    var long: String = ""           // 경도
    var humidity: String = ""       // 습도
    var temp: Double = 0            // 기온
    var tempMin:Double = 0          // 최저기온
    var tempMax: Double = 0         // 최고기온
    var id: Int = 0                 // 태그로 사용할 id값
    var main: String = ""           // 날씨 애니메이션에 사용할 구분자
}
