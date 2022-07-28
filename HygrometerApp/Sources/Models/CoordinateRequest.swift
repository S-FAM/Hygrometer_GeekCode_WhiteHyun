/// 좌표계로 도시명을 요청할 때 사용하는 모델입니다.
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
