import Foundation
import YandexMobileMetrica

// MARK: - ScreenName
enum ScreenName: String {
    case main = "Main"
    case statistics = "Statistics"
}

// MARK: - AnalyticsService
struct AnalyticsService {
    
    // MARK: - Events
    private enum Event: String {
        case open
        case close
        case click
    }
    
    // MARK: - Parameters
    private static let parametersScreenItem: [[AnyHashable: String]] = [
        ["screen": "Main", "item": "add_tracker"],
        ["screen": "Main", "item": "filter"],
        ["screen": "Main", "item": "edit"],
        ["screen": "Main", "item": "delete"],
        ["screen": "Main", "item": "tracker"],
        ["screen": "TrackersType", "item": "add_tracker"],
    ]
    
    // MARK: - Report
    private static func report(event: String, params: [AnyHashable: String]) {
        YMMYandexMetrica.reportEvent(event, parameters: params) { error in
            print("REPORT ERROR %@", error.localizedDescription)
        }
    }
    
    // MARK: - Functions
    static func openScreenReport(screen: ScreenName) {
        report(event: Event.open.rawValue, params: ["screen": "\(screen)"])
    }
    static func closeScreenReport(screen: ScreenName) {
        report(event: Event.close.rawValue, params: ["screen": "\(screen)"])
    }
    static func addTrackReport() {
        report(event: Event.click.rawValue, params: parametersScreenItem[0])
    }
    static func addFilterReport() {
        report(event: Event.click.rawValue, params: parametersScreenItem[1])
    }
    static func editTrackReport() {
        report(event: Event.click.rawValue, params: parametersScreenItem[2])
    }
    static func deleteTrackReport() {
        report(event: Event.click.rawValue, params: parametersScreenItem[3])
    }
    static func clickRecordTrackReport() {
        report(event: Event.click.rawValue, params: parametersScreenItem[4])
    }
    static func clickTrackerReport() {
        report(event: Event.click.rawValue, params: parametersScreenItem[5])
    }
}
