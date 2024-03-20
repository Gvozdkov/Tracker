import Foundation

class ScheduleConverter {
   static func convertToString(array: [Weekday]?) -> String {
        let stringArray = array?.map { $0.rawValue } ?? []
        return stringArray.joined(separator: ", ")
    }
    
    static func convertToArray(string: String) -> [Weekday]? {
        let array = string.components(separatedBy: ", ")
        return array.compactMap { Weekday(rawValue: String($0)) }
    }
}
