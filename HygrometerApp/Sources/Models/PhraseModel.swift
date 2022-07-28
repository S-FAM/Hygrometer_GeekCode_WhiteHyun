import Foundation


/// 습도에 따른 문구를 보여주기 위한 모델
enum PhraseModel {
    case dry
    case normal
    case humid
    
    var phrase: [String] {
        switch self {
        case .dry:
            return ["물을 많이 마시는 게 좋아요", "알로에 사오셨나요? 피부에 양보하세요", "목을 축이세요", "오아시스 있나요?"]
        case .normal:
            return ["오늘은 적당하네요"]
        case .humid:
            return ["너무 습하네요. 제습제가 필요해요", "비왔었나요? 물먹는 하마가 그립네요"]
        }
    }
}
