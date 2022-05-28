//
//  AngleCalculator.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/19/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation

struct AngleCalculator {
    func newAngle(consume: Double, spent: Double, target: Double) -> Double {
        if consume > spent {
            if consume > 0 {
                if 360 * ((consume - spent) / target) <= 360 {
                    return 360 * ((consume - spent) / target)
                } else {
                    return 360
                }
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func newAngleSpent(spent: Double, target: Double) -> Double {
        let ratioValue = 360 * spent/target
        if ratioValue <= 360 {
            return ratioValue
        } else if ratioValue > 360 {
            return 360
        } else if ratioValue < 0 {
            return 0
        } else {
            return 360
        }
    }
    
    func newAngleConsumed(consumed: Double, target: Double) -> Double {
        let ratioValue = 360 * consumed/target
        if ratioValue <= 360 {
            return ratioValue
        } else if ratioValue > 360 {
            return 360
        } else if ratioValue < 0 {
            return 0
        } else {
            return 360
        }
    }
}
