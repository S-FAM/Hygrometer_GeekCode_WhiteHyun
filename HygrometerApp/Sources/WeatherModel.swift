//
//  WeatherModel.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/15.
//

import Foundation

struct WeatherModel: Codable {
    let main: Main
    let weather: [WeatherElement]
}

// MARK: - Main
struct Main: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity

    }
}


// MARK: - WeatherElement
struct WeatherElement: Codable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
