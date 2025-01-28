//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Ilya Kuznetsov on 28.01.2025.
//

import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackerTests: XCTestCase {

    func testViewController() {
        let vc = TrackersViewController()

        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .dark)))
        assertSnapshot(of: vc, as: .image(traits: .init(userInterfaceStyle: .light)))
    }

}
