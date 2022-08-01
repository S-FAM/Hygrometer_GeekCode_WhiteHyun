import UIKit

extension UIImage {
    static func backgroundImage(with humidity: PhraseModel) -> UIImage? {
        switch humidity {
        case .dry:
            return UIImage(named: "dry")
        case .normal:
            return UIImage(named: "normal")
        case .humid:
            return UIImage(named: "humid")
        }
    }
}
