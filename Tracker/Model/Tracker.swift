import UIKit

struct Tracker: Hashable {
    let id: UUID
    let name: String
    let emoji: String
    let color: UIColor
    let schedule: [Weekday]?
    let isPin: Bool
    
    init(
            id: UUID,
             name:  String,
             emoji: String,
             color: UIColor,
             schedule: [Weekday]?,
             isPin: Bool
        ){
            self.id = id
            self.name = name
            self.emoji = emoji
            self.color = color
            self.schedule = schedule
            self.isPin = isPin
        }

        init(tracker: Tracker, isPinned: Bool){
            id = tracker.id
            name = tracker.name
            emoji = tracker.emoji
            color = tracker.color
            schedule = tracker.schedule
            self.isPin = isPinned
        }
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
    
    var index: Int {
        switch self {
        case .monday: return 0
        case .tuesday: return 1
        case .wednesday: return 2
        case .thursday: return 3
        case .friday: return 4
        case .saturday: return 5
        case .sunday: return 6
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
