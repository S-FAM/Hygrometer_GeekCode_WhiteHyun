import Foundation


/// 시/군/구 및 gps를 요청하기위해 필요한 파라미터 모델입니다.
struct GpsRequest: Codable {
    
    /// API Key
    let key: String
    
    /// 검색 쿼리
    let query: String
    
    /// 요청 서비스 오퍼레이션, 유효값은 search 하나밖에 없다.
    let request: String
    
    /// 검색 대상
    /// `place`: 장소, `address`: 주소, `district`: 행정구역, `road`: 도로명
    let type: String
    
    /// 검색 대상 하위 유형
    /// `L1`: 시/도, `L2`: 시/군/구, `L3`: 일반구, `L4`: 읍면동
    let category: String
}
