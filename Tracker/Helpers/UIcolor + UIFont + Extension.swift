import UIKit

extension UIColor {
    static var blue: UIColor { UIColor(named: "Blue") ?? UIColor.red }
    static var gray: UIColor { UIColor(named: "Gray") ?? UIColor.gray }
    static var lightGray: UIColor { UIColor(named: "LightGray") ?? UIColor.lightGray }
    static var red: UIColor { UIColor(named: "Red") ?? UIColor.red }

    static let colorSelection: [UIColor] = [
        UIColor(named: "Color selection 1") ?? .red,
        UIColor(named: "Color selection 2") ?? .orange,
        UIColor(named: "Color selection 3") ?? .blue,
        UIColor(named: "Color selection 4") ?? .purple,
        UIColor(named: "Color selection 5") ?? .green,
        UIColor(named: "Color selection 6") ?? .systemPink,
        UIColor(named: "Color selection 7") ?? .systemPink,
        UIColor(named: "Color selection 8") ?? .blue,
        UIColor(named: "Color selection 9") ?? .green,
        UIColor(named: "Color selection 10") ?? .purple,
        UIColor(named: "Color selection 11") ?? .red,
        UIColor(named: "Color selection 12") ?? .systemPink,
        UIColor(named: "Color selection 13") ?? .orange,
        UIColor(named: "Color selection 14") ?? .blue,
        UIColor(named: "Color selection 15") ?? .purple,
        UIColor(named: "Color selection 16") ?? .systemPurple,
        UIColor(named: "Color selection 17") ?? .systemPurple,
        UIColor(named: "Color selection 18") ?? .green
    ]
}

extension UIFont {
    static let bold34 = UIFont.systemFont(ofSize: 34, weight: .bold)
    static let bold32 = UIFont.systemFont(ofSize: 32, weight: .bold)
    static let bold19 = UIFont.systemFont(ofSize: 19, weight: .bold)
    static let regular17 = UIFont.systemFont(ofSize: 17, weight: .regular)
    static let medium16 = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let medium12 = UIFont.systemFont(ofSize: 12, weight: .medium)
    static let medium10 = UIFont.systemFont(ofSize: 10, weight: .medium)
}
