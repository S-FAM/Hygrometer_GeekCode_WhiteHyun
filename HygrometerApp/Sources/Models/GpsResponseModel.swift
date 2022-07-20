/// 주소와 주소에 대한 세부정보를 가지고 있는 모델입니다.
struct GpsResponseModel: Codable {
    let response: Response
}

struct Response: Codable {

    /// 응답 처리 결과의 상태 표시, `OK`: 성공, `NOT_FOUND`: 결과 없음, `ERROR`: 에러
    let status: String
    let page: Page
    let result: Items
}

/// 응답 메시지의 items가 몇 페이지에 속하는지를 나타내는 `응답구조체`입니다.
struct Page: Codable {
    
    /// 검색되는 총 페이지 수
    let total: String

    /// 현재 페이지 위치
    let current: String
}

struct Items: Codable {
    let items: [Item]
}

struct Item: Codable {
    let id: String
    let city: String
    let point: Point

    enum CodingKeys: String, CodingKey {
        case id
        case point
        case city = "title"
    }
}

struct Point: Codable {
    let x: String
    let y: String
}
