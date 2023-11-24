import Foundation

final class UserCategorys {
    private enum CategorysKeys: String {
        case userCategory
    }
    
    static var userCategory: [String]? {
        get {
            return UserDefaults.standard.stringArray(forKey: CategorysKeys.userCategory.rawValue)
        } set {
            let defaults = UserDefaults.standard
            let key = CategorysKeys.userCategory.rawValue
            if let names = newValue {
                print("value: \(names) was added to key \(key)")
                defaults.set(names, forKey: key)
            } else {
                defaults.removeObject(forKey: key)
                defaults.synchronize()
            }
        }
    }
}
