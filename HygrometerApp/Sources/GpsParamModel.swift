//
//  AfParamModel.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/15.
//

import Foundation

struct GpsParamModel: Codable {
  let key, query, request, type, category: String
}

struct WeatherParamModel: Codable {
    let lat, long, appid, lang: String
}
