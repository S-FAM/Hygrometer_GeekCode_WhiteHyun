//
//  API.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/11.
//

import Combine
import Foundation

import Alamofire

public struct API {
    
    private init() {}
    
    static public func makeString(with stringArray: [String]) -> String {
        var fullStr: String = ""
        for str in stringArray {
            fullStr += str
        }
        return fullStr
    }
    
    /// 도시 정보를 가져올 때 사용합니다.
    /// - Parameters:
    ///   - model: URL 요청에 사용할 URL 변환 가능 값
    ///   - completion: 요청이 완료되면 실행되는 클로저
    static func cityInformation(with model: GpsRequest, completion: @escaping (Result<GpsResponse, AFError>) -> Void) {
        AF
            .request(ApiType.gps.host, method: .get, parameters: model)
            .responseDecodable(of: GpsResponse.self) {
                completion($0.result)
            }
            .resume()
    }
    
    /// 날씨에 대한 정보를 가져올 때 사용합니다.
    /// - Parameters:
    ///   - model: URL 요청에 사용할 URL 변환 가능 값
    ///   - completion: 요청이 완료되면 실행되는 클로저
    static func weatherInformation(with model: WeatherRequest, completion: @escaping (Result<WeatherResponse, AFError>) -> Void) {
        AF
            .request(ApiType.weather.host, method: .get, parameters: model)
            .responseDecodable(of: WeatherResponse.self) {
                completion($0.result)
            }
            .resume()
    }
    
    static func cityName(with model: CoordinateRequest, completion: @escaping (Result<CoordinateResponse, AFError>) -> Void) {
        AF
            .request(ApiType.coordinate.host, method: .get, parameters: model)
            .responseDecodable(of: CoordinateResponse.self) {
                completion($0.result)
            }
            .resume()
    }
}

enum ApiType {
    case gps
    case weather
    case coordinate
    
    init() {
        self = .gps
    }
    
    var host: String {
        switch self {
        case .gps: return "https://api.vworld.kr/req/search?"
        case .coordinate: return "https://api.vworld.kr/req/address?service=address&request=getAddress&type=both&simple=true&zipcode=false&"
        case .weather: return "https://api.openweathermap.org/data/2.5/weather?"
        }
    }
}
