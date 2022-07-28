/// 시/군/구 및 gps를 요청하기위해 필요한 파라미터 모델입니다.
struct CoordinateRequest: Codable {
    
    /// API Key
    let key: String
    
    /// 주소를 찾을 좌표
    let point: String
    
    init(key: String, point: String) {
        self.key = key
        self.point = point
    }
    
    init(key: String, point: Point) {
        self.init(key: key, point: "\(point.x)\(point.y)")
    }
}
