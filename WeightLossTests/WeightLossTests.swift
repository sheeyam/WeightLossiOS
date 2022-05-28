//
//  WeightLossTests.swift
//  WeightLossTests
//
//  Created by Sheeyam Shellvacumar on 5/28/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import XCTest
@testable import WeightLoss

class WeightLossTests: XCTestCase {

    func testControllerHasTableView() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ActivityViewController") as? ActivityViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        controller.loadViewIfNeeded()
        XCTAssertNotNil(controller.activityTableView, "Controller should have a tableview")
    }
    
    func testTableViewHasDataSource() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ActivityViewController") as? ActivityViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        controller.loadViewIfNeeded()
        XCTAssertTrue(controller.activityTableView.dataSource is ActivityViewController,
                      "TableView's datasource should be a ActivityViewController")
    }
    
    func testTableViewHasDelegate() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ActivityViewController") as? ActivityViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        controller.loadViewIfNeeded()
        XCTAssertTrue(controller.activityTableView.delegate is ActivityViewController,
                      "TableView's delegate should be a ActivityViewController")
    }
    
    func testNoOfSectionsInActivity() {
        guard let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ActivityViewController") as? ActivityViewController else {
            return XCTFail("Could not instantiate ViewController from main storyboard")
        }
        controller.loadViewIfNeeded()
        XCTAssertEqual(controller.activityTableView.numberOfSections, 0, "Tableview should have 1 Section")
    }

}
