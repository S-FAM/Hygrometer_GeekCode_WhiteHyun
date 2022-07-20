@available(iOS, deprecated, renamed: "GpsRequestModel")
struct GpsParamModel: Codable {
  let key, query, request, type, category: String
}

struct WeatherParamModel: Codable {
    let lat, long, appid, lang: String
}
