import Foundation

extension Date {
    func removeTimeStamp() -> Date? {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        return calendar.date(from: dateComponents)
    }
}
