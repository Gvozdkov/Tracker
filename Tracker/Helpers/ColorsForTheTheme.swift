import UIKit

final class ColorsForTheTheme {
    static let shared = ColorsForTheTheme()

    let buttonAction = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.101058431, green: 0.1060451791, blue: 0.1357983351, alpha: 1)
        } else {
            return #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        }
    }
    
    let buttonCreate = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        } else {
            return #colorLiteral(red: 0.101058431, green: 0.1060451791, blue: 0.1357983351, alpha: 1)
        }
    }
    
    let viewController = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        } else {
            return #colorLiteral(red: 0.1010585949, green: 0.1060450748, blue: 0.1315651834, alpha: 1)
        }
    }
    
    let searchBar = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.9372547865, green: 0.9372549653, blue: 0.9415605664, alpha: 0.12)
        } else {
            return #colorLiteral(red: 0.1873398721, green: 0.1923207045, blue: 0.2221673131, alpha: 1)
        }
    }
    
    let datePicker = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.9411764741, green: 0.9411764741, blue: 0.9411764741, alpha: 1)
        } else {
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.8470588235)
        }
    }
    
    let ButtonText = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.9411764741, green: 0.9411764741, blue: 0.9411764741, alpha: 1)
        } else {
            return #colorLiteral(red: 0.101058431, green: 0.1060451791, blue: 0.1357983351, alpha: 1)
        }
    }
    
    let textFieldText = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.101058431, green: 0.1060451791, blue: 0.1357983351, alpha: 1)
        } else {
            return #colorLiteral(red: 0.9999999404, green: 1, blue: 1, alpha: 1)
        }
    }
    
    let table = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.9001832604, green: 0.9101323485, blue: 0.9228639007, alpha: 0.3)
        } else {
            return #colorLiteral(red: 0.2549019608, green: 0.2549019608, blue: 0.2549019608, alpha: 0.85)
        }
    }
    
    let separator = UIColor { (traits: UITraitCollection) -> UIColor in
        if traits.userInterfaceStyle == .light {
            return #colorLiteral(red: 0.6814661026, green: 0.686439395, blue: 0.707844317, alpha: 1)
        } else {
            return #colorLiteral(red: 0.6814661026, green: 0.686439395, blue: 0.707844317, alpha: 1)
        }
    }
}
