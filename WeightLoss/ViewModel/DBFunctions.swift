//
//  DBFunctions.swift
//  WeightLoss
//
//  Created by Sheeyam Shellvacumar on 5/28/22.
//  Copyright © 2022 Sheeyam Shellvacumar. All rights reserved.
//

import Foundation
import CoreData

struct DBFunctions {
    func saveToDB(context: NSManagedObjectContext){
        do {
            try context.save() // <- remember to put this :)
        } catch {
            // Do something... fatalerror
        }
    }
}
