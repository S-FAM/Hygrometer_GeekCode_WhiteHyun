/// 시/군/구 및 gps를 요청하기위해 필요한 파라미터 모델입니다.
struct CoordinateResponse: Codable {
    let response: CRResponse
}
// MARK: - Response
struct CRResponse: Codable {
    let result: [CRResult]
}

struct CRResult: Codable {
    let structure: CRStructure
}


struct CRStructure: Codable {
    /// 시/도
    let country: String
    
    /// 시/군/구
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case country = "level1"
        case city = "level2"
    }
}
