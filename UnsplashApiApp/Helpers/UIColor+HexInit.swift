import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        let hexString = hexString
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")
        
        var rgbValue: UInt32 = 0
        guard Scanner(string: hexString).scanHexInt32(&rgbValue) else {
            return nil
        }
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // Check if the color is light or dark, as defined by the injected lightness threshold.
    // Some people report that 0.7 is best.
    // A false value is returned if the lightness couldn't be determined.
    func isLight(threshold: CGFloat = 0.5) -> Bool {
        var brightness: CGFloat = 0.0
        self.getHue(nil, saturation: nil, brightness: &brightness, alpha: nil)
        return (brightness > threshold)
    }
}
