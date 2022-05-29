//
//  Calculations.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/28/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation

struct Calculations {
    
    func getNetCaloriesCount(consumedCalCount: Double, spentCalCount: Double, targetCalCount: Double) -> Double? {
        var netCalCount: Double?
        if(consumedCalCount > spentCalCount) {
            netCalCount = (consumedCalCount - spentCalCount) / targetCalCount
        } else {
            netCalCount =  (spentCalCount - consumedCalCount) / targetCalCount
        }
        return netCalCount
    }
}
