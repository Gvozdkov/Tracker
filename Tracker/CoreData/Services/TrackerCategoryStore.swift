import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func trackerCategoryStore(didUpdate update: TrackerCategoryStoreUpdate)
}

class TrackerCategoryStore: NSObject {
    
    weak var delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>
    
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    
    convenience override init() {
        guard let application = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("не удалось получить application в TrackerCategory")
        }
        let context = application.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.name, ascending: true)
        ]
        let controller = NSFetchedResultsController(fetchRequest: request,
                                                    managedObjectContext: context,
                                                    sectionNameKeyPath: nil,
                                                    cacheName: nil)
        self.fetchedResultsController = controller
        super.init()
        controller.delegate = self
        try? controller.performFetch()
    }

    func fetchAllTrackerCategory() throws -> [TrackerCategoryCoreData]? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка при извлечении отслеживаемых данных TrackerCategoryCoreData: \(error.localizedDescription)")
            return nil
        }
    }
    
    func trackerCategoryCoreDataToModel(trackerCategoryCoreData: [TrackerCategoryCoreData]) -> [(String, [Tracker])] {
        var resultat = [(String, [Tracker])]()
        for category in trackerCategoryCoreData {
            var trackers = [Tracker]()
            category.trackers?.forEach{tracker in
                guard let tracker = tracker as? TrackerCoreData, let tracker = trackerMap(trackerCoreData: tracker) else { return }
                trackers.append(tracker)
            }
            if let categoryName = category.name { resultat.append((categoryName, trackers)) }
        }
        
        return resultat
    }
    
    func fetchAllReturnModel() -> [(String, [Tracker])] {
        do {
            let categoryCoreData = try fetchAllTrackerCategory()
            return trackerCategoryCoreDataToModel(trackerCategoryCoreData: categoryCoreData ?? [])
        } catch {
            return []
        }
    }
    
    func trackerMap(trackerCoreData: TrackerCoreData) -> Tracker? {
        guard let id = trackerCoreData.id,
              let name = trackerCoreData.name,
              let emoji = trackerCoreData.emoji,
              let color = trackerCoreData.color,
              let schedule = trackerCoreData.shedule else { return nil }
        
        return Tracker(id: id, name: name, emoji: emoji, color: СolorMarshalling.hecColor(from: color), schedule: ScheduleConverter.convertToArray(string: schedule), isPin: false)
    }
    
    
    func fetchTrackerCategory(name: String) -> TrackerCategoryCoreData? {
        let request = NSFetchRequest<TrackerCategoryCoreData>(entityName: "TrackerCategoryCoreData")
        do {
            let response = try context.fetch(request).first{ $0.name == name }
            return response
        } catch {
            print("Ошибка при извлечении отслеживаемых данных: \(error.localizedDescription)")
            return nil
        }
    }
    
    func addNewTrackerCategory(_ trackerCategory: String) throws {
        let trackerCategoryCoreData = TrackerCategoryCoreData(context: context)
        trackerCategoryCoreData.name = trackerCategory
        try context.save()
        print("Новая категория успешно добавлена в базу данных Core Data")
    }
    
    func updateTrackerCategory(trackerCategoryCoreData: TrackerCategoryCoreData, nameCategory: String) {
        trackerCategoryCoreData.name = nameCategory
    }
    
    func deleteTrackerCategory(_ trackerCategory: String) throws {
        if let trackerCategory = fetchTrackerCategory(name: trackerCategory) {
            context.delete(trackerCategory)
            try context.save()
        }
    }
    
    func categoryFromString(_ categoryName: String) throws -> TrackerCategoryCoreData {
        let newCategory = TrackerCategoryCoreData(context: context)
        newCategory.name = categoryName
        return newCategory
    }
}

extension TrackerCategoryCoreData {
    func toCategory() -> String {
        return self.name ?? ""
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedIndexes?.insert(sectionIndex)
        case .delete:
            deletedIndexes?.insert(sectionIndex)
        case .update:
            updatedIndexes?.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedFinalIndexes = insertedIndexes,
            let deletedFinalIndexes = deletedIndexes,
            let updatedFinalIndexes = updatedIndexes
        else { return }
    }
}
