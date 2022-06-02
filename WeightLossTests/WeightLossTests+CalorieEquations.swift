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
        
        //Consumed > Spent
        let result_1 = vc.calcBL.getNetCaloriesCount(consumedCalCount: 3000.0, spentCalCount: 1000.0, targetCalCount: 2000.0)
        XCTAssertEqual(result_1, 1.0)
        
        //Consumed < Spent
        let result_2 = vc.calcBL.getNetCaloriesCount(consumedCalCount: 500.0, spentCalCount: 1000.0, targetCalCount: 2000.0)
        XCTAssertEqual(result_2, 0.25)
        
    }
}
