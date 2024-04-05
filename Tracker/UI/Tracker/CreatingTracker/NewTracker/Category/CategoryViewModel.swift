import Foundation

typealias Binding<T> = (T) -> Void

class CategoryViewModel {
    let model: CategoryModel
    var updateUserCategory: Binding<[String]>?
    var updateSelectCategory: Binding<String>?
    
    init(model: CategoryModel) {
        self.model = model
        
        self.model.updateUserCategory = { [weak self] userCategory in
            self?.updateUserCategory?(userCategory)
        }
        
        self.model.updateSelectCategory = { [weak self] selectCategory in
            self?.updateSelectCategory?(selectCategory)
        }
    }
    
    func updateUserCategoryTableView() {
        model.fetchAllTrackerCategory()
    }
}
