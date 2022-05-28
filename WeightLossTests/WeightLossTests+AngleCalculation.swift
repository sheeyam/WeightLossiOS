//
//  WeightLossTests+AngleCalculation.swift
//  WeightLossTests
//
//  Created by Sheeyam Shellvacumar on 5/28/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import XCTest
@testable import WeightLoss

class WeightLossTests_AngleCalculation: XCTestCase {

    func testNewAngle(){
        let vc = HomeViewController()
        
        let result = vc.angleCalc.newAngle(consume: 100.0, spent: 50.0, target: 200.0)
        XCTAssertEqual(result, 90.0)
        
    }
    
    func testNewAngleSpent(){
        let vc = HomeViewController()
        
        let result = vc.angleCalc.newAngleSpent(spent: 1000.0, target: 200.0)
        XCTAssertEqual(result, 360)
        
    }
    
    func testNewAngleConsumed(){
        let vc = HomeViewController()
        
        let result = vc.angleCalc.newAngleConsumed(consumed: 2000.0, target: 1400.0)
        XCTAssertEqual(result, 360)
        
    }
}
