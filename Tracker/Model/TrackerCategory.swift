import UIKit

struct TrackerCategory {
    let name: String
    let trackers: [Tracker]
}

//private var data = [TrackerCategory]()
//
//extension TrackerViewController: NewHabitDelegate {
//    func newTracker(title: String, name: String, emoji: String, color: UIColor, weekday: [Weekday]?) {
//        
//        let header = title
//        var newTracker = Tracker(
//            id: UUID(),
//            name: name,
//            emoji: emoji,
//            color: color,
//            schedule: weekday
//        )
//        var updatedTracker = [Tracker]()
//
//        
//        var category = TrackerCategory(
//            name: header,
//            trackers: updatedTracker
//        )
//  
//        if let existingCategoryIndex = data.firstIndex(where: { $0.name == header }) {
//            var oldTracker = data[existingCategoryIndex] // Получаем существующую категорию по
//            updatedTracker.append(oldTracker)
//            updatedTracker.append(newTracker)
//            data[existingCategoryIndex] = updatedTracker // Обновляем существующую категорию в массиве
//        } else {
//            let newCategory = TrackerCategory(name: header, trackers: [tracker])
//            data.append(newCategory)
//        }
//        saveTrackers.append((date: Date(), category))
//        trackerCollection.reloadData()
//        dismiss(animated: true)
//    }
//}

