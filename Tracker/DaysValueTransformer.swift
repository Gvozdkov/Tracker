import UIKit

class YourEntity {
    @objc dynamic var color: UIColor?
}

@objc
final class DaysValueTransformer: ValueTransformer {
    override class func transformedValueClass() -> AnyClass { NSData.self }
    override class func allowsReverseTransformation() -> Bool { true }
    
    override func transformedValue(_ value: Any?) -> Any? {
        guard let days = value as? [Weekday] else { return nil }
        return try? JSONEncoder().encode(days)
    }
    
    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? NSData else { return nil }
        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
    }
}

extension DaysValueTransformer {
    static func register() {
        ValueTransformer.setValueTransformer(
            DaysValueTransformer(),
            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
        )
    }
}

//@objc
//final class DaysValueTransformer: ValueTransformer {
//    override class func transformedValueClass() -> AnyClass {
//        return NSData.self
//    }
//
//    override class func allowsReverseTransformation() -> Bool {
//        return true
//    }
//
//    override func transformedValue(_ value: Any?) -> Any? {
//        guard let days = value as? [Weekday] else { return nil }
//        return try? JSONEncoder().encode(days)
//    }
//
//    override func reverseTransformedValue(_ value: Any?) -> Any? {
//        guard let data = value as? NSData else { return nil }
//        return try? JSONDecoder().decode([Weekday].self, from: data as Data)
//    }
//}
//
//extension DaysValueTransformer {
//    static func register() {
//        ValueTransformer.setValueTransformer(
//            DaysValueTransformer(),
//            forName: NSValueTransformerName(rawValue: String(describing: DaysValueTransformer.self))
//        )
//    }
//}
