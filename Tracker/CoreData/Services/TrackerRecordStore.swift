import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func trackerRecordStore(didUpdate update: TrackerRecordStoreUpdate)
}

class TrackerRecordStore: NSObject {
    weak var delegate: TrackerRecordStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>
   
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
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
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
    
    func addNewTrackerRecord(_ trackerRecord: TrackerRecord) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        updateTrackerRecord(trackerRecordCoreData, trackerRecord)
        try context.save()
    }
    
    func fetchAllTrackerRecordCoreData(_ trackerRecord: [TrackerRecord]) throws -> [TrackerRecordCoreData]? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        do {
            return try context.fetch(request)
        } catch {
            print("Ошибка при извлечении TrackerRecordCoreData \(error.localizedDescription)")
            return [TrackerRecordCoreData]()
        }
    }
    
    func fetchTrackerRecordId(_ id: UUID, _ date: Date) -> TrackerRecordCoreData? {
        let request = NSFetchRequest<TrackerRecordCoreData>(entityName: "TrackerRecordCoreData")
        let idPredicate = NSPredicate(format: "id == %@", id as CVarArg)
        let datePredicate = NSPredicate(format: "date == %@", date as CVarArg)
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, datePredicate])
        
        request.predicate = compoundPredicate
        do {
            if let result = try context.fetch(request).first {
                return result
            } else {
                print("Данные не найдены для trackerId: \(id)")
                return nil
            }
        } catch {
            print("Ошибка при извлечении отслеживаемых данных: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteTracker(_ trackerId: UUID, _ date: Date) throws {
        if let trackerRecordCoreData = fetchTrackerRecordId(trackerId, date) {
            context.delete(trackerRecordCoreData)
            try context.save()
        }
    }
    
    func updateTrackerRecord(_ trackerRecordCoreData: TrackerRecordCoreData, _ trackerRecod: TrackerRecord) {
        trackerRecordCoreData.date = trackerRecod.date
        trackerRecordCoreData.id = trackerRecod.trackerId
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
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
