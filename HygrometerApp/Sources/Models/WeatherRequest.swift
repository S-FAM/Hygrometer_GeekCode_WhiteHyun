/// 날씨 정보를 가지고 오기 위한 요청 파라미터 모델입니다.
struct WeatherRequest {
    let lat: String
    let long: String
    let appID: String
    let lang: String
}
