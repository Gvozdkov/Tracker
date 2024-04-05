import Foundation

struct TrackerStoreUpdate {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
}

struct TrackerCategoryStoreUpdate {
    let insertedSectionIndexes: IndexSet
    let deletedSectionIndexes: IndexSet
    let updatedSectionIndexes: IndexSet
}

struct TrackerRecordStoreUpdate {
    let insertedIndexes: [IndexPath]
    let deletedIndexes: [IndexPath]
    let updatedIndexes: [IndexPath]
}
