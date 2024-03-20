//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Алексей Гвоздков on 15.03.2024.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {
    // MARK: You can reset all results
    let reset = false
    
    // MARK: Snapshot tests - TrackersViewController
    func testTrackersViewControllerDarkTheme() {
        let viewController = TrackerViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .dark)), record: reset)
    }
    
    func testTrackersViewControllerLightTheme() {
        let viewController = TrackerViewController()
        sleep(1)
        assertSnapshot(of: viewController, as: .image(traits: UITraitCollection(userInterfaceStyle: .light)), record: reset)
    }
}
