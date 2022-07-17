//
//  GpsModel.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/15.
//

// MARK: - GpsModel
struct GpsModel: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
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
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let id, title: String
    let point: Point
}

// MARK: - Point
struct Point: Codable {
    let x, y: String
}
