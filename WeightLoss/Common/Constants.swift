//
//  Constants.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/19/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    static let commonDF = "MM.dd.yyyy"
    
    struct segues {
        static let authToHome = "auth2home"
        static let consumptionToAddnew = "consumptionToAddnew"
        static let consumptionToAdd = "consumptionToAdd"
    }
    
    struct meals {
        static let breakfast = "Breakfast"
        static let lunch = "Lunch"
        static let dinner = "Dinner"
        static let snacks = "Snacks"
    }
    
    struct userDefaultKeys {
        static let faceID = "FaceID"
        static let name = "Name"
        static let weight = "Weight"
        static let consumed = "ConsumedCal"
        static let target = "TargetCalCount"
        static let steps = "StepsCount"
        static let spent = "SpentCalCount"
    }
    
    struct colors {
        static let color01 = UIColor(red: 236.0/255, green: 73.0/255, blue: 34.0/255, alpha: 1)
        static let color02 = UIColor(red: 236.0/255, green: 199.0/255, blue: 52.0/255, alpha: 1)
        static let color03 = UIColor(red: 79.0/255, green: 178.0/255, blue: 52.0/255, alpha: 1)
    }
    
    struct progressStrings {
        static let progressZero = "0%"
        static let progressHundred = "100%"
    }
}
