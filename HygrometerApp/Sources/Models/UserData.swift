import Foundation

struct UserDataModel: Codable {
    let id: String
    let city: String
    let point: Point
}

class UserData {
    
    private init() {}
    
    static let shared = UserData()
    
    /// 사용자가 저장해둔 도시 리스트
    var items: [UserDataModel] {
        get {
            var modelArray: [UserDataModel]?
            if let data = UserDefaults.standard.data(forKey: "userData") {
                modelArray = try? PropertyListDecoder().decode([UserDataModel].self, from: data)
            }
            return modelArray ?? []
        }
        set {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: "userData")
        }
    }
}
