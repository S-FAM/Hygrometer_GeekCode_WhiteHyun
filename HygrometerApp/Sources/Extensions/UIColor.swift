import UIKit

extension UIColor {
    
    static func RGB(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return self.RGBA(r: r, g: g, b: b, a: 1)
    }
    
    static func RGBA(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) -> UIColor {
        return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
    }

    static let themeColor = RGB(r: 60, g: 65, b: 97)
}
