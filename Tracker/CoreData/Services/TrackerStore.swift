import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func trackerStore(didUpdate update: TrackerStoreUpdate)
}

class TrackerStore: NSObject {
    weak var delegate: TrackerStoreDelegate?
    private let trackerCategoryStore = TrackerCategoryStore()
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>
    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: [IndexPath]?
    private var updatedIndexes: [IndexPath]?
    
    convenience override init() {
        guard let application = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("не удалось получить application в TrackerStore")
        }
        let context = application.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        
        let request = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true)
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
    
    // MARK: - Create
    func addNewTracker(_ category: String, _ tracker: Tracker) throws {
        if let categoryData = trackerCategoryStore.fetchTrackerCategory(name: category) {
            saveTrackerCD(trackerCategoryCoreData: categoryData, tracker: tracker)
            try context.save()
        }
    }
    
    // MARK: - Read
    func fetchTrackersId(id: UUID) -> TrackerCoreData? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = idPredicate
        do {
            return try context.fetch(request).first
        } catch {
            print("Ошибка при извлечении отслеживаемых данных: \(error.localizedDescription)")
            return nil
        }
    }
    
    func allFetchTrackersId() -> [TrackerCoreData]? {
        let request = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")

        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка при извлечении отслеживаемых данных: \(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: - Update
    func saveTrackerCD(trackerCategoryCoreData: TrackerCategoryCoreData, tracker: Tracker) {
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.id = tracker.id
        trackerCoreData.name = tracker.name
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.color = СolorMarshalling.hexString(from: tracker.color)
        trackerCoreData.shedule = ScheduleConverter.convertToString(array: tracker.schedule)
        trackerCoreData.category = trackerCategoryCoreData
        trackerCoreData.isPin = tracker.isPin
    }
    
    
    func updateTracker(newCategory: String, tracker: Tracker, isPin: Bool? = nil) throws {
        let trackerCorData = fetchTrackersId(id: tracker.id)
        
        trackerCorData?.color = СolorMarshalling.hexString(from: tracker.color)
        trackerCorData?.emoji = tracker.emoji
        trackerCorData?.name = tracker.name
        trackerCorData?.shedule = ScheduleConverter.convertToString(array: tracker.schedule)
        if let resultPin = isPin {
            trackerCorData?.isPin = resultPin
        } else {
            trackerCorData?.isPin = tracker.isPin
        }
            try context.save()
    }
    
    func trackerMap(trackerCoreData: TrackerCoreData) -> Tracker {
        return Tracker(id: trackerCoreData.id ?? UUID(),
                       name:  trackerCoreData.name ?? "" ,
                       emoji: trackerCoreData.emoji ?? "",
                       color: СolorMarshalling.hecColor(from: trackerCoreData.color ?? ""),
                       schedule: ScheduleConverter.convertToArray(string: trackerCoreData.shedule ?? ""), 
                       isPin: trackerCoreData.isPin)
    }
      
    
    // MARK: - Delete
     func deleteTracker(_ tracker: Tracker) throws {
         if let trackerCoreData = fetchTrackersId(id: tracker.id) {
             context.delete(trackerCoreData)
             try context.save()
         }
     }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    //Этот метод вызывается, когда контроллер изменений обнаруживает изменение в управляемом объекте контекста и должен уведомить делегата о произошедших изменениях.
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            // Обработка добавления нового объекта
            if let newIndexPath = newIndexPath {
                insertedIndexes?.append(newIndexPath)
            }
        case .delete:
            // Обработка удаления объекта
            if let indexPath = indexPath {
                deletedIndexes?.append(indexPath)
            }
        case .update:
            // Обработка обновления объекта
            if let indexPath = indexPath {
                updatedIndexes?.append(indexPath)
            }
        case .move:
            // Обработка перемещения объекта
            if let indexPath, let newIndexPath {
                insertedIndexes?.append(newIndexPath)
                deletedIndexes?.append(indexPath)
            }
        @unknown default:
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
