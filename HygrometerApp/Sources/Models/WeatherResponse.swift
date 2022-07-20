/// OpenWeatherAPI 응답모델입니다.
struct WeatherResponse: Codable {
    let main: Main
    let weather: [WeatherElement]
}


struct Main: Codable {
    
    /// 온도
    let temp: Double
    
    /// 최저 온도
    let tempMin: Double
    
    /// 최고온도
    let tempMax: Double
    
    /// 기압
    let pressure: Int
    
    /// 습도
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

struct WeatherElement: Codable {
    
    /// 날씨 상태 ID
    let id: Int
    
    /// 현재 날씨 정보
    let main: String
    
    /// 현재 날씨 내용
    let weatherDescription: String
    
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
