//
//  WeightLossTests+CalorieEquations.swift
//  WeightLossTests
//
//  Created by Sheeyam Shellvacumar on 5/31/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import XCTest
@testable import WeightLoss

class WeightLossTests_CalorieEquations: XCTestCase {
    func testGetNetCaloriesCount(){
        let vc = HistoryViewCell()
        
        let result = vc.calcBL.getNetCaloriesCount(consumedCalCount: 2000.0, spentCalCount: 1000.0, targetCalCount: 2000.0)
        XCTAssertEqual(result, 0.5)
        
    }
}
