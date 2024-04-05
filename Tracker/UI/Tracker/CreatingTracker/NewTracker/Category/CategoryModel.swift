import Foundation

final class CategoryModel {
    private let trackerCategoryStore = TrackerCategoryStore()
   
    var updateUserCategory: Binding<[String]>?
    var updateSelectCategory: Binding<String>?
    
    var userCategory: [String] = [] {
        didSet {
            updateUserCategory?(userCategory)
        }
    }
    
    var selectCategory: String = "" {
        didSet {
            updateSelectCategory?(selectCategory)
        }
    }
    
    func fetchAllTrackerCategory() {
        do {
            userCategory = []
            if let fetchedUserCategory = try trackerCategoryStore.fetchAllTrackerCategory() {
                userCategory = fetchedUserCategory.map { $0.toCategory() }
            }
        } catch {
            print("Ошибка при извлечении данных категории: \(error.localizedDescription)")
        }
    }
    
    func addNewTrackerCategory(_ category: String?) {
        if let category = category {
            userCategory.append(category)
            do {
                try trackerCategoryStore.addNewTrackerCategory(category)
                print("Добавлена новая категория core data \(category)")
            } catch {
                print("Ошибка добавления в core data новой категории \(error.localizedDescription)")
            }
        }
    }
}
