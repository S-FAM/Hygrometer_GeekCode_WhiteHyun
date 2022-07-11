// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherModel = try? newJSONDecoder().decode(WeatherModel.self, from: jsonData)

import Foundation

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let service: Service
    let status: String
    let record: Record
    let page: Page
    let result: Result
}

// MARK: - Page
struct Page: Codable {
    let total, current, size: String
}

// MARK: - Record
struct Record: Codable {
    let total, current: String
}

// MARK: - Result
struct Result: Codable {
    let crs, type: String
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id, title: String
    let geometry: String
    let point: Point
}

// MARK: - Point
struct Point: Codable {
    let x, y: String
}

// MARK: - Service
struct Service: Codable {
    let name, version, operation, time: String
}
