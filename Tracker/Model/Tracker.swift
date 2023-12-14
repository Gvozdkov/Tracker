import UIKit

struct Tracker: Identifiable {
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
    case thurshday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
    case sunday = "Воскресенье"
    
    var shortForm: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thurshday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
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

//extension Weekday {
//    func toDate() -> Date? {
//        let inputWeekday = self.rawValue
//        let formatter = DateFormatter()
//        formatter.locale = Locale(identifier: "ru_RU")
//        formatter.dateFormat = "EEEE"
//        guard let date = formatter.date(from: inputWeekday) else {
//            return nil
//        }
//        let currentWeekday = Calendar.current.component(.weekday, from: Date())
//        let inputWeekdayIndex = Calendar.current.component(.weekday, from: date)
//        let difference = inputWeekdayIndex - currentWeekday
//        return Calendar.current.date(byAdding: .day, value: difference, to: Date())
//    }
//}
