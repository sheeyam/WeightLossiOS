//
//  Utility.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/20/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation

func yesterday() -> Date {
    var dateComponents = DateComponents()
    dateComponents.setValue(-1, for: .day) // -1 day
    let yesterday = Calendar.current.date(byAdding: dateComponents, to: Date()) // Add the DateComponents
    return yesterday!
}

func tomorrow() -> Date {
    var dateComponents = DateComponents()
    dateComponents.setValue(1, for: .day) // +1 day
    let tomorrow = Calendar.current.date(byAdding: dateComponents, to: Date())  // Add the DateComponents
    return tomorrow!
}
