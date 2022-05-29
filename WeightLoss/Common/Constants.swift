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
    
    struct customCells {
        static let historyViewCellIdentifier = "historyViewCell"
        static let customConsumeCellIdentifier = "customConsumeCell"
    }
    
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
    
    struct icons {
        static let walking = "walking"
        static let standing = "standing"
        static let running = "running"
        static let driving = "driving"
    }
    
    struct activityStrings {
        static let walking = "Walking"
        static let stationary = "Stationary"
        static let running = "Running"
        static let automotive = "Automotive"
    }
    
    struct labelStrings {
        static let cals = "Cals"
        static let target = "Target:"
        static let netCals = "Net Calories:"
        
        static let consumedStr = "Consumed = "
        static let burntStr = "Burnt = "
        static let targetStr = "Target = "
    }
    
    struct alertStrings {
        static let add = "Add"
        static let choose = "Choose"
        static let cancel = "Cancel"
        static let addConsumptionTitle = "Add Consumption"
        static let addConsumptionMsg = "Add New/Choose Consumption"
        static let faceIDReason = "Please authorize with Face ID"
    }
    
    struct operations {
        static let add = "add"
        static let update = "update"
    }
    
    struct entities {
        static let food = "Food"
        static let consume = "Consume"
        
        struct keys {
            static let name = "name"
            static let date = "date"
            static let calorie = "calorie"
            static let type = "type"
            static let icalorie = "icalorie"
            static let count = "count"
        }
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
        static let color04 = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        static let color05 = UIColor(red: 236.0/255, green: 73.0/255, blue: 34.0/255, alpha: 0.4)
        static let color06 = UIColor(red: 79.0/255, green: 178.0/255, blue: 52.0/255, alpha: 0.4)
        static let color07 = UIColor(red: 255.0/255, green: 209.0/255, blue: 26.0/255, alpha: 0.4)
    }
    
    struct progressStrings {
        static let progressZero = "0%"
        static let progressHundred = "100%"
    }
}
