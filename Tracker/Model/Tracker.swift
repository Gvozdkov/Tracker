import UIKit

struct Tracker: Hashable {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [Weekday]?
}

enum Weekday: String, CaseIterable, Comparable, Encodable, Decodable {
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var shortForm: String {
        switch self {
        case .monday: return LocalizableKeys.mon
        case .tuesday: return LocalizableKeys.tue
        case .wednesday: return LocalizableKeys.wed
        case .thursday: return LocalizableKeys.thu
        case .friday: return LocalizableKeys.fri
        case .saturday: return LocalizableKeys.sat
        case .sunday: return LocalizableKeys.sun
        }
    }
    
    static func < (lhs: Weekday, rhs: Weekday) -> Bool {
        guard
            let first = Self.allCases.firstIndex(of: lhs),
            let second = Self.allCases.firstIndex(of: rhs)
        else { return false }
        
        return first < second
    }
}
